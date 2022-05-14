//
//  ListePage.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/26.
//

import SwiftUI
import CoreData

fileprivate class ListePageViewModel: ObservableObject {
    @Published var showAlert = false

    
    func alertSumited(result: String?) {
        if let text = result, text != "" {
            do {
                try createListe(name: text)
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func deleteListe(at offsets: IndexSet) throws {
        let request:NSFetchRequest<NSManagedObjectID> = Liste.fetchRequest()
        request.predicate = NSPredicate(format: "parent == nil")
        request.sortDescriptors = [NSSortDescriptor(key: "ordreInParentAtb", ascending: true)]
        let rootLists:[NSManagedObjectID] = try DataController.shared.mainQueueManagedObjectContext.fetch(request)
        
        offsets.forEach { DataController.shared.mainQueueManagedObjectContext.delete(rootLists[$0].getObject(on: .mainQueue)) }
        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    

    private func createListe(name: String) throws {
        let request:NSFetchRequest<NSManagedObjectID> = Liste.fetchRequest()
        request.predicate = NSPredicate(format: "parent == nil")
        request.sortDescriptors = [NSSortDescriptor(key: "ordreInParentAtb", ascending: true)]
        let rootLists:[NSManagedObjectID] = try DataController.shared.mainQueueManagedObjectContext.fetch(request)
        
        let lastListe:Liste? = rootLists.last?.getObject(on: .mainQueue)
        let lastOrdre: Int64 = lastListe?.ordre ?? -1
                
        _ = Liste(ordre: lastOrdre + 1, name: name, context: DataController.shared.mainQueueManagedObjectContext)
                        
        Task {
            do {
                try await DataController.shared.save()
            }
            catch {
                fatalError(error.localizedDescription)
            }
        }
    }
}


struct ListePageView: View {
    @Environment(\.toggleSideMenu) var showSideMenu

    @StateObject private var vm = ListePageViewModel()
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.ordreInParentAtb)],
                  predicate: NSPredicate(format: "parent == nil")) var listes: FetchedResults<Liste>
    
        
    var body: some View {
        
        List {
            ForEach(listes) { liste in
                
                NavigationLink("\(liste.name ?? "No name")") {
                    ListeView(liste: liste)
                }
                .isDetailLink(false)
                 
            }
            .onDelete(perform: { do { try vm.deleteListe(at: $0) } catch { fatalError(error.localizedDescription) } })
        }
        
        .alert(isPresented: $vm.showAlert, TextAlert(action: vm.alertSumited))
        .listStyle(.inset)
        .navigationTitle("Listes")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) { sideMenuButton }
            ToolbarItemGroup(placement: .navigationBarTrailing) { addButton }
        }

    }
    
    
    private var sideMenuButton: some View {
        Button { showSideMenu() } label: { Image(systemName: "list.bullet") }
    }
    
    private var addButton: some View {
        Button { vm.showAlert.toggle() } label: { Image(systemName: "plus") }
    }
    
}
