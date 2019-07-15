//
//  EntriesTableViewController.swift
//  Journal
//
//  Created by Stephanie Bowles on 7/11/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit

class EntriesTableViewController: UITableViewController {

    
    let entryController = EntryController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

  

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entryController.entries.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JournalCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()}

        let entry = entryController.entries[indexPath.row]
        
        cell.entry = entry 

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

  
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = entryController.entries[indexPath.row]
            entryController.delete(entry: entry)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddJournal" {
            guard let destinationVC = segue.destination as? EntryDetailViewController else {return}
            destinationVC.entryController = entryController 
        }
        if segue.identifier == "ShowDetail" {
            guard let detailVC = segue.destination as? EntryDetailViewController,
            let indexPath = self.tableView.indexPathForSelectedRow else {return}
            detailVC.entry = self.entryController.entries[indexPath.row]
            detailVC.entryController = entryController
        }
    }
 

}
