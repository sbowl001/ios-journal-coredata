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
    
    
    init() {
        fetchEntriesFromServer()
    }
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
    
    
    func fetchSingleEntryFromPersistentStore(identifier: String) -> Entry? {
        let fetchRequest: NSFetchRequest<Entry> = Entry.fetchRequest()
        fetchRequest.predicate  = NSPredicate(format: "identifier == %@", identifier)
        
        do {
            let moc = CoreDataStack.shared.mainContext
            return try  moc.fetch(fetchRequest).first
        } catch {
            NSLog("Error fetching task with identifier \(identifier) : \(error)")
            return nil
        }
    }
 
    func fetchEntriesFromServer(completion: @escaping CompletionHandler = { _ in} ){
        let requestURL = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        var entryRepresentations: [EntryRepresentation] = []
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error)  in
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("no data returned by data task")
                completion(NSError())
                return
            }
            
            do {
                entryRepresentations = Array(try JSONDecoder().decode([String: EntryRepresentation].self, from: data).values)
                for entryRepresentation in entryRepresentations {
                    let identifier = entryRepresentation.identifier
                    if let entry = self.fetchSingleEntryFromPersistentStore(identifier:  identifier!) {
                        
                        self.updateEntry(entry: entry, with: entryRepresentation)
                 
                    } else {
                        let _ = Entry(entryRepresentation: entryRepresentation)
                    }

                }
                self.saveToPersistentStore()
                completion(nil)
            } catch {
                NSLog("error decoding entry representations: \(error)")
                completion(error)
                return
            }
        } .resume()
    }
    
 
    
    
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
    
    private func updateEntry(entry: Entry, with representation: EntryRepresentation) {
        entry.title = representation.title
        entry.bodyText = representation.bodyText
        entry.mood = representation.mood
        entry.timestamp = representation.timestamp
    }
    //Why do we do this? wasnt this the purpose of the "==' functions?
    
    func create(with title: String, bodyText: String, mood: Mood) {
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
        
        deleteEntryFromServer(entry)
        CoreDataStack.shared.mainContext.delete(entry)
    
        saveToPersistentStore()
        
    }
 
}
