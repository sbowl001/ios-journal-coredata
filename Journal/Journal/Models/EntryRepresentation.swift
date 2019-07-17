//
//  EntryRepresentation.swift
//  Journal
//
//  Created by Stephanie Bowles on 7/17/19.
//  Copyright © 2019 Stephanie Bowles. All rights reserved.
//

import Foundation

struct EntryRepresentation: Codable, Equatable {
    var title: String?
    var bodyText: String?
    var timestamp: Date?
    var identifier: String?
    var mood:  String?
}


func == (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return lhs.identifier == rhs.identifier &&
           lhs.title == rhs.title &&
           lhs.timestamp == rhs.timestamp &&
           lhs.bodyText == rhs.bodyText &&
           lhs.mood == rhs.mood
 
}

func == (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs == lhs
}

func != (lhs: EntryRepresentation, rhs: Entry) -> Bool {
    return !(rhs == lhs)
}

func != (lhs: Entry, rhs: EntryRepresentation) -> Bool {
    return rhs != lhs
}



