//
//  LangueRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/31.
//

import SwiftUI

struct LangueRowView<Content: View> : View {
    
    var langue:Langue
    var content : (_ flag: String, _ fullName: String) -> Content
    
    var body: some View
    {
        content(langue.flag, langue.fullName)
        
        
//        if langue != .none
//        {
//            HStack
//            {
//                Text(langue.flag)
//                Text(langue.fullName)
//            }
//        }
    }
}



//struct LangueRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        LangueRowView()
//    }
//}
