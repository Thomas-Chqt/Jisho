//
//  ModifyMotSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/03.
//

import SwiftUI

struct ModifyMotSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    @ObservedObject var modifiableMot: Mot    
    
    var body: some View {
        NavigationView {
            List {
                Section( header: Text("Japonais"), footer: Button("Ajouter") { addNewJaponais() } ) {
                    if modifiableMot.japonais?.isEmpty == false {
                        japSection
                    }
                    else {
                        Text("Pas de Japonais")
                    }
                }
                
                Section( header: Text("Senses"), footer: Button("Ajouter") { addNewSense() } ) {
                    if modifiableMot.senses?.isEmpty == false {
                        senseSection
                    }
                    else {
                        Text("Pas de Senses")
                    }
                }
                
                Section("Notes") {
                    NavigationLink(destination: ModifyNotesSheetView(notes: Binding( get: { modifiableMot.notes ?? "" },
                                                                                     set: { modifiableMot.notes = ($0 == "" ? nil : $0) } ))) {
                        Text(modifiableMot.notes ?? "Pas de notes")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    
    var japSection: some View {
        ForEach(modifiableMot.japonais ?? []) { jap in
            NavigationLink(destination: ModifyJapSheetView(modifiableJaponais: jap)) {
                Text("\(jap.kanji ?? "Pas de kanji") - \(jap.kana ?? "Pas de kana")")
            }
        }
        .onDelete(perform: deleteJaponais)
    }
    
    
    var senseSection: some View {
        ForEach(modifiableMot.senses ?? []) { sense in
            NavigationLink(destination: ModifySenseSheetView(modifiableSense: sense)) {
                Text("\(sense.traductionsArray?.sorted(languesPref.wrappedValue).first(where: { languesPref.wrappedValue.contains($0.langue) })?.traductions?.joined(separator: ", ") ?? "Pas de traductions" )")
            }
        }
        .onDelete(perform: deleteSense)
    }
    
    
    
    
    func addNewJaponais() {
        let newJaponais = Japonais(ordre: (modifiableMot.japonais?.last?.ordre ?? -1) + 1,
                                   kanji: nil, kana: nil, context: modifiableMot.context)
        
        modifiableMot.japonais = (modifiableMot.japonais ?? []) + [newJaponais]
    }
    
    func addNewSense() {
        let newSense = Sense(ordre: (modifiableMot.senses?.last?.ordre ?? -1) + 1,
                             metaDatas: nil, traductions: nil, context: modifiableMot.context)
        
        modifiableMot.senses = (modifiableMot.senses ?? []) + [newSense]
    }
    
    func deleteJaponais(_ indexSet: IndexSet) {
        modifiableMot.japonais?.remove(atOffsets: indexSet)
    }
    
    func deleteSense(_ indexSet: IndexSet) {
        modifiableMot.senses?.remove(atOffsets: indexSet)
    }
    
}



/*
struct ModifyMotSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyMotSheetView()
    }
}
*/
