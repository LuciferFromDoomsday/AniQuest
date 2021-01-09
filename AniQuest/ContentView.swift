//
//  ContentView.swift
//  AniQuest
//
//  Created by admin on 1/8/21.
//

import SwiftUI

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        

        
        VStack{

            if status {
                HomeUIView()
            }
            else{
                NavigationView{
                    MainLogUIView()
                }

            }
        }.onAppear{
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){(_) in

                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false

                self.status = status


            }
        }
        }
        
      
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
