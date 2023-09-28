//
//  RestaurantDetailView.swift
//  Bintaro Food
//
//  Created by Sorfian on 27/09/23.
//

import SwiftUI

struct RestaurantDetailView: View {
    var restaurant: Restaurant
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            
            Color.black
                .frame(height: 100)
                .opacity(0.8)
                .cornerRadius(20)
                .padding()
                .overlay {
                    VStack(spacing: 5, content: {
                        Text(restaurant.name)
                        Text(restaurant.type)
                        Text(restaurant.location)
                    }) 
                    .font(.system(.headline, design: .rounded))
                    .foregroundColor(.white)
                }
        })
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("\(Image(systemName: "chevron.left")) \(restaurant.name)")
                }

            }
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(restaurant: Restaurant(name: "Cafe Deadend", type: "Cafe", location: "Hong Kong", image: "cafedeadend", isFavorite: true))
    }
}
