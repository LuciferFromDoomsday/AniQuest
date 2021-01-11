//
//  HomeUIView.swift
//  AniQuest
//
//  Created by admin on 1/8/21.
//

import SwiftUI
import Firebase
struct HomeUIView: View {
    @State var myuid = UserDefaults.standard.value(forKey: "nickname") as! String
    
    @EnvironmentObject var datas : MainObservable
    
    
    var body: some View {
        VStack{
            
            if self.datas.recents.count == 0 {
                Indicator()
            }
            else{
                ScrollView(.vertical , showsIndicators: false){
                    VStack(spacing:12){
                    ForEach(datas.recents){ i in
                    
                        RecentCellView(url: i.pic, name: i.name, lastmsg: i.lastmsg, date: i.date, time: i.time)
                        
                        
                    }
                    }.padding()

                }

            }
        }.navigationBarTitle("Chat" , displayMode: .inline)
        .navigationBarItems(leading:
                                Button(action:{} , label: {
                                    Text("Sign Out")
                                })
                            
                            ,
        trailing:
            Button(action:{} , label: {
                Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
            })
                            )
        
//        Button(action:{
//            try! Auth.auth().signOut()
//
//            UserDefaults.standard.set(false , forKey: "status")
//            NotificationCenter.default.post(name:
//            NSNotification.Name("statusChange") ,object: nil)
//
//        }){
//            Text("LogOut")
//        }
    }
}

struct HomeUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUIView()
    }
}
