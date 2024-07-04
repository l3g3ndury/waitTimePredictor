//
//  RideCardView.swift
//  WaitTimePredictor
//
//  Created by Loc Vu on 7/3/24.
//

import SwiftUI

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
