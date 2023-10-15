//
//  ContentView.swift
//  Bintaro Food
//
//  Created by Sorfian on 16/09/23.
//

import SwiftUI

struct RestaurantListView: View {
    
    @FetchRequest(entity: Restaurant.entity(), sortDescriptors: []) var restaurants: FetchedResults<Restaurant>
    
    @Environment(\.managedObjectContext) var context
    
    @State var restaurantIsFavorites = Array(repeating: false, count: 21)
    
    @State private var showNewRestaurant = false
    
    var body: some View {
        NavigationStack {
            List {
                if restaurants.count == 0 {
                    Image("emptydata")
                        .resizable()
                        .scaledToFit()
                } else {
                    ForEach(restaurants.indices, id: \.self) { index in
                        
                        ZStack(alignment: .leading) {
                            NavigationLink(destination:
                                RestaurantDetailView(restaurant: restaurants[index])
                            ) {
                                EmptyView()
                            }
                            .opacity(0)
                            
                            BasicTextImageRow(restaurant: restaurants[index])
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
                        }
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Bintaro Food")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                Button {
                    self.showNewRestaurant = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .tint(.primary)
        }
        .tint(.white)
        .sheet(isPresented: $showNewRestaurant) {
            NewRestaurantView()
        }
    }
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = restaurants[index]
            context.delete(itemToDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        RestaurantListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .preferredColorScheme(.dark)
            .previewDisplayName("Restaurant List View (Dark)")
        
        BasicTextImageRow(restaurant: (PersistenceController.testData?.first)!)
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
    @ObservedObject var restaurant: Restaurant
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(uiImage: UIImage(data: restaurant.image) ?? UIImage())
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
            
            if let imageToShare = UIImage(data: restaurant.image) {
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


