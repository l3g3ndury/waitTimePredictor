//
//  ParkFilterOptionsView.swift
//  WaitTimePredictor
//
//  Created by Loc Vu on 7/3/24.
//

import SwiftUI

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
