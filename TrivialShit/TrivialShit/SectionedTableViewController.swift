//
//  SectionedTableViewController.swift
//  TrivialShit
//
//  Created by C4Q on 11/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class SectionedTableViewController: UITableViewController {
    
    var dataArray = [Int]()
    let q = 2
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for x in 0..<20 {
            dataArray.append(x)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let sectionData = self.dataArray.filter {(n: Int) in
            return n % q == 0
        }
        return q
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = self.dataArray.filter {(n: Int) in
            return n < (dataArray.count / abs(section - q))
        }
        return sectionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let sectionData = self.dataArray.filter {(n: Int) in
            return n < dataArray[dataArray.count / abs(indexPath.section - q)]
            
        }
        
        cell.textLabel?.text = String(sectionData[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return String(self.dataArray[self.dataArray.count - 1 - section])
        return "Section: Element % \(q) = \(section)"
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

/*
 class SectionedTableViewController: UITableViewController {
 
 var dataArray = [Int]()
 //    let denominator = 5
 let range = 5
 override func viewDidLoad() {
 super.viewDidLoad()
 
 for i in 0..<53 {
 dataArray.append(i)
 }
	}
 
 // MARK: - Table view data source
 
 override func numberOfSections(in tableView: UITableView) -> Int {
 return dataArray.last!/range + 1
 }
 
 override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 let sectionData = self.dataArray.filter {(n: Int) in
 return n/range == section
 }
 return sectionData.count
 }
 
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 let sectionData = self.dataArray.filter {(n: Int) in
 return n/range == indexPath.section
 }
 
 cell.textLabel?.text = String(sectionData[indexPath.row])
 return cell
 }
 
 override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
 
 
 return "\(range*section) to \(range*section + (range-1))"
 }
 }
 */

URLSession(configuration: .)
