//
//  FlagTableView.swift
//  BLEDemo
//
//  Created by Duaa alharbi 1607217 - Doaa altawil 0932785
//

import UIKit

class FlagTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    //UITableViewDataSource: The methods adopted by the object you use to manage data and provide cells for a table view.
    
    var TimeStampArray = [String]()
    
    
    
    @IBOutlet weak var timeStampeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //functhion viewDidLoad to view has been loaded into memory
        
        timeStampeTableView.dataSource = self
        timeStampeTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TimeStampArray.count
        } //Returns the number of rows (table cells) in a specified section
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Returns the table cell at the specified index path
        
       let myCell = tableView.dequeueReusableCell(withIdentifier: "flagCell0", for: indexPath) as! FlagCellTableViewCell
        //Returns a reusable table-view cell object located by its identifier.
        
        myCell.timeStampLable.text = TimeStampArray[indexPath.row]
        print(TimeStampArray[indexPath.row])
        print(TimeStampArray.count)
        
        return myCell
    }
    


}
