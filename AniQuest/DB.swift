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
    @Published var norecents = false
    
    init() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users").document(uid!).collection("recents").order(by: "date" , descending: true).addSnapshotListener{(snap , err) in
            
            if(err != nil){
                print((err?.localizedDescription)!)
                self.norecents = true
                return
            }
            
            if snap!.isEmpty{
                self.norecents = true
            }
            
            for i in snap!.documentChanges{
                
                if i.type == .added{
                    
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
                if i.type == .modified{
                    
                    let id = i.document.documentID
                    let lastmsg = i.document.get("lastmsg") as! String
                    let stamp = i.document.get("date") as! Timestamp
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = ("dd/MM/YY")
                    
                    let date = formatter.string(from: stamp.dateValue())
                    
                    formatter.dateFormat = ("hh:mm a")
                    let time = formatter.string(from: stamp.dateValue())
                    
                    for j in 0..<self.recents.count{
                        
                        if self.recents[j].id == id{
                            self.recents[j].lastmsg = lastmsg
                            self.recents[j].time = time
                            self.recents[j].date = date
                            self.recents[j].stamp = stamp.dateValue()
                        }
                    }
                    
                }
                
                

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

class getAllUsers:ObservableObject{
    @Published var users = [User]()
    
    init() {
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments{(snap,err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            
            for i in snap!.documents{
                let id = i.documentID
                let nick = i.get("nickname") as! String
                let pic = i.get("pic") as! String
                
                if id != UserDefaults.standard.value(forKey: "UID") as! String{
                    self.users.append(User(id: id, nickname: nick, image: pic))
                }
                
               
                
                
                
            }
        }
        
        
    }
    
    
    
}

func sendMsg(user: String , uid : String , pic: String , date : Date , msg : String ){
    let db = Firestore.firestore()
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("users").document(uid).collection("recents").document(myuid!).getDocument{(snap , err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
            setRecents(user: user, uid: uid, pic: pic, date: date, msg: msg)
            return
        }
        
        if !snap!.exists{
            
            setRecents(user: user, uid: uid, pic: pic, date: date, msg: msg)
            
        }
        else{
            updateRecents(uid: uid, date: date, msg: msg)
        }
    
      
    }
    updateDB(uid: uid, date: date, msg: msg)
}

func setRecents(user: String , uid : String , pic: String , date : Date , msg : String ){
    let db = Firestore.firestore()
    let myuid = Auth.auth().currentUser?.uid
    let myname = UserDefaults.standard.value(forKey: "nickname") as! String
    let mypic = UserDefaults.standard.value(forKey: "pic") as! String
    
    db.collection("users").document(uid).collection("recents").document(myuid!).setData(["nickname" : myname, "pic" : mypic , "lastmsg" : msg , "date" :date] ){(err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
        
    }
    db.collection("users").document(myuid!).collection("recents").document(uid).setData(["nickname" : user, "pic" : pic , "lastmsg" : msg , "date" :date] ){(err) in
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
        
    }
}

func removeRecents(uid : String ){
    let db = Firestore.firestore()
    let myuid = Auth.auth().currentUser?.uid

    
    db.collection("users").document(uid).collection("recents").document(myuid!).delete()
    {(err) in

        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
        
    }
    db.collection("users").document(myuid!).collection("recents").document(uid).delete()
    {(err) in

        if err != nil{
            print((err?.localizedDescription)!)
            return
        }
        
        
    }
}

func updateRecents( uid : String , date : Date , msg : String ){
    let db = Firestore.firestore()
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("users").document(uid).collection("recents").document(myuid!).updateData(["lastmsg" : msg , "date" : date])
    
    
    db.collection("users").document(myuid!).collection("recents").document(uid).updateData(["lastmsg" : msg , "date" : date])
    
    
    
}

func updateDB(uid : String , date : Date , msg : String ){
    let db = Firestore.firestore()
    let myuid = Auth.auth().currentUser?.uid
    
    db.collection("msgs").document(uid).collection(myuid!).document().setData(["msg" : msg , "user" : myuid! , "date" : date]){(err) in
        
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }

        
    }
    db.collection("msgs").document(myuid!).collection(uid).document().setData(["msg" : msg , "user" : myuid! , "date" : date]){(err) in
        
        
        if err != nil{
            print((err?.localizedDescription)!)
            return
        }

        
    }
}
