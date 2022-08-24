//
//  ListePage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/26.
//

import SwiftUI
import CoreData

fileprivate class ListePageViewModel: ObservableObject {    
    @Published var showTextField = false
    @Published var textFieldText = ""
}


struct ListePageView: View {
    @Environment(\.toggleSideMenu) var showSideMenu
    @Environment(\.editMode) private var editMode

    @StateObject private var vm = ListePageViewModel()
    
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "parent == nil")) private var UnOrderedListes: FetchedResults<Liste>
    
    var listes: [Liste] {
        get {
            return UnOrderedListes.sorted { $0.ordre < $1.ordre }
        }
        nonmutating set {
            for (i, value) in newValue.enumerated() {
                value.ordre = Int64(i)
            }
            
            for liste in listes {
                if !(newValue).contains(liste) {
                    DataController.shared.mainQueueManagedObjectContext.delete(liste)
                }
            }
            
            Task {
                try await DataController.shared.save()
            }
        }
    }
    
        
    var body: some View {
        
        List {
            ForEach(listes) { liste in
                
                NavigationLink("\(liste.name ?? "No name")") {
                    ListeView(liste: liste)
                }
                .isDetailLink(false)
                 
            }
            .onDelete(perform: { do { try deleteListe(at: $0) } catch { fatalError(error.localizedDescription) } })
            .onMove(perform: moveListe)
            
            if vm.showTextField {
                TextField("Nouvelle liste", text: $vm.textFieldText)
                    .onSubmit { textFieldSubmited() }
            }
        }
        .environment(\.editMode, editMode)
        
        .listStyle(.inset)
        .navigationTitle("Listes")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) { sideMenuButton }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                EditButton()
                addButton
            }
        }

    }
    
    
    private var sideMenuButton: some View {
        Button { showSideMenu() } label: { Image(systemName: "list.bullet") }
    }
    
    private var addButton: some View {
        Button { vm.showTextField = true } label: { Image(systemName: "plus") }
    }
    
    private func deleteListe(at offsets: IndexSet) throws {
        listes.remove(atOffsets: offsets)
    }
    
    private func moveListe(sources: IndexSet, destination: Int) {
        listes.move(fromOffsets: sources, toOffset: destination)
    }
    
    private func textFieldSubmited() {
        if vm.textFieldText != "" {
            listes.append(Liste(name: vm.textFieldText, context: DataController.shared.mainQueueManagedObjectContext))
            vm.textFieldText = ""
            vm.showTextField = false
        }
    }
}
