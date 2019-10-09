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

        let mood: Mood
        if let entryMood = entry?.mood {
            mood = Mood(rawValue: entryMood)!
        } else {
            mood = .neutral
        }
        
        segmentedControl.selectedSegmentIndex = Mood.allCases.firstIndex(of: mood)!
        //Need some more explanation on this part vs the selectedSegmentIndex of saveJournal below
    }
    @IBAction func saveJournal(_ sender: Any) {
        guard let entryTitle = self.titleField.text, !entryTitle.isEmpty,
        let body = entryView.text, !body.isEmpty else {return}
        
        let moodIndex = segmentedControl.selectedSegmentIndex
        let mood = Mood.allCases[moodIndex]
        
        if let entry = entry {
//            entryController?.update(entry: entry, title: entryTitle, bodyText: body, mood: mood)
            entry.title = entryTitle
            entry.mood = mood.rawValue
            entry.bodyText = body
            entryController?.put(entry: entry)
            
        } else {
//            entryController?.create(with: entryTitle, bodyText: body, mood: mood   )
            let entry = Entry(title: entryTitle , bodyText: body,  mood: mood)
            entryController?.put(entry: entry)
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
