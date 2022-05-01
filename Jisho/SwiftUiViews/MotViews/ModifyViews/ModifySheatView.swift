//
//  ModifySheatView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/02.
//

import SwiftUI

struct ModifySheatView: View{

    @Environment(\.dismiss) var dismiss

    @ObservedObject var mot:Mot
    @State var motStrc:MotStruct
    
    var options:ModifyOption

    
    var body: some View {
        NavigationView {
            switch options {
                
            case .all:
                modifyAll
                
            case .japonais(let i):
                ModifyJaponaisView(japonais: $motStrc.japonais[i])
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            applyButton
                        }
                    }
                
            case .sense(let i):
                ModifySenseView(sense: $motStrc.senses[i])
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            applyButton
                        }
                    }
                
            case .notes:
                ModifyNotesView(text: $motStrc.notes)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            applyButton
                        }
                    }
            }
        }
    }

    
    var modifyAll: some View {
        
            List {

                Section(header: Text("Japonais"), footer: Button("Ajouter") { motStrc.japonais.append(JaponaisStruct()) })
                {
                    ForEach($motStrc.japonais, content: ModifySheetJapRow.init)
                        .onDelete(perform: deleteJap)
                }


                Section(header: Text("Senses"), footer: Button("Ajouter") { motStrc.senses.append(SenseStruct()) })
                {
                    ForEach($motStrc.senses) {
                        ModifySheetSenseRow(sense: $0)
                    }
                    .onDelete(perform: deleteSense)
                }
                
                
                Section("Notes") {
                    NavigationLink(destination: ModifyNotesView(text: $motStrc.notes)) {
                        Text(motStrc.notes != "" ? motStrc.notes : "Pas de notes")
                    }


                }


                applyButton
            }
            .navigationBarTitleDisplayMode(.inline)
    }
    
    var applyButton : some View {
        
        Button("Appliquer")
        {
            if motStrc != MotStruct(mot)
            {
                mot.modify(motStrc)
            }

            dismiss()
        }
    }
    
    
    func deleteJap(at offsets: IndexSet) {
        motStrc.japonais.remove(atOffsets: offsets)
    }

    func deleteSense(at offsets: IndexSet) {
        motStrc.senses.remove(atOffsets: offsets)
    }
}

fileprivate struct ModifySheetJapRow: View {
        
    @Binding var jap:JaponaisStruct

    var body: some View
    {
        NavigationLink(destination: ModifyJaponaisView(japonais: $jap))
        {
            HStack
            {
                Text(jap.kanji != "" ? jap.kanji : "Pas de kanji")
                Text(jap.kana != "" ? jap.kana : "Pas de kana")
            }
        }
    }
}

fileprivate struct ModifySheetSenseRow: View {
        
    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    @Binding var sense: SenseStruct

    var body: some View
    {
        let firstTrad = sense.traductionsArray.sorted(languesPref.wrappedValue).first(where: {
            $0.traductions != "" && languesAffichées.wrappedValue.contains($0.langue)
        })
        
        NavigationLink( destination: ModifySenseView(sense: $sense) )
        {
            if let firstTrad = firstTrad
            {
                Text(firstTrad.traductions != "" ? firstTrad.traductions : "Pas de traduction")
            }
            else
            {
                Text("Pas de traduction")
            }
        }
    }
}






//struct ModificationSheatView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        Text("Background")
//            .sheet(isPresented: .constant(true)) {
//                ModifySheatView(mot: Mot(), motStrc: MotStruct(), options: .all)
//            }
//    }
//}
