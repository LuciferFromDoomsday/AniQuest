//
//  ChatView.swift
//  AniQuest
//
//  Created by admin on 1/11/21.
//

import SwiftUI
import Firebase

struct ChatView: View {
    var name : String
    var pic : String
    var uid : String
    @State var msgs = [Message]()
    @Binding var chat : Bool
    @State var txt = ""
    @State var nomsgs = false
    
    var body: some View {
        VStack{
            
            if msgs.count == 0{
                
                if nomsgs {
                    Text("Start new Chat!").foregroundColor(Color.black.opacity(0.5)).padding(.top).font(.title2)
                    Spacer()
                    
                }
                else{
                    Spacer()
                    Indicator()
                    Spacer()
                }
             
            
            }
            
            else{
                
                ScrollView( .vertical , showsIndicators : false){
                    VStack(spacing:8){
                        ForEach(self.msgs){ i in
                            
                            HStack{
                                if i.user == UserDefaults.standard.value(forKey: "UID") as! String{
                                    
                                    Spacer()
                                    
                                    Text(i.msg).padding().foregroundColor(.white).background(Color.blue).clipShape(ChatBubble(mymsg: true))
                                    
                                }
                                else{
                                    
                                    Text(i.msg).padding().foregroundColor(.white).background(Color.green).clipShape(ChatBubble(mymsg: false))
                                    Spacer()
                                }
                            }
                            
                            
                        }
                    }
                }
            }
            
            HStack{
                TextField("Enter Message" ,text : self.$txt).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action:{
                    
                    sendMsg(user: self.name, uid: self.uid, pic: self.pic, date: Date(), msg: self.txt)
                    
                    self.txt = ""
                    
                }){
                    Text("Send")
                }
            }
            
        }.navigationBarTitle("\(name)" , displayMode: .inline)
        .padding()
        .onAppear{
            self.getMessages()
        }
        
    }
    func getMessages(){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("msgs").document(uid!).collection(self.uid).order(by : "date" , descending: false).addSnapshotListener{(snap , err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                self.nomsgs = true
                return
            }
            if snap!.isEmpty{
                self.nomsgs = true
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    let id =  i.document.documentID
                    let msg = i.document.get("msg") as! String
                    let user = i.document.get("user") as! String
                    
                    self.msgs.append(Message(id: id, msg: msg, user: user))
                }
                
             
            }
        }
            
        
    }
}

struct ChatBubble : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
            
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        return Path(path.cgPath)
    }
}


