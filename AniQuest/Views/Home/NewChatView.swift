//
//  NewChatView.swift
//  AniQuest
//
//  Created by admin on 1/11/21.
//

import SwiftUI
import Foundation

struct NewChatView: View {
    @ObservedObject var datas = getAllUsers()
    @Binding var name : String
    @Binding var pic : String
    @Binding var uid : String
    @Binding var chat : Bool
    @Binding var show : Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Select User to Start chatting").font(.title).foregroundColor(Color.black.opacity(0.5)).padding()
            VStack{
                
                if self.datas.users.count == 0 {
                    Indicator()
                }
                else{
                    ScrollView(.vertical , showsIndicators: false){
                        VStack(spacing:12){
                        ForEach(datas.users){ i in
                        
                            Button(action:{
                                self.name = i.nickname
                                self.pic = i.image
                                self.uid = i.id
                                self.show.toggle()
                                self.chat.toggle()
                                
                            }){
                            
                                UserCellView(url:i.image , name: i.nickname)
                                
                            }
                            
                          
                            
                            
                        }
                        }

                    }
                }
            }.padding(.horizontal)
            
        }
}
}


