//
//  NewRestaurantView.swift
//  Bintaro Food
//
//  Created by Sorfian on 07/10/23.
//

import SwiftUI

struct NewRestaurantView: View {
    
    @State var restaurantName = ""
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack {
                    FormTextField(label: "Name", placeholder: "Fill in the restaurant name", value: .constant(""))
                    
                    FormTextField(label: "Type", placeholder: "Fill in the restaurant type", value: .constant(""))
                    
                    FormTextField(label: "Address", placeholder: "Fill in the restaurant address", value: .constant(""))
                    
                    FormTextField(label: "Phone", placeholder: "Fill in the restaurant phone", value: .constant(""))
                    
                    FormTextView(label: "Description", value: .constant(""), height: 100.0)
                }
                .padding()
            }
            .navigationTitle("New Restaurant")
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
