//
//  Entry+Convenience.swift
//  Journal
//
//  Created by Stephanie Bowles on 7/11/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation
import CoreData

enum Mood: String, CaseIterable {
    case sad  =  "😟"
    case neutral = "😒"
    case happy = "😃"

}

extension Entry {
    
    var entryRepresentation: EntryRepresentation? {
        return EntryRepresentation(title: title, bodyText: bodyText, timestamp: timestamp, identifier: identifier, mood: mood)
    }
    convenience init (title: String, bodyText: String? = nil, timestamp: Date = Date(), identifier: String  = UUID().uuidString, mood: Mood = .neutral, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.identifier = identifier
        self.mood = mood.rawValue
    }
    
    convenience init? (entryRepresentation: EntryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let mood = Mood(rawValue: entryRepresentation.mood! ),
              let timestamp = entryRepresentation.timestamp,
              let title = entryRepresentation.title,
              let bodyText = entryRepresentation.bodyText,
              let identifier = entryRepresentation.identifier else {return nil}
        self.init(title: title,
                  bodyText: bodyText,
                  timestamp: timestamp,
                  identifier: identifier,
                  mood: mood,
                  context: context )
    }
}
 
