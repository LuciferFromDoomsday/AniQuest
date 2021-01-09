//
//  User.swift
//  AniQuest
//
//  Created by admin on 1/9/21.
//

import Foundation


struct User : Identifiable{
    var id : Int
    var nickname : String
    var image : Data
    
    init(id : Int, nickname : String , image : Data){
        self.nickname = nickname
        self.image = image
        self.id = id
    }
}
