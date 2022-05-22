//
//  ImportResumeSheetView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/16.
//

import SwiftUI

struct ImportResumeSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var nbrListes: Int
    var nbrMots: Int
    
    var importAction: () async throws -> Void
    
    @State var isImporting = false
    
    var body: some View {
        VStack {
            List {
                Text("Listes a importer : \(nbrListes)")
                Text("Mots a importer : \(nbrMots)")
            }
            .listStyle(.plain)
            HStack {
                Spacer()
                Button {
                    Task {
                        self.isImporting = true
                        try await importAction()
                        self.isImporting = false
                        self.dismiss()
                    }
                } label: {
                    Group {
                        if isImporting {
                            ProgressView()
                        }
                        else {
                            Text("Importer")
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 250, height: 45)
                    .background(.blue)
                    .cornerRadius(5)
                }
                Spacer()
            }
        }
        .padding(.vertical)
    }
}






//struct ImportResumeSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        Text("Background")
//            .sheet(isPresented: .constant(true)) {
//                ImportResumeSheetView()
//            }
//    }
//}
