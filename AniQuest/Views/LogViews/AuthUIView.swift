//
//  AuthUIView.swift
//  AniQuest
//
//  Created by admin on 1/9/21.
//

import SwiftUI

struct AuthUIView: View {
    @Binding var show :Bool
    @State var nick = ""
    @State var picker = false
    @State var loading = false
    @State var image :Data = .init(count:0)
    @State var alert = false
    
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15){
            
            Text("Well , Let's Create an Account! ").font(.title).fontWeight(.heavy)
            
            HStack{
                
                Spacer()
                
                Button(action:{
                    
                    self.picker.toggle()
                    
                }){
                    
                    if self.image.count == 0{
                        
                        Image(systemName: "person.crop.circle.badge.plus").resizable().frame(width:90 , height: 70)
                            .foregroundColor(.gray)
                        
                    }
                    else{
                        
                        Image(uiImage: UIImage(data: self.image)!).resizable()
                            .renderingMode(.original)
                            .frame(width: 90, height:90 ).clipShape(Circle())
                        
                    }
                    
                  
                    
                    
                }
                
                Spacer()
                
            
            }
            
            Text("Choose your profile image")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top , 12)
        
            
     
            
                TextField("NickName" , text : $nick)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color("Color"))
                    .clipShape(RoundedRectangle(cornerRadius:10))
            
            
            if self.loading{
                
                HStack{
                    
                    Spacer()
                    
                    Indicator()
                    
                    
                    Spacer()
                }
            }
            else{
                
                Button(action:{
                    
                    if self.nick != "" && self.nick.count > 5 && self.image.count != 0{
                       
                        self.loading.toggle()
                        createUser(nickname: self.nick, image: self.image ){
                            (status) in
                            
                            if status{
                                self.show.toggle()
                            }
                          
                        }
                    }
                    else{
                        print("error")
                        self.alert.toggle()
                    }
                  
                   
                }){
                   
                    Text("Submit").frame(width: UIScreen.main.bounds.width - 30,height: 50)
                    
                }.foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
            }
            
            
            
         
            
    }.padding()
        
        .sheet(isPresented : self.$picker){
            
            ImagePicker(picker: self.$picker, imageData: self.$image)
            
            
        }
        .alert(isPresented: self.$alert){
            Alert(title: Text("Error"), message: Text("NOt all fields filled (Nickname should contain at least 5 sybmols)  "), dismissButton: .default(Text("Ok")))
        }
            
        }

    }


//struct AuthUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthUIView()
//    }
//}
