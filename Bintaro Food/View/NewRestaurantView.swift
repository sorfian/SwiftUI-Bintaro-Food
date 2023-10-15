//
//  NewRestaurantView.swift
//  Bintaro Food
//
//  Created by Sorfian on 07/10/23.
//

import SwiftUI

enum PhotoSource: Identifiable {
    case photoLibrary
    case camera
    
    var id: Int {
        hashValue
    }
    
}

struct NewRestaurantView: View {
    
    @State var restaurantName = ""
    @State private var showPhotoOptions = false
    
    @State private var photoSource: PhotoSource?
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject private var restaurantFormViewModel: RestaurantFormViewModel
    
    init() {
        let viewModel = RestaurantFormViewModel()
        viewModel.image = UIImage(named: "newphoto")!
        restaurantFormViewModel = viewModel
    }
    
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    Image(uiImage: restaurantFormViewModel.image)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 200)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                        .padding(.bottom)
                        .onTapGesture {
                            self.showPhotoOptions.toggle()
                        }
                    
                    FormTextField(label: "Name", placeholder: "Fill in the restaurant name", value: $restaurantFormViewModel.name)
                    
                    FormTextField(label: "Type", placeholder: "Fill in the restaurant type", value: $restaurantFormViewModel.type)
                    
                    FormTextField(label: "Address", placeholder: "Fill in the restaurant address", value: $restaurantFormViewModel.location)
                    
                    FormTextField(label: "Phone", placeholder: "Fill in the restaurant phone", value: $restaurantFormViewModel.phone)
                    
                    FormTextView(label: "Description", value: $restaurantFormViewModel.description, height: 100.0)
                }
                .padding()
            }
            .navigationTitle("New Restaurant")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }

                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        save()
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(Color("NavigationBarTitle"))
                    }

                }
            }
        }
        .confirmationDialog("Choose your photo source", isPresented: $showPhotoOptions, titleVisibility: .visible) {
            Button {
                self.photoSource = .camera
            } label: {
                Text("Camera")
            }
            
            Button {
                self.photoSource = .photoLibrary
            } label: {
                Text("Photo Library")
            }
        }
        
        .fullScreenCover(item: $photoSource) { source in
            switch source {
            case .photoLibrary:
                ImagePicker(sourceType: .photoLibrary, selectedImage: $restaurantFormViewModel.image)
                    .ignoresSafeArea()
                
            case .camera:
                ImagePicker(sourceType: .camera, selectedImage: $restaurantFormViewModel.image)
                    .ignoresSafeArea()
            }
        }
        .tint(.primary)
    }
    
    private func save() {
        let restaurant = Restaurant(context: context)
        
        restaurant.name = restaurantFormViewModel.name
        restaurant.type = restaurantFormViewModel.type
        restaurant.location = restaurantFormViewModel.location
        restaurant.phone = restaurantFormViewModel.phone
        restaurant.image = restaurantFormViewModel.image.pngData()!
        restaurant.summary = restaurantFormViewModel.description
        restaurant.isFavorite = false
        
        do {
            try context.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
}

struct NewRestaurantView_Previews: PreviewProvider {
    static var previews: some View {
        NewRestaurantView()
        
        FormTextField(label: "NAME", placeholder: "Fill in the restaurant name", value: .constant(""))
            .previewLayout(.fixed(width: 300, height: 200))
            .previewDisplayName("FormTextField")
        
        FormTextView(label: "Description", value: .constant(""))
            .previewLayout(.sizeThatFits)
            .previewDisplayName("FormTextView")
    }
}
