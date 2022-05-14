//
//  DebugPage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/25.
//

import SwiftUI
import CoreData

struct DebugPage<T: NSManagedObject, Content: View>: View {
    
    @FetchRequest var fetchRequest: FetchedResults<T>

    var row: (T) -> Content
    
    init(@ViewBuilder row: @escaping (T) -> Content) {
        
        _fetchRequest = FetchRequest<T>(sortDescriptors: [])

        self.row = row
    }
    
    var body: some View {
        List(fetchRequest, id: \.self) { item in
            self.row(item)
        }
    }
}

//struct DebugPage_Previews: PreviewProvider {
//    static var previews: some View {
//        DebugPage()
//    }
//}
