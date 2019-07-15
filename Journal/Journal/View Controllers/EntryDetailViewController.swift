//
//  EntryDetailViewController.swift
//  Journal
//
//  Created by Stephanie Bowles on 7/11/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    @IBOutlet weak var titleField: UITextField!
    
    
    @IBOutlet weak var entryView: UITextView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var entry: Entry? {
        didSet {
            self.updateViews()
        }
    }
    var entryController: EntryController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()

        // Do any additional setup after loading the view.
    }
    
    func updateViews() {
        guard isViewLoaded else {return}
        self.title = self.entry?.title ?? "Create Entry"
        self.titleField.text  = entry?.title
        self.entryView.text = entry?.bodyText
    }
    @IBAction func saveJournal(_ sender: Any) {
        guard let entryTitle = self.titleField.text, !entryTitle.isEmpty,
        let body = entryView.text, !body.isEmpty else {return}
        
        if let entry = entry {
            entryController?.update(entry: entry, title: entryTitle, bodyText: body)
        } else {
            entryController?.create(with: entryTitle, bodyText: body   )
        }
        self.navigationController?.popViewController(animated: true)
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
