//
//  MotListView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/25.
//

import SwiftUI
import CoreData


struct MotListView: View {

    
    var mots:(exactMatch: [Mot], nonExactMatch: [Mot])
    var onDelete: (IndexSet) -> Void
    
    init(motsObjectIDs: (exactMatch: [NSManagedObjectID], nonExactMatch: [NSManagedObjectID]), onDelete: @escaping (IndexSet) -> Void = { _ in }) {
        
        self.mots = (exactMatch: motsObjectIDs.exactMatch.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot },
                     nonExactMatch: motsObjectIDs.nonExactMatch.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot })
        self.onDelete = onDelete
    }

    
    
    
    var body: some View {
        
        if !mots.exactMatch.isEmpty {
            Section(mots.exactMatch.count > 1 ? "Exact Matchs" : "Exact Match") {
                exactMatchs
            }
        }
        
        if !mots.nonExactMatch.isEmpty {
            if !mots.exactMatch.isEmpty {
                Section("Autres") {
                    autresMatchs
                }
            }
            else {
                autresMatchs
            }
        }
    }
    
    
    
    var exactMatchs: some View {
        ForEach(mots.exactMatch) { mot in
            NavigationLink(destination: MotDetailsView(mot)) {
                MotRowView(mot: mot)
            }
        }
        .onDelete(perform: onDelete)
    }
    
    var autresMatchs: some View {
        ForEach(mots.nonExactMatch) { mot in
            NavigationLink(destination: MotDetailsView(mot)) {
                MotRowView(mot: mot)
            }
        }
        .onDelete(perform: onDelete)
    }
}



//struct MotListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MotListView()
//    }
//}
