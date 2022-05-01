//
//  Extentions.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/05.
//

import Foundation
import CoreData
import SwiftUI


extension String: Identifiable{
    public var id: UUID{
        return UUID()
    }
}


extension Array where Element : Traduction {
    func sorted(_ languesPref:[Langue]) -> Array<Element> {
        return self.sorted {
            return languesPref.firstIndex(of: $0.langue)! < languesPref.firstIndex(of: $1.langue)!
        }
    }
}

extension Array where Element == TraductionStruct {
    func sorted(_ languesPref:[Langue]) -> Array<Element> {
        return self.sorted {
            return languesPref.firstIndex(of: $0.langue)! < languesPref.firstIndex(of: $1.langue)!
        }
    }
}


extension View {
    func sideMenu(isPresented: Binding<Bool>, currentPage: Binding<Page>) -> some View {
        
        ZStack(alignment: .topLeading) {
            self
            
            if isPresented.wrappedValue {
                
                Rectangle()
                    .fill(Color.primary.opacity(0.2)).ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented.wrappedValue.toggle()
                        }
                    }.zIndex(1)
                
                SideMenuView()
                    .environment(\.switchPage, { page in
                        
                        currentPage.wrappedValue = page
                        
                        withAnimation {
                            isPresented.wrappedValue.toggle()
                        }
                    })
                    .offset(x: 10, y: 10)
                    .transition(.move(edge: .leading).combined(with: .move(edge: .top)))
                    .zIndex(2)
            }
        }
    }
}
