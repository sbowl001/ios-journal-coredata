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
    
    // MARK: Networking
    let baseURL = URL(string: "https://journal-day3.firebaseio.com/")!
    typealias  CompletionHandler = (Error?) -> Void
    func put(entry: Entry, completion: @escaping CompletionHandler = { _ in}){
        
        let uuid = entry.identifier ?? UUID().uuidString
        entry.identifier = uuid
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            // The error is relatively clear here. It says that your
            // entry type doesn't have an entryRepresentation property
            // You'll need to add a computed property in entry+convenience
           let representation = entry.entryRepresentation
            
            request.httpBody  = try JSONEncoder().encode(representation)
            
        } catch {
            NSLog("error ecncoding task: \(entry) \(error)")
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
    
    func deleteEntryFromServer(_ entry: Entry, completion: @escaping CompletionHandler = {_ in}) {
        guard let uuid = entry.identifier else {
            completion(NSError())
            return
        }
        
        let requestURL = baseURL.appendingPathComponent(uuid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            print(response!)
            completion(error)
        } .resume()
        
    }
    
    
    
    
    func create(with title: String, bodyText: String, mood: Mood) {
        let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        // You haven't given your instance here a name
        // in order to pass it in, you need to replace the
        // underscore with whatever you want to call your
        // new instance
        
        // before:
        // let _ = Entry(title: title, bodyText: bodyText, mood: mood)
        
        // after:
        let entry = Entry(title: title, bodyText: bodyText, mood: mood)

        put(entry: entry)
        saveToPersistentStore()
    }
 

    
    func update(entry: Entry, title: String, bodyText: String, mood: Mood) {
        entry.title =  title
        entry.bodyText = bodyText
        entry.timestamp = Date()
        entry.mood = mood.rawValue
        put(entry: entry)
        saveToPersistentStore()
    }
 
    
    func delete(entry: Entry) {
        
        CoreDataStack.shared.mainContext.delete(entry)
    
        saveToPersistentStore()
        
    }
 
}
