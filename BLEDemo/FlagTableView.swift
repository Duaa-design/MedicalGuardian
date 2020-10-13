//
//  FlagTableView.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit

class FlagTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    var TimeStampArray = [String]()
    
    
    
    @IBOutlet weak var timeStampeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeStampeTableView.dataSource = self
        timeStampeTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeStampArray.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let myCell = tableView.dequeueReusableCell(withIdentifier: "flagCell0", for: indexPath) as! FlagCellTableViewCell
        
        myCell.timeStampLable.text = TimeStampArray[indexPath.row]
        print(TimeStampArray[indexPath.row])
        print(TimeStampArray.count)
        
        return myCell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
