//
//  ModifySenseSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/04.
//

import SwiftUI

fileprivate class ModifySenseSheetViewModel: ObservableObject {
    
    @Published var showSheet = false
    
    var sheetView:AnyView = AnyView(EmptyView())
    
    func showSheet<Content: View>(view: Content) {
        sheetView = AnyView(view)
        showSheet.toggle()
    }
}

struct ModifySenseSheetView: View {
    @Environment(\.dismiss) var dismiss
//    @Environment(\.metaDataDict) var metaDataDict
    @EnvironmentObject private var settings: Settings
    
    @StateObject private var vm = ModifySenseSheetViewModel()
    @ObservedObject var modifiableSense: Sense

    var body: some View {
        List {
            Section( header: Text("MetaDatas"), footer: Button("Ajouter") { addNewMetaData() } ) {
                if modifiableSense.metaDatas?.isEmpty == false {
                    metadataSection
                }
                else {
                    Text("Pas de MetaData")
                }
            }
            
            Section( header: Text("Traductions"), footer: Button("Ajouter") { addNewTrad() } ) {
                if modifiableSense.traductionsArray?.isEmpty == false {
                    traductionSection
                }
                else {
                    Text("Pas de Traduction")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $vm.showSheet) { vm.sheetView }
    }
    
    
    
    //MARK: Traductions Section

    var traductionSection: some View {
        
        ForEach(modifiableSense.traductionsArray ?? []) { trad in
            HStack {
                FlagMenuView(langue: Binding(get: { trad.langue }, set: { trad.langue = $0 }),
                             existingLangues: Set( modifiableSense.traductionsArray?.map { $0.langue } ?? [] ) )
                
                TextField("Traductions", text: Binding(get: { trad.traductions?.joined(separator: ", ") ?? "" },
                                                       set: { trad.traductions = $0.components(separatedBy: ", ") }))
            }
        }
        .onDelete(perform: deleteTrad)
    }
    
    
    func addNewTrad() {
        let newTrad = Traduction(ordre: (modifiableSense.traductionsArray?.last?.ordre ?? -1) + 1,
                                 langue: .none, traductions: nil, context: modifiableSense.context)
        
        modifiableSense.traductionsArray = (modifiableSense.traductionsArray ?? []) + [newTrad]
    }
    
    func deleteTrad(_ indexSet: IndexSet) {
        modifiableSense.traductionsArray?.remove(atOffsets: indexSet)
    }
    
    
    
    //MARK: MetaDatas Section
    
    var metadataSection: some View {
        ForEach(Binding(get: { modifiableSense.metaDatas ?? [] }, set: { modifiableSense.metaDatas = $0 })) { $metaData in
            HStack {
                Button(metaData.description(settings.metaDataDict)) {
                    vm.showSheet(view: MetaDataPickerSheetView(selectedMetaData: $metaData ))
                }
            }
        }
        .onDelete(perform: deleteMetaData)
    }
    
    
    func addNewMetaData() {
        modifiableSense.metaDatas = (modifiableSense.metaDatas ?? []) + [CommunMetaData.nomCommun]
    }
    
    func deleteMetaData(_ indexSet: IndexSet) {
        modifiableSense.metaDatas?.remove(atOffsets: indexSet)
    }
}




fileprivate struct FlagMenuView: View {
    
//    @Environment(\.languesPref) var languesPref
//    @Environment(\.languesAffichées) var languesAffichées
    @EnvironmentObject private var settings: Settings
    
    @Binding var langue: Langue
    
    var existingLangues: Set<Langue>
    
    var body: some View {
        
        let selectableOrderedLangues =
            Array(settings.languesAffichées).sorted(languesPref: settings.languesPref).compactMap { langue -> Langue? in
                if langue == .none {
                    return nil as Langue?
                }
                else if existingLangues.contains(langue) {
                    return nil as Langue?
                }
                else {
                    return langue
                }
            }
        
        Menu(langue.flag)
        {
            ForEach(selectableOrderedLangues) { lang in
                Button("\(lang.flag) \(lang.fullName)") {
                    langue = lang
                }
            }
            
            Button("\(Langue.none.flag) Pas de langue")
            {
                langue = .none
            }
        }
        
    }
}





/*
struct ModifySenseSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ModifySenseSheetView()
    }
}
*/
