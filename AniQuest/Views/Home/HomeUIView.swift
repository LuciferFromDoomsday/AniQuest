//
//  HomeUIView.swift
//  AniQuest
//
//  Created by admin on 1/8/21.
//

import SwiftUI
import Firebase
struct HomeUIView: View {
    var body: some View {
        Text("Hello, \(UserDefaults.standard.value(forKey: "UserName") as! String)")
        
        Button(action:{
            try! Auth.auth().signOut()
            
            UserDefaults.standard.set(false , forKey: "status")
            NotificationCenter.default.post(name:
            NSNotification.Name("statusChange") ,object: nil)
            
        }){
            Text("LogOut")
        }
    }
}

struct HomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUIView()
    }
}
