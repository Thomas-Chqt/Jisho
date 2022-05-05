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

extension Array where Element : Traduction {
    func compacted(_ langueAffiché: Set<Langue>) -> Array<Element> {
        return self.compactMap {
            if langueAffiché.contains($0.langue) {
                return $0
            }
            else {
                return nil as Element?
            }
        }
    }
}

extension Array {
    func compacted(_ closure: (Element) -> Bool ) -> Array<Element> {
        return self.compactMap {
            if closure($0) {
                return $0
            }
            else {
                return nil as Element?
            }
        }
    }
}

extension Array where Element == Langue {
    func sorted(languesPref: [Langue]) -> Array<Element> {
        return self.sorted {
            return languesPref.firstIndex(of: $0)! < languesPref.firstIndex(of: $1)!
        }
    }
}

extension Sense {
    func contains(tradWith langue: Langue) -> Bool {
        return self.traductionsArray?.map { $0.langue }.contains(langue) ?? false
    }
}

extension Array where Element == Sense {
    
    func compacted(notContain langue: Langue) -> Array<Element> {
        return self.compacted { !$0.contains(tradWith: langue)  }
    }
}


extension Array {
    
    func separated(by separator: Element) -> [Element] {
        return (0 ..< 2 * self.count - 1).map { $0 % 2 == 0 ? self[$0/2] : separator }
    }
    
}

extension Optional where Wrapped == Array<Japonais> {
    
    static func == (rhs: Optional<Wrapped>, lhs: Optional<Wrapped>) -> Bool {
        
        guard let rhs = rhs else { if lhs == nil { return true } else { return false } }
        guard let lhs = lhs else { return false }
        
        if rhs.count != lhs.count { return false }

        for i in 0...rhs.count - 1 {
            if (rhs[i] == lhs[i]) == false { return false }
        }
        
        return true
    }
}

extension Optional where Wrapped == Array<Sense> {
    
    static func == (rhs: Optional<Wrapped>, lhs: Optional<Wrapped>) -> Bool {
        
        guard let rhs = rhs else { if lhs == nil { return true } else { return false } }
        guard let lhs = lhs else { return false }
        
        if rhs.count != lhs.count { return false }

        for i in 0...rhs.count - 1 {
            if (rhs[i] == lhs[i]) == false { return false }
        }
        
        return true
    }
}

extension Optional where Wrapped == Array<Traduction> {
    
    static func == (rhs: Optional<Wrapped>, lhs: Optional<Wrapped>) -> Bool {
        
        guard let rhs = rhs else { if lhs == nil { return true } else { return false } }
        guard let lhs = lhs else { return false }
        
        if rhs.count != lhs.count { return false }

        for i in 0...rhs.count - 1 {
            if (rhs[i] == lhs[i]) == false { return false }
        }
        
        return true
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

