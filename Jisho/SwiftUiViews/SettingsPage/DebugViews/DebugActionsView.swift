//
//  DebugActionsView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/05/14.
//

import SwiftUI

fileprivate class DebugActionsViewModel: ObservableObject {
    
    @Published var loadingStatus: LoadingStatus = .finished
    
}

struct DebugActionsView: View {
    @Environment(\.toggleSideMenu) var showSideMenu
    
    @StateObject private var vm = DebugActionsViewModel()

    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                switch vm.loadingStatus {
                    
                case .loading:
                    ProgressView()
                
                case .loadingPercent(let description, let percent):
                    Text("\(description) - \(percent)%")
                    
                case .finished:
                    Text("Finished")
                }
                
                Spacer()
            }
            List {
                Button("Re import JMdict") {
                    
                }
                
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showSideMenu()
                } label: {
                    Image(systemName: "list.bullet")
                }
            }
        }
    }
}

struct DebugActionsView_Previews: PreviewProvider {
    static var previews: some View {
        DebugActionsView()
    }
}
