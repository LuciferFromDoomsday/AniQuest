//
//  ImagePicker.swift
//  AniQuest
//
//  Created by admin on 1/9/21.
//

import Foundation
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable{
    
    @Binding var picker : Bool
    @Binding var imageData : Data
    
    func makeCoordinator() -> Coordinator {
        
        return ImagePicker.Coordinator(parent: self)
        
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        
        return picker
        
        
    }
    
    func updateUIViewController(_ uiView: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
        
    }
    
    class Coordinator : NSObject , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
        var parent : ImagePicker
        
        init(parent : ImagePicker){
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            self.parent.picker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            
            let data = image.jpegData(compressionQuality: 0.45)
            
            self.parent.imageData = data!
            
            self.parent.picker.toggle()
            
        }
    }
    
}
