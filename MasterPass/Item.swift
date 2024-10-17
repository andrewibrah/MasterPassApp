//
//  Item.swift
//  MasterPass
//
//  Created by Andrew Ibrahem on 10/16/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
