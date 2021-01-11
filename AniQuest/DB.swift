//
//  DB.swift
//  AniQuest
//
//  Created by admin on 1/9/21.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore


func checkUser(completion : @escaping(Bool , String , String , String)->Void){
    
    let db = Firestore.firestore()
    
    db.collection("users").getDocuments{ (snap , err) in
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
            
    }
        
        for i in snap!.documents{
            
            if i.documentID == Auth.auth().currentUser?.uid{
                
                completion(true , i.get("nickname") as! String , i.documentID  , i.get("pic") as! String )
                
                return
            }
            
        }
        completion(false , "" , "" , ""  )
    
    }
    
    
}

func createUser(nickname : String , image : Data , completion : @escaping(Bool)->Void){
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage().reference()
    
    let uid = Auth.auth().currentUser?.uid
    
    storage.child("profilepics").child(uid!).putData(image , metadata: nil){ (_ , err) in
        
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
        }
        
        storage.child("profilepics").child(uid!).downloadURL{(url , err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            db.collection("users").document(uid!).setData(["nickname" : nickname , "pic" : "\(url!)" , "uid" : uid!] ){ (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                completion(true)
                UserDefaults.standard.set(true , forKey: "status")
                UserDefaults.standard.set(nickname , forKey: "nickname")
                UserDefaults.standard.set(uid , forKey: "UID")
                UserDefaults.standard.set("\(url!)" , forKey: "pic")
                
                NotificationCenter.default.post(name:
                NSNotification.Name("statusChange") ,object: nil)
            }
            
        }
        
    }
}

class MainObservable : ObservableObject{
    
    @Published var recents = [Recent]()
    
    init() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid!).collection("recents").order(by: "date" , descending: true).addSnapshotListener{(snap , err) in
            
            if(err != nil){
                print((err?.localizedDescription)!)
                
            }
            
            for i in snap!.documentChanges{
                let id = i.document.documentID
                let nickname = i.document.get("nickname") as! String
                let pic = i.document.get("pic") as! String
                let lastmsg = i.document.get("lastmsg") as! String
                let stamp = i.document.get("date") as! Timestamp
                
                let formatter = DateFormatter()
                formatter.dateFormat = ("dd/MM/YY")
                
                let date = formatter.string(from: stamp.dateValue())
                
                formatter.dateFormat = ("hh:mm a")
                let time = formatter.string(from: stamp.dateValue())
                
                self.recents.append(Recent(id: id, name: nickname, pic: pic, lastmsg: lastmsg, time: time, date: date ,stamp: stamp.dateValue()))
                

            }
            
        }
        
    }
    
    
}

struct Recent : Identifiable{
    
    var id : String
    var name : String
    var pic : String
    var lastmsg : String
    var time : String
    var date : String
    var stamp :Date
    
}
