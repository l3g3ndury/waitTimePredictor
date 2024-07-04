//
//  Park.swift
//  WaitTimePredictor
//
//  Created by Loc Vu on 7/3/24.
//

import SwiftUI

enum Park {
    case all
    case animalKingdom
    case magicKingdom
    case epcot
    case hollywoodStudios
    
    var name: String {
        switch self {
        case .all:
            return "All"
        case .animalKingdom:
            return "Animal Kingdom"
        case .magicKingdom:
            return "Magic Kingdom"
        case .epcot:
            return "EPCOT"
        case .hollywoodStudios:
            return "Hollywood Studios"
        }
    }
}

struct ParkSelection: Identifiable {
    var id: Int
    var name: String
    var park: Park
    var selected: Bool
    
    init(id: Int, park: Park, selected: Bool) {
        self.id = id
        self.park = park
        self.name = park.name
        self.selected = selected
    }
}

struct Ride: Identifiable {
    var id = UUID()
    var name: String
    var park: Park
}
