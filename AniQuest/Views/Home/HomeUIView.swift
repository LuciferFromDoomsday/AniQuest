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
    @State var show = false
    @State var chat = false
    @State var uid = ""
    @State var name = ""
    @State var pic = ""
    
    var body: some View {
        ZStack{
            NavigationLink(
                destination: ChatView(name: self.name, pic: self.pic, uid: self.myuid, chat: self.$chat),isActive: self.$chat){}
            VStack{
                
                if self.datas.recents.count == 0 {
                    if self.datas.norecents{
                        
                        Text("No Chats here yet , Start new one !)")
                        
                    }
                    else{
                        Spacer()
                        Indicator()
                        Spacer()
                    }
                  
                }
                else{
                    ScrollView(.vertical , showsIndicators: false){
                        VStack(spacing:12){
                            ForEach(datas.recents.sorted(by: {$0.stamp > $1.stamp})){ i in
                        
                            Button(action:{
                                
                                
                                self.name = i.name
                                self.pic = i.pic
                                self.uid = i.id
                                self.chat.toggle()
                                
                                
                            }){
                                RecentCellView(url: i.pic, name: i.name, lastmsg: i.lastmsg, date: i.date, time: i.time)
                            }
                            
                          
                            
                            
                            }.onDelete(perform: { indexSet in
                           
                        removeRecents(uid:self.uid)
  
                            })
                        }.padding()

                    }

                }
            }.navigationBarTitle("Chat" , displayMode: .inline)
            .navigationBarItems(leading:
                                    Button(action:{
                                        
                                        UserDefaults.standard.set("" , forKey: "UserName")
                                        UserDefaults.standard.set("" , forKey: "pic")
                                        UserDefaults.standard.set("" , forKey: "UID")
                                        
                                                    try! Auth.auth().signOut()
                                        
                                                    UserDefaults.standard.set(false , forKey: "status")
                                                    NotificationCenter.default.post(name:
                                                    NSNotification.Name("statusChange") ,object: nil)
                                    } , label: {
                                        Text("Sign Out")
                                    })
                                
                                ,
            trailing:
                Button(action:{
                    self.show.toggle()
                } , label: {
                    Image(systemName: "square.and.pencil").resizable().frame(width: 25, height: 25)
                })
            )
        }
    .sheet(isPresented:self.$show){
            
        NewChatView(name: self.$name, pic: self.$pic, uid: self.$myuid, chat: self.$chat, show: self.$show)
            
        }
        
        
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
