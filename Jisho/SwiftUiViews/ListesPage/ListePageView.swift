//
//  ListePage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/26.
//

import SwiftUI
import CoreData


struct ListePageView: View {
    
    @State var showAlert = false
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "parent == nil")) var listes: FetchedResults<Liste>
    
    @Environment(\.toggleSideMenu) var showSideMenu
        
    var body: some View {
        
        List {
            ForEach(listes.sorted(by: { $0.ordre < $1.ordre })) { liste in
                
                NavigationLink(liste.name ?? "No name") {
                    ListeView(liste: liste)
                }
                .isDetailLink(false)
                 
            }
            .onDelete(perform: deleteListe)
        }
        
        .alert(isPresented: $showAlert, TextAlert() { result in
            
            if let text = result {
                createListe(name: text)
            }
            
        })
        .listStyle(.inset)
        .navigationTitle("Listes")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                sideMenuButton
            }
            
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                addButton
            }
        }

    }
    
    
    private func deleteListe(at offsets: IndexSet) {
        offsets.forEach {
            
            var listes:[Liste] = listes.sorted(by: { $0.ordre < $1.ordre }).map { $0 }
            DataController.shared.mainQueueManagedObjectContext.delete(listes.remove(at: $0))
            for (i, liste) in listes.enumerated() {
                liste.ordre = Int64(i)
                
            }
        }
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }

    }
    
    private func createListe(name: String) {
                
        _ = Liste(ordre: (listes.sorted(by: { $0.ordre < $1.ordre }).last?.ordre ?? -1) + 1,
                  name: name,
                  context: DataController.shared.mainQueueManagedObjectContext)
                        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
         
    }
    
    
    private var sideMenuButton: some View {
        Button {
            showSideMenu()
        } label: {
            Image(systemName: "list.bullet")
        }
    }
    
    private var addButton: some View {
        
        Button(action: {
            showAlert.toggle()
            
        }, label: {
            Image(systemName: "plus")
        })
    }
    
}
