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

    var modifyOptions: ModifyOption = .all

    func showModifySheat(_ option:ModifyOption) {
        self.modifyOptions = option
        self.showSheet.toggle()

    }

}

struct MotDetailsView: View
{
    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    @StateObject private var vm: MotDetailsViewModel
    @StateObject private var mot: Mot
        
    @Environment(\.toggleSideMenu) var showSideMenu
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "timestampAtb", ascending: false)])
        var listes: FetchedResults<Liste>


    init(_ mot:Mot) {
        
        _mot = StateObject(wrappedValue: mot)
        _vm = StateObject(wrappedValue: MotDetailsViewModel())
    }
    

    var body: some View {
        
        List {
        
            Section("Japonais")
            {
                if let japs = mot.japonais
                {
                    ForEach(japs) { jap in
                        JaponaisDetailsRowView(jap: jap)
                            .contextMenu {
                                Button("Modifier") {
                                    vm.showModifySheat(.japonais(Int(jap.ordre)))
                                }
                            }
                    }
                }
                else
                {
                    Text("Pas de japonais")
                        .font(.largeTitle)
                        .padding(.vertical, 6.0)
                }
            }
            
            if let senses = mot.senses
            {
                ForEach(senses) { sense in
                    Section("Sense \(sense.ordre + 1)")
                    {
                        SenseDetailsRowView(sense: sense)
                            .contextMenu {
                                Button("Modifier") {
                                    vm.showModifySheat(.sense(Int(sense.ordre)))
                                }
                            }
                    }
                }
            }
            else
            {
                Section("Senses")
                {
                    Text("Pas de sense")
                        .frame(minHeight:20)
                }
            }
            
            notesSection
            
            if let noSenseTrads = mot.noSenseTradsArray?.sorted(languesPref.wrappedValue) {
                Section("Autres traductions") {
                    ForEach(noSenseTrads) { trad in
                        if languesAffichées.wrappedValue.contains(trad.langue) {
                            
                            TradDetailsRowView(trad: trad)
                                .contextMenu {
                                    ForEach(mot.senses ?? []) { sense in
                                        if !((sense.traductionsArray?.contains(where: { $0.langue == trad.langue })) == true) {
                                            Button("Ajouter au sense \(sense.ordre + 1)") {
                                                
                                                var motStrc = MotStruct(mot)
                                                                        
                                                motStrc.senses[Int(sense.ordre)].traductionsArray.append(
                                                    motStrc.noLangueTrads.remove(at: motStrc.noLangueTrads.firstIndex(where: { $0 == trad })!)
                                                )
                                                
                                                mot.modify(motStrc)
                                            }
                                        }
                                    }
                                }
                        }
                    }
                }
            }            
        }
            
        
        .environment(\.defaultMinListRowHeight, 0)
        
        .listStyle(.grouped)
        
        .toolbar {
                        
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                
                addToListButton
                menuButton
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSideMenu()
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
                
        .navigationBarTitleDisplayMode(.inline)
        
        .sheet(isPresented: $vm.showSheet) { ModifySheatView(mot: mot, motStrc: MotStruct(mot), options: vm.modifyOptions) }
    }

    var menuButton: some View {
        Menu
        {
            Button("Modifier") { vm.showModifySheat(.all) }
            
            if let motAsJMdict = mot as? MotJMdict {
                if try! motAsJMdict.getModifier() != nil {
                    
                    Button("Reset") { mot.reset() }
                }
            }
        }
        label:
        {
            Image(systemName: "ellipsis.circle")
        }
        .padding([.leading,.bottom,.top])
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
    
    var notesSection: some View {
        Section("Notes") {
            
            if mot.notes == nil {
                Button {
                    vm.showModifySheat(.notes)
                } label: {
                    Text(mot.notes ?? "Ajouter une note")
                }
            }
            else {
                Button {
                    vm.showModifySheat(.notes)
                } label: {
                    Text(mot.notes ?? "Pas de Notes")
                }
                .accentColor(.primary)
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
