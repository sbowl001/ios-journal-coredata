//
//  EntryController.swift
//  Journal
//
//  Created by Stephanie Bowles on 7/11/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import CoreData

class EntryController {
//    Create a function called saveToPersistentStore(). This method should save your core data stack's mainContext. Remember that this will bundle the changes in the context, pass them to the persistent store coordinator who will then put those changes in the persistent store.
    
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }

    
//    func loadFromPersistentStore() -> [Entry] {
//        let fetchRequest : NSFetchRequest <Entry> = Entry.fetchRequest()
//        let moc = CoreDataStack.shared.mainContext
//        
//        do {
//            return try moc.fetch(fetchRequest)
//        } catch {
//            NSLog("Error fetching tasks: \(error)")
//            return []
//        }
//    }
//
//    var entries: [Entry] {
//        return loadFromPersistentStore()
//        
//    }
    
    
    func create(with title: String, bodyText: String, mood: Mood) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        saveToPersistentStore()
    }
//    Initialize an Entry object
//    Save it to the persistent store.
//    NOTE: if Xcode is giving you a warning that the Entry object isn't being used, you can make the constant's name _, or add the @discardableResult attribute to the Entry's convenience intializer in the extension you created.
    
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title =  title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        saveToPersistentStore()
    }
//    Create an "Update" CRUD method. The method should:
//    Have title and bodyText parameters as well as the Entry you want to update.
//    Change the title and bodyText of the Entry to the new values passed in as parameters to the function.
//    Update the entry's timestamp to the current time as well.
//    Save these changes to the persistent store.
//    Create a "Delete" CRUD method. This method should:
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
    
        saveToPersistentStore()
        
    }
//    Take an an Entry object to delete
//    Delete the Entry from the core data stack's mainContext
//    Save this deletion to the persistent store.

}
