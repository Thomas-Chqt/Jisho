//
//  DebugMenu.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/25.
//

import SwiftUI
import CoreData

struct DebugMenu: View {
    
    @Environment(\.toggleSideMenu) var showSideMenu

    
    @State var nbrMotCloud:Int
    @State var nbrMotLocal:Int
    
    @State var nbrJapCloud:Int
    @State var nbrJapLocal:Int
    
    @State var nbrSenseCloud:Int
    @State var nbrSenseLocal:Int
    
    @State var nbrTradCloud:Int
    @State var nbrTradLocal:Int
    
    @State var nbrModifier:Int
    
    @State var nbrListe:Int
    
    @State var nbrSearchTableHolderMotJMdict:Int
        
    
    init() {
        
        let fetchRequest1:NSFetchRequest<Mot> = Mot.fetchRequest()
        fetchRequest1.includesSubentities = false
        nbrMotCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest1)
        
        let fetchRequest2:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
        fetchRequest2.includesSubentities = false
        nbrMotLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest2)
        
        
        
        let fetchRequest3:NSFetchRequest<Japonais> = Japonais.fetchRequest()
        fetchRequest3.includesSubentities = false
        nbrJapCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest3)
        
        let fetchRequest4:NSFetchRequest<JaponaisJMdict> = JaponaisJMdict.fetchRequest()
        fetchRequest4.includesSubentities = false
        nbrJapLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest4)
        
        
        
        let fetchRequest5:NSFetchRequest<Sense> = Sense.fetchRequest()
        fetchRequest5.includesSubentities = false
        nbrSenseCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest5)
        
        let fetchRequest6:NSFetchRequest<SenseJMdict> = SenseJMdict.fetchRequest()
        fetchRequest6.includesSubentities = false
        nbrSenseLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest6)
        
        
        
        let fetchRequest7:NSFetchRequest<Traduction> = Traduction.fetchRequest()
        fetchRequest7.includesSubentities = false
        nbrTradCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest7)
        
        let fetchRequest8:NSFetchRequest<TraductionJMdict> = TraductionJMdict.fetchRequest()
        fetchRequest8.includesSubentities = false
        nbrTradLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest8)
        
        
        
        let fetchRequest9:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
        fetchRequest9.includesSubentities = false
        nbrModifier = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest9)
        
        
        
        let fetchRequest10:NSFetchRequest<Liste> = Liste.fetchRequest()
        fetchRequest10.includesSubentities = false
        nbrListe = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest10)
        
        
        let fetchRequest11:NSFetchRequest<SearchTableHolderMotJMdict> = SearchTableHolderMotJMdict.fetchRequest()
        fetchRequest11.includesSubentities = false
        nbrSearchTableHolderMotJMdict = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest11)
    }
    
    
    var body: some View {
        List {
            NavigationLink(destination: { DebugActionsView() },
                           label: {Text("Debug Actions")})
            
            NavigationLink(destination: { DebugCloudStorage() },
                           label: { Text("Cloud Storage") })
            
            NavigationLink(destination: {
                DebugPage { (item: MotJMdict) in
                    MotRowView(mot: item)
                        .contextMenu {
                            Button("reset") {
                                item.deleteModifier()
                                Task {
                                    try await DataController.shared.save()
                                }
                            }
                        }
                }
                
            },
                           label: { Text("Mot JMdict (\(nbrMotLocal))") })
            
            NavigationLink(destination: {
                DebugPage { (item: MotModifier) in
                    MotRowView(mot: item)
                        .contextMenu {
                            Button("Delete") {
                                DataController.shared.mainQueueManagedObjectContext.delete(item)
                                Task {
                                    try await DataController.shared.save()
                                }
                            }
                        }
                }
            },
                           label: { Text("Mot modifier (\(nbrModifier))") })
            
            NavigationLink(destination: {
                DebugPage { (item: Liste) in
                    Text("\(item.name ?? "No name") - \(item.ordre)")
                        .contextMenu {
                            Button("Delete") {
                                DataController.shared.mainQueueManagedObjectContext.delete(item)
                                Task {
                                    try await DataController.shared.save()
                                }
                            }
                        }
                }
            },
                           label: { Text("Liste (\(nbrListe))") })
            
            NavigationLink(destination: { DebugSearchTable() },
                           label: { Text("Search Tables (\(nbrSearchTableHolderMotJMdict))") })
            
        }
        .listStyle(.plain)
        .onAppear {
            let fetchRequest1:NSFetchRequest<Mot> = Mot.fetchRequest()
            fetchRequest1.includesSubentities = false
            nbrMotCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest1)
            
            let fetchRequest2:NSFetchRequest<MotJMdict> = MotJMdict.fetchRequest()
            fetchRequest2.includesSubentities = false
            nbrMotLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest2)
            
            
            
            let fetchRequest3:NSFetchRequest<Japonais> = Japonais.fetchRequest()
            fetchRequest3.includesSubentities = false
            nbrJapCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest3)
            
            let fetchRequest4:NSFetchRequest<JaponaisJMdict> = JaponaisJMdict.fetchRequest()
            fetchRequest4.includesSubentities = false
            nbrJapLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest4)
            
            
            
            let fetchRequest5:NSFetchRequest<Sense> = Sense.fetchRequest()
            fetchRequest5.includesSubentities = false
            nbrSenseCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest5)
            
            let fetchRequest6:NSFetchRequest<SenseJMdict> = SenseJMdict.fetchRequest()
            fetchRequest6.includesSubentities = false
            nbrSenseLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest6)
            
            
            
            let fetchRequest7:NSFetchRequest<Traduction> = Traduction.fetchRequest()
            fetchRequest7.includesSubentities = false
            nbrTradCloud = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest7)
            
            let fetchRequest8:NSFetchRequest<TraductionJMdict> = TraductionJMdict.fetchRequest()
            fetchRequest8.includesSubentities = false
            nbrTradLocal = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest8)
            
            
            
            let fetchRequest9:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
            fetchRequest9.includesSubentities = false
            nbrModifier = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest9)
            
            
            
            let fetchRequest10:NSFetchRequest<Liste> = Liste.fetchRequest()
            fetchRequest10.includesSubentities = false
            nbrListe = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest10)
            
            let fetchRequest11:NSFetchRequest<SearchTableHolderMotJMdict> = SearchTableHolderMotJMdict.fetchRequest()
            fetchRequest11.includesSubentities = false
            nbrSearchTableHolderMotJMdict = try! DataController.shared.mainQueueManagedObjectContext.count(for: fetchRequest11)
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

struct DebugMenu_Previews: PreviewProvider {
    static var previews: some View {
        DebugMenu()
    }
}
