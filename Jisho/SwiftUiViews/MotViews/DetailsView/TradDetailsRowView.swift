//
//  TradDetailsRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/13.
//

import SwiftUI



struct TradDetailsRowView<A: View>: View
{
    @ObservedObject var trad: Traduction
    
    var contexMenuActions: (() -> A)?
    var addToSenseActions: (() -> A)?
    
    @State var showConfirDialog = false
    
    init(trad: Traduction, contexMenuActions: (() -> A)? = nil, addToSenseActions: (() -> A)? = nil) {
        _trad = ObservedObject(initialValue: trad)
        self.contexMenuActions = contexMenuActions
        self.addToSenseActions = addToSenseActions
    }
    
    var body: some View
    {
        HStack(alignment:.top) {
            Text(trad.langue.flag)
            Text(trad.traductions?.joined(separator: ", ") ?? "Pas de traduction")
        }
        .frame(minHeight:20)
        .contextMenu {
            if addToSenseActions != nil {
                Button("Ajouter a un sense") { showConfirDialog.toggle() }
            }
            if let contexMenuActions = contexMenuActions {
                contexMenuActions()
            }
        }
        .confirmationDialog("Quel Sense", isPresented: $showConfirDialog) {
            if let addToSenseActions = addToSenseActions {
                addToSenseActions()
            }
        }
    }
}
