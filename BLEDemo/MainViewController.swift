//
//  MainViewController.swift
//  CompassCompanion
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit
import CoreBluetooth
import Firebase
import Charts




class MainViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
  
        
   
    
    var manager:CBCentralManager? = nil
    var mainPeripheral:CBPeripheral? = nil
    var mainCharacteristic:CBCharacteristic? = nil
    var unique = [String]()
    var previousValue: Double? = nil
    var currentValue: Double? = nil
    var differenceHolder: Int? = nil
    var tsFlagHolder = [String]()
    
    @IBOutlet weak var getDataButton: UIButton!
    @IBOutlet weak var currentHeartRateLable: UILabel!
    
    
    
    //let FlagTableViewObj: FlagTableView? = nil
    
    
        let DB = Database.database().reference()
    let ref = "https://engr697fixed.firebaseio.com"
   
    @IBOutlet weak var monthTextField: UITextField!
    var m = String()
    
    @IBOutlet weak var dayTextField: UITextField!
     var d = String()
    
    @IBOutlet weak var yearTextField: UITextField!
     var y = String()
    
    
    @IBOutlet weak var getYourHeartActivitesOn: UILabel!
    
    @IBOutlet weak var FlagButton: UIButton!
    
    @IBOutlet weak var lineChart1: LineChartView!
    
    
    let BLEService = "DFB0"
    let BLECharacteristic = "DFB1"
    
    @IBOutlet weak var recievedMessageText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if(tsFlagHolder.isEmpty){
            
            FlagButton.setTitle("", for: [])
            FlagButton.isEnabled = false
            }
        
        manager = CBCentralManager(delegate: self, queue: nil);
        
        print(DB)

        customiseNavigationBar()
        
    }
    
    
   
    // function to create custom navication bar
    
    func customiseNavigationBar () {
        
        self.navigationItem.rightBarButtonItem = nil
        
        let rightButton = UIButton()
        
        if (mainPeripheral == nil) {
            rightButton.setTitle("Scan", for: [])
            rightButton.setTitleColor(UIColor.blue, for: [])
            rightButton.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 60, height: 30))
            rightButton.addTarget(self, action: #selector(self.scanButtonPressed), for: .touchUpInside)
        } else {
            rightButton.setTitle("Disconnect", for: [])
            rightButton.setTitleColor(UIColor.blue, for: [])
            rightButton.frame = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 100, height: 30))
            rightButton.addTarget(self, action: #selector(self.disconnectButtonPressed), for: .touchUpInside)
        }
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    
    
    // function to prepare the destination from the main view to 2 identifiers ( scan view, flag view )
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "scan-segue") {
            let scanController : ScanTableViewController = segue.destination as! ScanTableViewController
            
            //set the manager's delegate to the scan view so it can call relevant connection methods
            manager?.delegate = scanController
            scanController.manager = manager
            scanController.parentView = self
        }
        
        if(segue.identifier == "toFlagTableView"){
            
            var flagTableView = segue.destination as! FlagTableView
            flagTableView.TimeStampArray.append(contentsOf: self.unique)
            
        }
        
    }
    
    
    // MARK: Button Methods
    @objc func scanButtonPressed() {
        performSegue(withIdentifier: "scan-segue", sender: nil)
    }
    
    @objc func disconnectButtonPressed() {
        //this will call didDisconnectPeripheral, but if any other apps are using the device it will not immediately disconnect
        manager?.cancelPeripheralConnection(mainPeripheral!)
    }
    
  
    
    
    // MARK: - CBCentralManagerDelegate Methods
    
    // function to tell the delegate  manager disconnected from a peripheral
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        mainPeripheral = nil
        customiseNavigationBar()
        print("Disconnected" + peripheral.name!)
    }
    
    
    
    //  function to tell the delegate to update the state
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
    }
    
    
    
    
    // MARK: CBPeripheralDelegate Methods
    
    // function to show a generic identifier common to every Bluetooth device (universally unique identifieridentifier)
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        for service in peripheral.services! {
            
            print("Service found with UUID: " + service.uuid.uuidString)
            
            //device information service
            if (service.uuid.uuidString == "180A") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //GAP (Generic Access Profile) for Device Name
            // This replaces the deprecated CBUUIDGenericAccessProfileString
            if (service.uuid.uuidString == "1800") {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
            //Bluno Service
            if (service.uuid.uuidString == BLEService) {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
        }
    }
    
    
    
    
    // function to discovering the peripheral’s services and characteristics.
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {

        //get device name
        if (service.uuid.uuidString == "1800") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A00") {
                    peripheral.readValue(for: characteristic)
                    print("Found Device Name Characteristic")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == "180A") {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == "2A29") {
                    peripheral.readValue(for: characteristic)
                    print("Found a Device Manufacturer Name Characteristic")
                } else if (characteristic.uuid.uuidString == "2A23") {
                    peripheral.readValue(for: characteristic)
                    print("Found System ID")
                }
                
            }
            
        }
        
        if (service.uuid.uuidString == BLEService) {
            
            for characteristic in service.characteristics! {
                
                if (characteristic.uuid.uuidString == BLECharacteristic) {
                    //we'll save the reference, we need it to write data
                    mainCharacteristic = characteristic
                    
                    //Set Notify is useful to read incoming data async
                    peripheral.setNotifyValue(true, for: characteristic)
                    print("Found Bluno Data Characteristic")
                }
                
            }
            
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        if (characteristic.uuid.uuidString == "2A00") {
            //value for device name recieved
            let deviceName = characteristic.value
            print(deviceName ?? "No Device Name")
        } else if (characteristic.uuid.uuidString == "2A29") {
            //value for manufacturer name recieved
            let manufacturerName = characteristic.value
            print(manufacturerName ?? "No Manufacturer Name")
        } else if (characteristic.uuid.uuidString == "2A23") {
            //value for system ID recieved
            let systemID = characteristic.value
            print(systemID ?? "No System ID")
        } else if (characteristic.uuid.uuidString == BLECharacteristic) {
            //data recieved
            if(characteristic.value != nil) {
                
                if let valueFromBLE = String(data: characteristic.value!, encoding: String.Encoding.utf8){
                
                let stringValue = valueFromBLE
                   
                    let test = String(stringValue.filter { !"\r\n".contains($0) })
                    
                        currentTime(theValue: test)

                    recievedMessageText.text = test
                    
                }
}
}
}
    
    
    
   
    //  function to take the value of heart rate and current time then to send the value to firebase.
    
   @objc func currentTime(theValue: String){
        
        var date = Date()
        var calendar = Calendar.current
        var Year = calendar.component(.year, from: date)
        var Month = calendar.component(.month, from: date)
        var Day = calendar.component(.day, from: date)
        var Hour = calendar.component(.hour, from: date)
        var Min = calendar.component(.minute, from: date)
        var Sec = calendar.component(.second, from: date)
        
    var child0 = DB.child("\(Month)-\(Day)-\(Year)")
        
    let dataSaved = ["TimeStamp ": "\(Hour):\(Min):\(Sec)", "HeartRate": "\(theValue)"]
        
        child0.childByAutoId().setValue(dataSaved)
    
    dataRetriever(year: Year, month: Month, day: Day, hour: Hour, min: Min, sec: Sec)
    
    }
    
    
    
    // function to Retriever current data for a heartbeat and display as chart
    
    func dataRetriever(year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int){
        var heartRateArray = [Double]()
        var TimeStamp = String()
        
        let child1 = DB.child("\(month)-\(day)-\(year)").observe(.childAdded) { (DataSnapshot) in
            
            let dataBaseValue = DataSnapshot.value as? Dictionary<String,String>
            
            if let timeStampDataBase = dataBaseValue?["TimeStamp "] {
                
                TimeStamp = timeStampDataBase
                
            }
            if let heartBeatFromDataBase = dataBaseValue?["HeartRate"]{
                
                var heartRateRetrived = heartBeatFromDataBase
                
                if(heartRateRetrived.contains("#")){ //maybe a problem here
                    
                    var test = String(heartRateRetrived.filter { !"#".contains($0) })
                    
                    if(test == ""){
                        
                        test = "50"
                        
                    }
                    
                    if let heartRateRetrivedToDouble = Double(test){
                        
                        var toDouble = heartRateRetrivedToDouble
                            heartRateArray.append(toDouble)
                    }
                    
                    self.tsFlagHolder.append(TimeStamp)
                    self.unique = Array(Set(self.tsFlagHolder))
                    self.FlagButton.setTitle("Flags", for: [])
                    self.FlagButton.isEnabled = true
                    self.FlagButton.tintColor = UIColor.red
                    self.theChart(hR: heartRateArray)
                    
                }else{
                
              
                    if(heartRateRetrived == ""){
                        
                        heartRateRetrived = "50"
                        
                    }
                    
                    if let heartRateRetrivedToDouble = Double(heartRateRetrived){
                    
                        var toDouble = heartRateRetrivedToDouble
                        
                        heartRateArray.append(toDouble)
                        
                    }
             
                     self.theChart(hR: heartRateArray)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    // function to display heartbeat as chart
    
    func theChart(hR: [Double]){
        
        var lineChartEntry = [ChartDataEntry]()
    for i in 0..<hR.count{
      
        let values = ChartDataEntry(x: Double(i), y: hR[i])
            lineChartEntry.append(values)
            }
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Heart Rate")
        
        line1.colors = [NSUIColor.red]
        
        let data = LineChartData()
        data.addDataSet(line1)
        line1.valueTextColor = UIColor.white
        lineChart1.tintColor = UIColor.white
        lineChart1.xAxis.axisLineColor = UIColor.white
        lineChart1.xAxis.labelTextColor = UIColor.white // this is the one
        lineChart1.rightAxis.labelTextColor = UIColor.white // the one
        lineChart1.leftAxis.labelTextColor = UIColor.white // the one
        
        lineChart1.data = data
            
            
        }
    
    
  
    
    @IBAction func flagButtonIsPressed(_ sender: Any) {
            performSegue(withIdentifier: "toFlagTableView", sender: self)
        
    }
    
    
    
    //function button get data
    
    @IBAction func getDataButtonPressed(_ sender: Any) {
        
        m = monthTextField.text!
        d = dayTextField.text!
        y = yearTextField.text!
        if(m.isEmpty || d.isEmpty || y.isEmpty){
            
          getYourHeartActivitesOn.text = "Please enter date"
            
        }else{
           
            tsFlagHolder = []
            self.unique = []
            FlagButton.setTitle("", for: [])
            FlagButton.isEnabled = false
            lineChart1.clear()
            recievedMessageText.text = ""
            currentHeartRateLable.text = ""
            getOldHeartRate(month: m, day: d, year: y)
            
            
        }
        
        
    }
    
    
    
    
    // function to get old heartbeat data
    
    func getOldHeartRate(month: String, day: String, year: String){
        
        var OldheartRateArray = [Double]()
        var OldTimeStamp = String()
        
        let Oldchild1 = DB.child("\(month)-\(day)-\(year)").observe(.childAdded) { (DataSnapshot) in
            
            let OlddataBaseValue = DataSnapshot.value as? Dictionary<String,String>
            
            if let OldtimeStampDataBase = OlddataBaseValue?["TimeStamp "] {
                
                OldTimeStamp = OldtimeStampDataBase
                
            }
            if let OldheartBeatFromDataBase = OlddataBaseValue?["HeartRate"]{
                
                var OldheartRateRetrived = OldheartBeatFromDataBase
                
                if(OldheartRateRetrived.contains("#")){
                    
                     var Oldtest = String(OldheartRateRetrived.filter { !"#".contains($0) })
                    
                    
                    if(Oldtest == ""){
                        
                        
                        Oldtest = "50"
                        
                    }
                    
                    if let OldheartRateRetrivedToDouble = Double(Oldtest){
                        
                       var OldToDouble = OldheartRateRetrivedToDouble
                        
                        OldheartRateArray.append(OldToDouble)
                        
                    }
                    
                    self.tsFlagHolder.append(OldTimeStamp)
                    self.unique = Array(Set(self.tsFlagHolder))
                    self.FlagButton.setTitle("Flags", for: [])
                    self.FlagButton.isEnabled = true
                    self.FlagButton.tintColor = UIColor.red
                    
                    self.theChart(hR: OldheartRateArray)
                    
                    
                }else{
                    
                
                    
                    if(OldheartRateRetrived == ""){
                        
                        OldheartRateRetrived = "50"
                        
                    }
                    
                    if let OldheartRateRetrivedToDouble = Double(OldheartRateRetrived){
                        
                        var OldToDouble = OldheartRateRetrivedToDouble
                        
                    OldheartRateArray.append(OldToDouble)
                    
                    self.theChart(hR: OldheartRateArray)
                    }
                    
                }
                
            }
        
        
    }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        monthTextField.resignFirstResponder()
        dayTextField.resignFirstResponder()
        yearTextField.resignFirstResponder()
       
        
        return(true)
        
    }
    
  

}

