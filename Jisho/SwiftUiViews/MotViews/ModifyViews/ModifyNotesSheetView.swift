//
//  ModifyNotesSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/04.
//

import SwiftUI

struct ModifyNotesSheetView: View {
    @Environment(\.dismiss) var dismiss

    @Binding var notes: String

    var body: some View {
        TextEditor(text: $notes)
            .padding(4)
            .overlay(content: {
                RoundedRectangle(cornerRadius: 3)
                    .stroke(.primary, lineWidth: 0.5)
            })
            .padding()
            .navigationBarTitleDisplayMode(.inline)
    }
}



struct ModifyNotesSheetView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("background")
                .sheet(isPresented: .constant(true)) {
                    ModifyNotesSheetView(notes: .constant("test"))
                }
        }
        .previewDevice("iPhone X")
        
    }
}
