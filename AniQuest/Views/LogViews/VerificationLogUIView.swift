//
//  VerificationLogUIView.swift
//  AniQuest
//
//  Created by admin on 1/8/21.
//

import SwiftUI
import Firebase

struct VerificationLogUIView: View {

    @State var code = ""
    @Binding var show : Bool
    @Binding var ID : String
    @State var msg = ""
    @State var alert : Bool = false
    @State var creation = false
    @State var loading = false
    var body: some View {
        
        ZStack{
            
            GeometryReader{ _ in
                
                VStack(spacing:20){
                    
                    Image("pic")
                    .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.35 )
                    Text("Verifaction Code").font(.largeTitle).fontWeight(.heavy)
                    Text("Enter the verification code")
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                        .padding(.top , 10)
                        .multilineTextAlignment(.center)
                        

                        TextField("Code" , text : $code)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color("Color"))
                            .clipShape(RoundedRectangle(cornerRadius:10))
                            .padding(.top, 15)
            
                    if self.loading {
                        HStack{
                            Spacer()
                            
                            Indicator()
                            
                            Spacer()
                        }
                    }
                    
                    
                    
                    Button(action:{
                        self.loading.toggle()
                        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                        Auth.auth().signIn(with:credential){(res , err) in
                            
                           
                                
                                if err != nil{
                                    self.msg = (err?.localizedDescription)!
                                    self.alert.toggle()
                                    self.loading.toggle()
                                    return
                                }
                            
                        
                            
                            checkUser {(exists, user , uid , pic) in
                                
                                if exists{
                                    UserDefaults.standard.set(true , forKey: "status")
                                    
                                    
                                    UserDefaults.standard.set(user , forKey: "nickname")
                                    UserDefaults.standard.set(uid , forKey: "UID")
                                    UserDefaults.standard.set(pic , forKey: "pic")
                                    NotificationCenter.default.post(name:
                                    NSNotification.Name("statusChange") ,object: nil)
                                }
                                else{
                                    
                                    self.loading.toggle()
                                    
                                    self.creation.toggle()
                                    
                                }
                            
                            }
                                
                                
                                
                                
                            
                            
                        }
                    }){
                        Text("Verify").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                        
                    }.foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                 
                }
                Button(action:{
                    self.show.toggle()
                } ){
                    Image(systemName: "chevron.left").font(.title)
                    
                }.foregroundColor(.blue)
            }.padding()
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $alert){
                Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented:self.$creation ){
                
                AuthUIView(show:self.$creation)
                
            }
            
          
        }
      
        
    }
}

//struct VerificationLogUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        VerificationLogUIView()
//    }
//}
