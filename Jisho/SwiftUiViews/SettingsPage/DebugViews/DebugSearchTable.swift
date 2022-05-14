//
//  DebugSearchTable.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/04/23.
//

import SwiftUI
import CoreData

struct DebugSearchTable: View {
    
//    @FetchRequest(sortDescriptors: []) var holders: FetchedResults<SearchTableHolderMotJMdict>
    
    @State var holders:[(id: Int,count: Int)] = []
    
    var body: some View {
        
        List {
            
            ForEach(holders, id: \.id) { holder in
                Text("\(holder.id)  \(holder.count)")
            }
            
            Button("Load one more") {
                
                let request:NSFetchRequest<SearchTableHolderMotJMdict> = SearchTableHolderMotJMdict.fetchRequest()
                request.predicate = NSPredicate(format: "idAtb == %i", (holders.last?.id ?? -1) + 1)
                request.fetchLimit = 1
                let result = try! DataController.shared.mainQueueManagedObjectContext.fetch(request)
                
                if let first = result.first {
                    holders.append((id: Int(first.idAtb), count: first.searchTableAtb!.count))
                }
            }
        }
        
        /*
        List {
            
            ForEach(holders) { holder in
                Text("\(holder.idAtb) - \(holder.searchTableAtb!.count)")
            }
            
        }
         */
        
    }
}




struct DebugSearchTable_Previews: PreviewProvider {
    static var previews: some View {
        DebugSearchTable()
    }
}
