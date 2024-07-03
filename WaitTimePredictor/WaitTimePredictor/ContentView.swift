//
//  ContentView.swift
//  WaitTimePredictor
//
//  Created by Loc Vu on 6/30/24.
//

import SwiftUI

struct ContentView: View {
    @State var isFilterTapped = false
    @State private var sheetHeight: CGFloat = .zero
    
    var rides: [Ride] = RideViewModel.shared.currentRides
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button ("Filter") {
                        isFilterTapped.toggle()
                    }
                    .font(.title2)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(.clear)
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                
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
            }
            .edgesIgnoringSafeArea(.horizontal)
            .navigationTitle("Wait Time Predictor")
        }
        .sheet(isPresented: $isFilterTapped, content: {
            FilterView(isFilterTapped: $isFilterTapped)
                .modifier(GetHeightModifier(height: $sheetHeight))
                .presentationDetents([.height(sheetHeight)])
        })
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

struct FilterView: View {
    @Binding var isFilterTapped: Bool
    @StateObject var rideViewModel = RideViewModel.shared
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                isFilterTapped.toggle()
            } label: {
                Image(systemName: "xmark")
            }
        }
        .padding()
        
        Text("Select park to be filtered.")
            .font(.title2)
            .fontWeight(.bold)
        
        VStack {
            ForEach(rideViewModel.parkSelection) { parkOption in
                HStack {
                    Image(systemName: parkOption.selected ? "checkmark.circle.fill" : "circle")
                    
                    Text(parkOption.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .contentShape(Rectangle())
                .onTapGesture {
                    rideViewModel.parkRowTapped(parkRow: parkOption)
                }
            }
        }
        .padding()
    }
}

struct Ride: Identifiable {
    var id = UUID()
    var name: String
    var park: Park
}

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

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

#Preview {
    ContentView()
}
