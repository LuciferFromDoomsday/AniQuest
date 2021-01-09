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


func checkUser(completion : @escaping(Bool , String)->Void){
    
    let db = Firestore.firestore()
    
    db.collection("users").getDocuments{ (snap , err) in
        if err != nil{
            
            print((err?.localizedDescription)!)
            return
            
    }
        
        for i in snap!.documents{
            
            if i.documentID == Auth.auth().currentUser?.uid{
                
                completion(true , i.get("nickname") as! String )
                
                return
            }
            
        }
        completion(false , "")
    
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
                UserDefaults.standard.set(nickname , forKey: "NickName")
                NotificationCenter.default.post(name:
                NSNotification.Name("statusChange") ,object: nil)
            }
            
        }
        
    }
}
