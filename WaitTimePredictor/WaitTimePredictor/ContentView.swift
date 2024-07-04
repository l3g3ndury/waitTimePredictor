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
                    .font(.title3)
                    .background(.clear)
                    .foregroundColor(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Wait Time Predictor")
                            .font(.title)
                            .bold()
                          .foregroundColor(Color.black)
                    }
                }
            }
        }
        .sheet(isPresented: $isFilterTapped, content: {
            FilterView(isFilterTapped: $isFilterTapped)
                .modifier(GetHeightModifier(height: $sheetHeight))
                .presentationDetents([.height(sheetHeight)])
        })
    }
}

#Preview {
    ContentView()
}
