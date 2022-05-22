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

extension String {
    func addHtml(balise: BaliseHTLM, htlmClass:String? = nil) -> Self {
        
        var classString = ""
        
        if let htlmClass = htlmClass {
            classString = " class=\(htlmClass)"
        }
        
        switch balise {
        case .p:
            return "<p\(classString)>\(self)</p>"
            
        case .div:
            return "<div\(classString)>\(self)</div>"
        }
    }
}


extension Array {
    
    func separated(by separator: Element) -> [Element] {
        return (0 ..< 2 * self.count - 1).map { $0 % 2 == 0 ? self[$0/2] : separator }
    }
    
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
    
    func sorted(_ languesPref:[Langue]) -> Array<Element> {
        return self.sorted {
            return languesPref.firstIndex(of: $0.langue)! < languesPref.firstIndex(of: $1.langue)!
        }
    }
    
    func sortedCompacted(_ setttings: Settings) -> Array<Element> {
        return self.sorted(setttings.languesPref).compacted(setttings.languesAffichées)
    }
}

extension Array where Element == Langue {
    func sorted(languesPref: [Langue]) -> Array<Element> {
        return self.sorted {
            return languesPref.firstIndex(of: $0)! < languesPref.firstIndex(of: $1)!
        }
    }
}

extension Array where Element == Sense {
    
    func compacted(notContain langue: Langue) -> Array<Element> {
        return self.compacted { !$0.contains(tradWith: langue)  }
    }
}

extension Array where Element == NSManagedObjectID {
    func getObjects<ObjectType: NSManagedObject>(on queue: Queue) -> [ObjectType] {
        switch queue {
        case .mainQueue:
            return self.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! ObjectType }
            
        case .privateQueue:
            return self.map { DataController.shared.privateQueueManagedObjectContext.object(with: $0) as! ObjectType }
        }
    }
}

extension Array where Element == URL {
    func getObjectIDs() -> [NSManagedObjectID] {
        return self.map {
            DataController.shared.container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: $0)!
        }
    }
}

extension Array where Element : NSManagedObject {
    func getObjectIDs(on queue: Queue) throws -> [NSManagedObjectID] {
        switch queue {
        case .mainQueue:
            try DataController.shared.mainQueueManagedObjectContext.obtainPermanentIDs(for: self)
            return self.map { $0.objectID }
            
        case .privateQueue:
            try DataController.shared.privateQueueManagedObjectContext.obtainPermanentIDs(for: self)
            return self.map { $0.objectID }
        }
        
    }
}

extension Array where Element == [String] {
    var csvString: String {
        get {
            let rows = self.map { row in
                return row.map { cell in
                    return "\"\(cell)\""
                }.joined(separator: ",")
            }
            
            return rows.joined(separator: "\n")
        }
    }
}


extension Sense {
    func contains(tradWith langue: Langue) -> Bool {
        return self.traductionsArray?.map { $0.langue }.contains(langue) ?? false
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


extension NSManagedObjectID {
    func getObject<ObjectType: NSManagedObject>(on queue: Queue) -> ObjectType {
        switch queue {
        case .mainQueue:
            return DataController.shared.mainQueueManagedObjectContext.object(with: self) as! ObjectType
            
        case .privateQueue:
            return DataController.shared.privateQueueManagedObjectContext.object(with: self) as! ObjectType
        }
    }
}


extension ErrorPerso: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .metaDataTypeInconnu:
            return NSLocalizedString("MetaData type in importer not exist in the enum", comment: "Error perso")
        case .keyInconnue:
            return NSLocalizedString("MetaData key in importer no exist in the enum", comment: "Error perso")
        case .wtf:
            return NSLocalizedString("WTF", comment: "Error perso")
        case .pasDeMainListe:
            return NSLocalizedString("No liste without parent", comment: "Error perso")
        case .multipleMainListe:
            return NSLocalizedString("Multiple liste without parent", comment: "Error perso")
        case .mulitipleMotWithSameUUID:
            return NSLocalizedString("Mulitiple mot with same UUID", comment: "Error perso")
        case .unableToFindTheMot:
            return NSLocalizedString("Unable to find the mot", comment: "Error perso")
        case .readingFileError:
            return NSLocalizedString("Reading file error", comment: "Error perso")
        case .wrongType:
            return NSLocalizedString("Wrong type in imiwa save file", comment: "Error perso")
        }
    }
}



