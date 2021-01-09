//
//  MainLogUIView.swift
//  AniQuest
//
//  Created by admin on 1/8/21.
//

import SwiftUI
import Firebase

class TextLimiter: ObservableObject {
    private let limit: Int
    
    init(limit: Int) {
        self.limit = limit
    }
    
    @Published var value = "+7" {
        didSet {
            if value.count > self.limit {
                value = String(value.prefix(self.limit))
                self.hasReachedLimit = true
            } else {
                self.hasReachedLimit = false
            }
        }
    }
    @Published var hasReachedLimit = false
}



struct MainLogUIView: View {
    @ObservedObject var input = TextLimiter(limit: 2)
    @State var num = ""
    @State var show : Bool = false
    @State var msg = ""
    @State var alert : Bool = false
    @State var ID = ""
    var body: some View {
        VStack(spacing:20){
            
            Image("pic")
            .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.35 )
            Text("Verify Number").font(.largeTitle).fontWeight(.heavy)
            Text("Enter Your Number to verify your account")
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.top , 10)
                
            HStack{
                
                TextField("+7" , text : $input.value)
                    .keyboardType(.numberPad)
                    .frame(width:45)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius:10))
                  
                TextField("Number" , text : $num)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius:10))
                  
                
                
            }
            
            NavigationLink(destination: VerificationLogUIView(show: $show , ID : self.$ID), isActive : $show){
                
                Button(action:{
                    
                    PhoneAuthProvider.provider().verifyPhoneNumber( self.input.value + self.num  , uiDelegate:nil){ID,err in
                        
                        if err != nil{
                            self.msg = (err?.localizedDescription)!
                            print((err?.localizedDescription)!)
                            self.alert.toggle()
                            return
                        }
                        self.ID = ID!
                        self.show.toggle()
                    }
                    
                }){
                    Text("Send").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    
                }.foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }.padding()
        .alert(isPresented: $alert){
            
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("OK")))
            
        }
    }
}

struct MainLogUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainLogUIView()
    }
}
