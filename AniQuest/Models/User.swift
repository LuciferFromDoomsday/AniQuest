//
//  User.swift
//  AniQuest
//
//  Created by admin on 1/9/21.
//

import Foundation
import Firebase
import Contacts

struct User : Identifiable{
    var id : String
    var nickname : String
    var image : String
    
    init(id : String, nickname : String , image : String){
        self.nickname = nickname
        self.image = image
        self.id = id
    }
}

//func fetchUser(){
//    let db = Firestore.firestore()
//    db.collection("users").getDocuments{ (snapshot , err) in
//
//           if let dictonary = snapshot.value as? [String: AnyObject]{
//
//               let user = Users()
//               user.id = snapshot.key
//            user.setValuesForKeys(dictonary)
//               ///////
//               let store = CNContactStore()
//
//               store.requestAccess(for: .contacts) { (granted, err) in
//                   if let err = err {
//                       print("Failed to request access:", err)
//                       return
//                   }
//                   if granted {
//                       print("Access granted")
//
//                       let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
//                       let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
//
//                       do {
//
//                           try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointerIfYouWantToStopEnumerating) in
//
//
//                               let ph = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
//                               self.contacts.append(Contact(givenName: contact.givenName, familyName: contact.familyName, phoneNumbers: ph))
//
//
//                               if user.phoneNumber == ph {
//                                   print("Similar Contact Found")
//                                   self.users.append(user)
//                                   DispatchQueue.main.async {
//                                       self.tableView.reloadData()
//                                   }
//                               } else {
//
//                                   print("Contacts Not Compared")
//
//                               }
//
//                           })
//
//                       } catch let err {
//                           print("Failed to enumerate contacts:", err)
//                       }
//
//                   } else {
//                       print("Access denied..")
//                   }
//               }
//
//
//
//           }
//
//
//       }, withCancel: nil)
//   }
