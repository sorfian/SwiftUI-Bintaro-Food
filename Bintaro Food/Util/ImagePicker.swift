//
//  ImagePicker.swift
//  Bintaro Food
//
//  Created by Sorfian on 07/10/23.
//

import UIKit
import SwiftUI
import Photos
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: PhotoSource = .photoLibrary
    @Binding var selectedImage: UIImage
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIViewController {
        
        switch sourceType {
        case .photoLibrary:
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 3
            config.filter = PHPickerFilter.any(of: [.images, .livePhotos, .panoramas, .screenshots])
            let phPicker = PHPickerViewController(configuration: config)
            phPicker.delegate = context.coordinator
            return phPicker
        case .camera:
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.delegate = context.coordinator
            return imagePicker
        }
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.dismiss()
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            results.forEach { result in
                
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                        DispatchQueue.main.async {
                            guard let image = reading as? UIImage, error == nil
                            else {
                                return
                            }
                            self.parent.selectedImage = image
                        }
                    }
                }
            }
            parent.dismiss()
        }
    }
}

