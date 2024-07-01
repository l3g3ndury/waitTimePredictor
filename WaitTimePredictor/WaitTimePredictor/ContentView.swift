//
//  ContentView.swift
//  WaitTimePredictor
//
//  Created by Loc Vu on 6/30/24.
//

import SwiftUI

struct ContentView: View {
    var rides: [Ride] = RideList.currentRides
    
    var body: some View {
        NavigationView {
            List {
                ForEach(rides, id: \.id) { ride in
                    RideCardView(ride: ride)
                }
                .padding(.vertical, 10)
                .listRowBackground(RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(.white))
                    .padding(
                        EdgeInsets(
                            top: 5,
                            leading: 5,
                            bottom: 5,
                            trailing: 5
                        )
                    ))
                .listRowSeparator(.hidden)
            }
            .edgesIgnoringSafeArea(.horizontal)
            .navigationTitle("Wait Time Predictor")
        }
    }
}

struct RideCardView: View {
    let ride: Ride
    
    var body: some View {
        VStack(alignment: .leading) {
            Rectangle()
                .frame(height: 120)
                .cornerRadius(10)
            Text(ride.name)
                .font(.title2)
                .fixedSize(horizontal: false, vertical: true)
                .fontWeight(.medium)
            Text(ride.park.name)
                .font(.headline)
                .fontWeight(.light)
        }
        .background(Color.white)

    }
}

struct Ride: Identifiable {
    var id = UUID()
    var name: String
    var park: Park
}

enum Park {
    case animalKingdom
    case magicKingdom
    case epcot
    case hollywoodStudios
    
    var name: String {
        switch self {
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


struct RideList {
    static let currentRides = [
        Ride(name: "Avatar: Flight of Passage", park: .animalKingdom),
        Ride(name: "TRON: Lightcycle/Run", park: .magicKingdom),
        Ride(name: "Guardians of the Galaxy: Cosmic Rewind", park: .epcot),
        Ride(name: "Star Wars: Rise of the Resistance", park: .hollywoodStudios)
    ]
}

#Preview {
    ContentView()
}
