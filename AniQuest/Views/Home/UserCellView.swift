//
//  RecentCellView.swift
//  AniQuest
//
//  Created by admin on 1/10/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct UserCellView: View {
    var url :String
    var name :String


    var body: some View {
        HStack{
            AnimatedImage(url:URL(string: url)!).resizable().frame(width: 55, height: 55).clipShape(Circle())
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6){
                        Text(name)
                      
                    }
                    Spacer()
                    
                   
                   
                }
               Divider()
            }
        }
    }
}

//struct RecentCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentCellView()
//    }
//}
