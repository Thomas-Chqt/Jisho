//
//  ModifySenseView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/04.
//

import SwiftUI


struct ModifySenseView: View {
        
    @Binding var sense:SenseStruct
            
    var body: some View {
        List
        {
            Section(header: Text("Meta datas"), footer: Button("Ajouter") { sense.metaDatas.append(CommunMetaData.nomCommun) }) {
                ForEach($sense.metaDatas) {
                    ModifySenseMetaDataRow(metaData: $0)
                }
                .onDelete(perform: deleteMetaData)
            }

            
            Section(header: Text("Traductions"), footer: Button("Ajouter") { sense.traductionsArray.append(TraductionStruct()) })
            {
                ForEach($sense.traductionsArray) {
                    ModifySenseTraductionPart(trad: $0, sense: sense)
                }
                .onDelete(perform: deleteTrad)
            }
        }
    }
    
    func deleteTrad(at offsets: IndexSet) {
        sense.traductionsArray.remove(atOffsets: offsets)
    }
    
    func deleteMetaData(at offsets: IndexSet) {
        sense.metaDatas.remove(atOffsets: offsets)
    }
}


fileprivate struct ModifySenseMetaDataRow: View {
    
    @Binding var metaData: MetaData
    
    @State var showMetaDataPickerSheat = false
    
    var body: some View {
        Button {
            showMetaDataPickerSheat.toggle()
        } label: {
            MetaDataRowView(metaData: metaData) { Text($0) }
        }
        .sheet(isPresented: $showMetaDataPickerSheat) {
            ModifyMetaDataSheet(metaData: $metaData)
        }
    }
    
    
}

fileprivate struct ModifyMetaDataSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var metaData: MetaData
    
    
    var body: some View {
            
        MetaDataListView() { metaData in
            Button {
                self.metaData = metaData
                dismiss()
                
            } label: {
                MetaDataRowView(metaData: metaData) { Text($0) }
            }
            .buttonStyle(.plain)
        }
    }
}

fileprivate struct ModifySenseTraductionPart: View {
        
    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    @Binding var trad: TraductionStruct
    var sense: SenseStruct
    
    var body: some View
    {
        if languesAffichées.wrappedValue.contains(trad.langue)
        {
            HStack
            {
                menuFlag
                TextField("Traduction", text: $trad.traductions)
            }
        }
    }
    
    var menuFlag: some View
    {
        Menu(trad.langue.flag)
        {
            ForEach(languesAffichées.wrappedValue.sorted { languesPref.wrappedValue.firstIndex(of: $0)! <
                                                            languesPref.wrappedValue.firstIndex(of: $1)! })
            { langue in
                if (!sense.traductionsArray.contains(where: { $0.langue == langue })) && (langue != .none)
                {
                    LangueRowView(langue: langue) { flag, fullName in
                        Button("\(flag) \(fullName)") {
                            trad.langue = langue
                        }
                    }
                }
            }
            
            Button("\(Langue.none.flag) Pas de langue")
            {
                trad.langue = .none
            }
        }
    }
}




struct ModifySenseView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Background")
            .sheet(isPresented: .constant(true)) {
                NavigationView {
                    ModifySenseView(sense: .constant(SenseStruct()))
                }
            }
    }
}
