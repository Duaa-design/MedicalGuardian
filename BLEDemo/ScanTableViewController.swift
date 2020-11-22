//
//  ScanTableViewController.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit
import CoreBluetooth

class ScanTableViewController: UITableViewController, CBCentralManagerDelegate {
    //CBCentralManagerDelegate: A protocol that provides updates for the discovery and management of peripheral devices
    
    var peripherals:[CBPeripheral] = []
    var manager:CBCentralManager? = nil //objects manage discovered or connected remote peripheral devices
    var parentView:MainViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //functhion viewDidLoad to view has been loaded into memory
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scanBLEDevices()
        //when the view controller’s view is fully transitioned onto the screen.
    }    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }//The number of sections in the collection view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return peripherals.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scanTableCell", for: indexPath) //dequeueReusableCell: This method returns an existing cell of the specified type
        let peripheral = peripherals[indexPath.row]
        cell.textLabel?.text = peripheral.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let peripheral = peripherals[indexPath.row]
        
        manager?.connect(peripheral, options: nil)
    }
    
    // MARK: BLE Scanning
    func scanBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)
        
        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        manager?.scanForPeripherals(withServices: [CBUUID.init(string: "DFB0")], options: nil)
        
        //stop scanning after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.stopScanForBLEDevices()
        }
    }
    
    func stopScanForBLEDevices() {
        manager?.stopScan()
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if(!peripherals.contains(peripheral)) {
            peripherals.append(peripheral)
        }
        //centralManager : tells the delegate that the central manager connected to a peripheral
        //RSSI : Get the RSSI device (if connected) If the RSSI is within the golden range
        //rssi : The Received Signal Strength Indicator (RSSI), in decibels, of the peripheral.
        
        self.tableView.reloadData()
    }
    

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(central.state)
        //function to tells the delegate the central manager’s state updated.
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        //pass reference to connected peripheral to parent view
        parentView?.mainPeripheral = peripheral
        peripheral.delegate = parentView
        peripheral.discoverServices(nil)
        
        //set the manager's delegate view to parent so it can call relevant disconnect methods
        manager?.delegate = parentView
        parentView?.customiseNavigationBar()
        
        if let navController = self.navigationController { //navigation controller:The nearest ancestor in the view controller
            navController.popViewController(animated: true)
            //Pops the top view controller from the navigation stack and updates the display.
        }
        
        print("Connected to " +  peripheral.name!)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(error!)
        //the delegate that the central manager connected to a peripheral
    }
    
}
