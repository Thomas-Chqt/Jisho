//
//  SearchPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/18.
//

import SwiftUI
import CoreData

fileprivate class SearchPageViewModel: ObservableObject {
    
    func realSearch(_ recherche:String) async throws -> [NSManagedObjectID] {

        try await DataController.shared.privateQueueManagedObjectContext.perform {
            print("")
            let depart = Date()
            
            
            //recuperation de tout les modifieur
            let fetchRequestAllMotModifier:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
            fetchRequestAllMotModifier.includesSubentities = false
            let allMotModifier = try DataController.shared.privateQueueManagedObjectContext.fetch(fetchRequestAllMotModifier)
            
            print("Tout les modifieur recup : \( depart.distance(to: Date()) )s")
            let tempAllModifier = Date()
            
            
            
            
            //recherche des modifieur qui correspondent a la recherche
            let fetchRequestSearchedMotModifier:NSFetchRequest<MotModifier> = MotModifier.fetchRequest(recherche: recherche)
            let searchedMotModifier:[MotModifier] =
            try DataController.shared.privateQueueManagedObjectContext.fetch(fetchRequestSearchedMotModifier)
            
            print("Modifieur qui correspondent a la recherche recup : \( tempAllModifier.distance(to: Date()) )s")
            let tempModifierSearched = Date()
            
            
            
            //recherche des motJMdict
            let fetchRequestMotJMdict:NSFetchRequest<NSManagedObjectID> =
            MotJMdict.fetchRequest(recherche: recherche,
                                   allModifiedMotObjIDs: allMotModifier.map { $0.modifiedMotObjID },
                                   searchedModifiedMotObjIDs: searchedMotModifier.map { $0.modifiedMotObjID })
            
                        
            let findedMotJMdict:[NSManagedObjectID] = try DataController.shared.privateQueueManagedObjectContext.fetch(fetchRequestMotJMdict)
            
            print("Recherche JMDict : \( tempModifierSearched.distance(to: Date()) )s")
            let tempJMdictSearched = Date()
            
            
            
            // recherche des Mot
            let fetchRequestMotPerso:NSFetchRequest<NSManagedObjectID> = Mot.fetchRequest(recherche: recherche)
            
            let findedMotPerso:[NSManagedObjectID] = try DataController.shared.privateQueueManagedObjectContext.fetch(fetchRequestMotPerso)
            print("Recherche Perso : \( tempJMdictSearched.distance(to: Date()) )s")
            
            
            print("Total : \( depart.distance(to: Date()) )s \n")
                        
            return findedMotPerso + findedMotJMdict
        }
    }
    
    func quickSearch(_ recherche:String) async throws -> (exactMatch: [NSManagedObjectID], nonExactMatch: [NSManagedObjectID]) {
        
        try await DataController.shared.privateQueueManagedObjectContext.perform {
            
            print("")
            let depart = Date()
            
            //recuperation de tout les modifieur
            let fetchRequestAllMotModifier:NSFetchRequest<MotModifier> = MotModifier.fetchRequest()
            fetchRequestAllMotModifier.includesSubentities = false
            let allMotModifier = try DataController.shared.privateQueueManagedObjectContext.fetch(fetchRequestAllMotModifier)
            let allModifiedMotJMDictObjID = allMotModifier.map { $0.modifiedMotObjID }
            print("Tout les modifieur recup : \( depart.distance(to: Date()) )s")
            
            
            //recherche des modifieur qui correspondent a la recherche
            let a = Date()
            let fetchRequestSearchedMotModifier:NSFetchRequest<MotModifier> = MotModifier.fetchRequest(recherche: recherche)
            let searchedMotModifier:[MotModifier] =
            try DataController.shared.privateQueueManagedObjectContext.fetch(fetchRequestSearchedMotModifier)
            let searchedModifiedMotJMdictObjID = searchedMotModifier.map { $0.modifiedMotObjID }
            print("Modifieur qui correspondent a la recherche recup : \( a.distance(to: Date()) )s")

            
            let b = Date()
            var hash = recherche.hash
            if hash < 0 { hash *= -1 }
            let id = hash % 1000
            
            let allSearchedMotJMdict = DataController.shared.getSearchtableMotJMdict(id: id)[recherche] ?? []
            print("Mot JMdict : \( b.distance(to: Date()) )s")

            
            let c = Date()
            let searchedNonModifiedMotJMdict = allSearchedMotJMdict.filter { !allModifiedMotJMDictObjID.contains($0) }
            
            var nonExactMatch = searchedModifiedMotJMdictObjID + searchedNonModifiedMotJMdict
            var exactMach:[NSManagedObjectID] = []
    
            
            for ObjId in nonExactMatch {
                let mot = DataController.shared.privateQueueManagedObjectContext.object(with: ObjId) as! Mot
                
                if mot.getExactMatchKeyWords().contains(recherche)  {
                    exactMach.append(nonExactMatch.remove(at: nonExactMatch.firstIndex(of: ObjId)!))
                }
            }
            
            print("Tri : \( c.distance(to: Date()) )s")

            
            print("Total : \( depart.distance(to: Date()) )s")

            return (exactMatch: exactMach, nonExactMatch: nonExactMatch)
        }
    }
     
}


