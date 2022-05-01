//
//  ModifyNotesView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/27.
//

import SwiftUI

struct ModifyNotesView: View {
    
    @Binding var text:String
    
    var body: some View {
        TextEditor(text: $text)
            .overlay( RoundedRectangle(cornerRadius: 6) .stroke(Color(.systemGray5), lineWidth: 1.0) )
            .padding()

    }
}

struct ModifyNotesView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyNotesView(text: .constant("Notes exemple")).previewDevice("iPhone X")
    }
}
