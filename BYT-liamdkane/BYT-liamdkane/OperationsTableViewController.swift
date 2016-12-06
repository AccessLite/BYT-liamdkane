//
//  OperationsTableViewController.swift
//  BYT-liamdkane
//
//  Created by C4Q on 11/26/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class OperationsTableViewController: UITableViewController {

    var operations: [FoaasOperation] = FoaasDataManager.shared.operations ?? []
    private let cellIdentifier = "operationsCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Operations"
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        cell.textLabel?.text = operations[indexPath.row].name
        return cell
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
      // This has to dismiss the nav stack
      self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "previewSegue" {
            let cellIndex = self.tableView.indexPath(for: sender as! UITableViewCell)!.row
            
            // this is probably one of the few places there is a convention for a variable shorthand
            // "dtvc" is widely understood as "destination view controller" in the context of a segue
            let dtvc = segue.destination as! PreviewViewController
            dtvc.operation = self.operations[cellIndex]
        }
    }

}
