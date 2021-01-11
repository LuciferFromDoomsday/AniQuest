//
//  RecentCellView.swift
//  AniQuest
//
//  Created by admin on 1/10/21.
//

import SwiftUI
import SDWebImageSwiftUI
struct RecentCellView: View {
    var url :String
    var name :String
    var lastmsg:String
    var date : String
    var time : String

    var body: some View {
        HStack{
            AnimatedImage(url:URL(string: url)!).resizable().frame(width: 55, height: 55).clipShape(Circle())
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6){
                        Text(name)
                        Text(lastmsg).foregroundColor(.gray)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 6){
                        Text(date).foregroundColor(.gray)
                        Text(time).foregroundColor(.gray)

                    }
                   
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
