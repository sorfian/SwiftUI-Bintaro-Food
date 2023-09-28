//
//  ContentView.swift
//  Bintaro Food
//
//  Created by Sorfian on 16/09/23.
//

import SwiftUI

struct RestaurantListView: View {
    
    @State var restaurants = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", phone: "348-233423", description: "A little gem hidden at the corner of the street is nothing but fantastic! This place is warm and cozy. We open at 7 every morning except Sunday, and close at 9 PM. We offer a variety of coffee drinks and specialties including lattes, cappuccinos, teas, and more. We serve breakfast, lunch, and dinner in an airy open setting. Come over, have a coffee and enjoy a chit-chat with our baristas.", image: "homei", isFavorite: false),
    ]
    
    @State var restaurantIsFavorites = Array(repeating: false, count: 21)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(restaurants.indices, id: \.self) { index in
                    
                    ZStack(alignment: .leading) {
                        NavigationLink(destination:
                            RestaurantDetailView(restaurant: restaurants[index])
                        ) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        BasicTextImageRow(restaurant: $restaurants[index])
                            .swipeActions(edge: .leading, content: {
                                Button {
                                    
                                } label: {
                                    Image(systemName: "heart")
                                }
                                .tint(.green)
                                
                                Button {
                                    
                                } label: {
                                    Image(systemName: "square.and.arrow.up")
                                }
                                .tint(.orange)

                        })
                    }            }
                .onDelete(perform: { index in
                    restaurants.remove(atOffsets: index)
                })
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Bintaro Food")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .tint(.white)
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
        
        RestaurantListView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Restaurant List View (Dark)")
        
        BasicTextImageRow(restaurant: .constant(Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "0823-1034-0134", description: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "cafedeadend", isFavorite: false)))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("BasicTextImageRow")
        
        FullImageRow(imageName: "cafedeadend", name: "Cafe Deadend", type:
        "Cafe", location: "Hong Kong")
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FullImageRow")
    }
}

struct FullImageRow: View {
    var imageName: String
    var name: String
    var type: String
    var location: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(.title2, design: .rounded))
                
                Text(type)
                    .font(.system(.body, design: .rounded))
                
                Text(location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 20)
        }
    }
}

struct BasicTextImageRow: View {
    
    @State private var showOptions = false
    @State private var showError = false
    @Binding var restaurant: Restaurant
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(restaurant.image)
                .resizable()
                .scaledToFill()
                .frame(width: 120 ,height: 118)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .font(.system(.title2, design: .rounded))
                
                Text(restaurant.type)
                    .font(.system(.body, design: .rounded))
                
                Text(restaurant.location)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
            }
            
            if restaurant.isFavorite {
                Spacer()
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
        }
//        .onTapGesture {
//            showOptions.toggle()
//        }
//        .confirmationDialog("What do you want to do?", isPresented: $showOptions, titleVisibility: .visible) {
//            Button("Reserve a table") {
//                self.showError.toggle()
//            }
//            Button(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite") {
//                self.restaurant.isFavorite.toggle()
//            }
//        }
        .contextMenu(menuItems: {
            Button {
                self.showError.toggle()
            } label: {
                HStack {
                    Text("Reserve a table")
                    Image(systemName: "phone")
                }
            }
            
            Button {
                self.restaurant.isFavorite.toggle()
            } label: {
                HStack {
                    Text(restaurant.isFavorite ? "Remove from favorites" : "Mark as favorite")
                    Image(systemName: "heart")
                }
            }
            
            Button {
                self.showOptions.toggle()
            } label: {
                HStack {
                    Text("Share")
                    Image(systemName: "square.and.arrow.up")
                }
            }



        })
        .sheet(isPresented: $showOptions, content: {
            let defaultText = "Just checking in at \(restaurant.name)"
            
            if let imageToShare = UIImage(named: restaurant.image) {
                ActivityView(activityItems: [defaultText, imageToShare])
            } else {
                ActivityView(activityItems: [defaultText])
            }
        })
        .alert("Not yet available",isPresented: $showError) {
            Button("OK") {
                
            }
        } message: {
            Text("Sorry, this feature is not available yet. Please retry later.")
        }
        
        
    }
}
