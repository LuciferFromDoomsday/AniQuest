//
//  Indicator.swift
//  AniQuest
//
//  Created by admin on 1/9/21.
//

import Foundation
import SwiftUI


struct Indicator : UIViewRepresentable {
    
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Indicator>) {
        
        
    }
    
    
    
}
