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
    func saveToPersistentStore(){
        let moc = CoreDataStack.shared.mainContext
        do {
            try moc.save()
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    let baseURL = URL(string: "https://journal-day3.firebaseio.com/")!
    typealias  CompletionHandler = (Error?) -> Void
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in}){
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
           let representation = entry.entryRepresentation
            
            request.httpBody  = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("error ecncoding task: \(task) \(error)")
            completion(error)
            return
            
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error putting task to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        } .resume()
        
        
    }
    
    
    func create(with title: String, bodyText: String, mood: Mood) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        put(entry: entry)
        saveToPersistentStore()
    }
//    Initialize an Entry object

    
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title =  title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        put(entry: entry)
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