struct SearchPageView: View
{
    @Environment(\.toggleSideMenu) var showSideMenu

    @StateObject private var vm = SearchPageViewModel()
    
    @CloudStorage("searchHistory") var searchHistory:[String] = []
    @State private var showSuggestions = true
    
    @State var textFieldText:String = ""
    
    @State var searchResult: (exactMatch: [Mot], nonExactMatch: [Mot])? = (exactMatch: [], nonExactMatch: [])
    
    
    var body: some View
    {
        Group {
            if let searchResult = searchResult {
                List {
                    if !searchResult.exactMatch.isEmpty {
                        Section(searchResult.exactMatch.count > 1 ? "Exact Matchs" : "Exact Match") {
                            ForEach(searchResult.exactMatch) { mot in
                                NavigationLink(destination: MotDetailsView(mot)) {
                                    MotRowView(mot: mot)
                                }
                            }
                        }
                    }
                    if !searchResult.nonExactMatch.isEmpty {
                        Section("Autres") {
                            ForEach(searchResult.nonExactMatch) { mot in
                                NavigationLink(destination: MotDetailsView(mot)) {
                                    MotRowView(mot: mot)
                                }
                            }
                        }
                    }
                }
                .transition(.opacity.animation(.default))
            }
            else {
                ProgressView()
                    .transition(.opacity.animation(.default))
            }
        }
        .searchable(text: $textFieldText,placement: .navigationBarDrawer(displayMode: .always), suggestions: {
            if showSuggestions {
                ForEach(searchHistory.reversed()) { keyword in
                    withAnimation {
                        Text(keyword)
                            .searchCompletion(keyword)
                            .foregroundColor(.primary)
                            .transition(.opacity.animation(.default))
                    }
                }
            }
        })
        .onSubmit(of: .search) {
            
            if let existingIndex = searchHistory.firstIndex(of: textFieldText) {
                searchHistory.remove(at: existingIndex)
            }
            
            self.searchHistory.append(textFieldText)
            
            if searchHistory.count >= 100 { searchHistory.remove(at: 0) }
            
            
            Task {
                withAnimation {
                    self.searchResult = nil
                    self.showSuggestions = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                let motsObjectIDs = try await vm.quickSearch(textFieldText)
                
                withAnimation {
                    self.searchResult =
                    (exactMatch: motsObjectIDs.exactMatch.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot },
                    nonExactMatch: motsObjectIDs.nonExactMatch.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot })
                }
            }
        }
        .onChange(of: textFieldText) { _ in
            withAnimation{
                showSuggestions = true
            }
        }
        
        .navigationTitle("Recherche")
        .listStyle(.inset)
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

/*
fileprivate struct SearchResultView: View {
    @Environment(\.dismissSearch) var dismissSearch
    
    var motsObjectIDs: (exactMatch: [NSManagedObjectID], nonExactMatch: [NSManagedObjectID])?
    
    var body: some View {
        
        Group {
            if let motsObjectIDs = motsObjectIDs {
                List {
                    MotListView(motsObjectIDs: motsObjectIDs)
                        .onAppear { dismissSearch() }
                }
            }
            else {
                Spacer()
                ProgressView()
                    .onAppear { dismissSearch() }
                Spacer()
            }
        }
    }
}
*/
