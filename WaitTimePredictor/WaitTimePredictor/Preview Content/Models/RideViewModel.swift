//
//  ParkViewModel.swift
//  WaitTimePredictor
//
//  Created by Loc Vu on 7/3/24.
//

import SwiftUI

class RideViewModel: ObservableObject {
    static let shared = RideViewModel()
    
    init() { }
    
    @Published var currentRides = [
        Ride(name: "Avatar: Flight of Passage", park: .animalKingdom),
        Ride(name: "TRON: Lightcycle/Run", park: .magicKingdom),
        Ride(name: "Guardians of the Galaxy: Cosmic Rewind", park: .epcot),
        Ride(name: "Star Wars: Rise of the Resistance", park: .hollywoodStudios)
    ]
    
    @Published var parkSelection = [
        ParkSelection(id: 0, park: .all, selected: true),
        ParkSelection(id: 1, park: .animalKingdom, selected: false),
        ParkSelection(id: 2, park: .epcot, selected: false),
        ParkSelection(id: 3, park: .hollywoodStudios, selected: false),
        ParkSelection(id: 4, park: .magicKingdom, selected: false)
    ]
    
    func parkRowTapped(parkRow: ParkSelection) {
        
        // If a park other than 'all' is tapped, the 'all' selector will be false.
        // Otherwise, the 'all' selector will stay true regardless of how many times it is tapped.
        if parkRow.id != 0 {
            self.parkSelection[0].selected = false
            self.parkSelection[parkRow.id].selected.toggle()
        } else {
            self.parkSelection[0].selected = true
        }
        
        self.currentRides = self.currentRides.filter {
            $0.park == self.parkSelection[parkRow.id].park
        }
    }
}
