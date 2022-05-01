//
//  LanguesAffichéView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/07.
//

import SwiftUI

struct LanguesAffiche_View: View {
    
//    @EnvironmentObject var settings: Settings

    @Environment(\.languesPref) var languesPref
    @Environment(\.languesAffichées) var languesAffichées
    
    var body: some View
    {
        List(selection: languesAffichées.projectedValue)
        {
            ForEach(languesPref.wrappedValue){ langue in
                if langue != .none {
                    LangueRowView(langue: langue) { flag, fullName in
                        HStack
                        {
                            Text(flag)
                            Text(fullName)
                        }
                    }
                }
                
            }
            .onMove(perform: move)
        }
        .environment(\.editMode, .constant(.active))
        .toolbar
        {
            ToolbarItem(placement: .navigationBarTrailing) { menuButton }
        }
    }
    
    var menuButton: some View {
        Menu
        {
            Button("Reset")
            {
                languesPref.wrappedValue = languesPrefOriginal
                languesAffichées.wrappedValue = languesAffichéesOriginal
            }
        }
        label:
        {
            Image(systemName: "ellipsis.circle")
        }
        .padding([.leading,.bottom,.top])
    }
    
    func move(from source: IndexSet, to destination: Int) {
        languesPref.wrappedValue.move(fromOffsets: source, toOffset: destination)
    }
}

struct LanguesAffiche_View_Previews: PreviewProvider {
    static var previews: some View {
        LanguesAffiche_View()
    }
}
