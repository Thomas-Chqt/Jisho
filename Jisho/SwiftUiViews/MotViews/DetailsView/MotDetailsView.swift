//
//  MotDetailsView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/23.
//

import SwiftUI
import CoreData

fileprivate class MotDetailsViewModel: ObservableObject {
    
    @Published var showSheet = false
    
    var sheetView = AnyView(EmptyView())
    
    func showSheet<Content: View>(view: Content) {
        sheetView = AnyView(view)
        showSheet.toggle()
    }
}

struct MotDetailsView: View
{
    @Environment(\.toggleSideMenu) var showSideMenu

    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    @StateObject private var vm: MotDetailsViewModel = MotDetailsViewModel()
    @MotWrapper var mot: Mot
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestampAtb", ascending: false)])
        var listes: FetchedResults<Liste>

    var body: some View {
        
        List {
            
            Section("Japonais") {
                if let japs = mot.japonais {
                    ForEach(japs) { jap in
                        JaponaisDetailsRowView(jap: jap)
                            .contextMenu {
                                Button {
                                    let index = mot.japonais!.firstIndex(of: jap)!
                                    let sheetView = ModifyJapSheetView( modifiableJaponais: $mot.japonais![index] )
                                    vm.showSheet( view: sheetView )
                                }
                                label: { Label("Modifier", systemImage: "pencil.circle") }
                            }
                    }
                }
                else {
                    Text("Pas de japonais")
                        .font(.largeTitle)
                        .padding(.vertical, 6.0)
                }
            }
            
            if let senses = mot.senses {
                ForEach(senses) { sense in
                    Section("Sense \(sense.ordre + 1)") {
                        SenseDetailsRowView(sense: sense)
                            .contextMenu {
                                Button {
                                    let index = mot.senses!.firstIndex(of: sense)!
                                    let sheetView = ModifySenseSheetView( modifiableSense: $mot.senses![index] )
                                    vm.showSheet( view: sheetView )
                                }
                                label: { Label("Modifier", systemImage: "pencil.circle") }
                            }
                    }
                }
            }
            else {
                Section("Senses") {
                    Text("Pas de sense")
                        .frame(minHeight:20)
                }
            }
            
            Section("Notes") {
                if let notes = mot.notes {
                    Button(notes) {
                        vm.showSheet(view: ModifyNotesSheetView(notes: Binding(get: { $mot.notes ?? "" },
                                                                               set: { $mot.notes = ($0 == "" ? nil : $0) })))
                    }
                    .foregroundColor(.primary)
                }
                else {
                    Button("Pas de notes") {
                        vm.showSheet(view: ModifyNotesSheetView(notes: Binding(get: { $mot.notes ?? "" },
                                                                               set: { $mot.notes = ($0 == "" ? nil : $0) })))
                    }
                }
            }
            
            if let noSenseTrads = mot.noSenseTradsArray?.sorted(languesPref.wrappedValue).compacted(languesAffichées.wrappedValue) {
                Section("Autres traductions") {
                    ForEach(noSenseTrads) { trad in
                        TradDetailsRowView(trad: trad, contexMenuActions: nil) {
                            ForEach(mot.senses?.compacted(notContain: trad.langue) ?? []) { senseToMoveIn in
                                
                                if let senseToMoveInIndex = mot.senses?.firstIndex( where: { $0 == senseToMoveIn } ) {
                                    Button("Sense n°\( senseToMoveInIndex + 1)") {
                                        $mot.moveNoSenseTradToTrad(noSenseTradToMove: trad, senseToMoveIn: senseToMoveIn)
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
                                else { fatalError() }
                            }
                        }
                    }
                }
            }
            
        }
            
        .environment(\.defaultMinListRowHeight, 0)
        
        .listStyle(.grouped)
        .navigationBarTitleDisplayMode(.inline)

        .sheet(isPresented: $vm.showSheet, onDismiss: sheetDismied) { vm.sheetView }
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                addToListButton
                menuButton
            }
            
            ToolbarItem(placement: .navigationBarLeading) { showSideMenuButton }
        }
             
    }
    
    
    var menuButton: some View {
        Menu {
            Button("Modifier") { vm.showSheet(view: ModifyMotSheetView(modifiableMot: $mot)) }
            
            if let motAsJMdict = mot as? MotJMdict {
                if try! motAsJMdict.getModifier() != nil {
                    Button("Reset") { motAsJMdict.deleteModifier() }
                }
            }
        }
        label: {
            Image(systemName: "ellipsis.circle")
        }
        .padding([.leading,.bottom,.top])
    }
    
    
    var showSideMenuButton: some View {
        Button {
            showSideMenu()
        } label: {
            Image(systemName: "list.bullet")
        }
    }
    
    var addToListButton: some View {
        Menu {
            ForEach(listes) { liste in
                
                if liste.contains(mot) {
                    Button {
                        liste.removeMot(mot)
                    } label: {
                        HStack {
                            Image(systemName: "checkmark")
                            Text(liste.name ?? "No name")
                        }
                    }
                }
                else {
                    Button {
                        liste.addMot(mot)
                    } label: {
                        HStack {
                            Text(liste.name ?? "No name")
                        }
                    }
                }
            }
        }
        label: {
            Image(systemName: listes.allSatisfy({ $0.contains(mot) == false }) ? "star" : "star.fill")
        }
    }

    func sheetDismied() {
        
        if let motJMdict = mot as? MotJMdict {
            if motJMdict.isEqualToModifier() {
                motJMdict.deleteModifier(save: false)
            }
            else {
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
        else {
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
}





//struct MotDetailsView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        NavigationView
//        {
//            MotDetailsView(Mot(odre: 0, notes: "Notes", context: DataController.shared.mainQueueManagedObjectContext))
//        }
//    }
//}
