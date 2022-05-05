//
//  SearchPageView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/02/18.
//

import SwiftUI
import CoreData

@MainActor
fileprivate class SearchPageViewModel: ObservableObject {
    
    @PublishedCloudStorage("searchHistory") var searchHistory:[String] = []
    
    @Published private var searchResultObjID: (exactMatch: [NSManagedObjectID], nonExactMatch: [NSManagedObjectID])?
                                                = (exactMatch: [], nonExactMatch: [])
    @Published var showSuggestions = true
    @Published var textFieldText:String = ""

    
    
    init() {
        _searchHistory.objectWillChange = self.objectWillChange.send
    }
    
    
    
    var searchResult: (exactMatch: [Mot], nonExactMatch: [Mot])? {
        guard let searchResultObjID = searchResultObjID else { return nil }

        return (exactMatch: searchResultObjID.exactMatch.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot },
                nonExactMatch: searchResultObjID.nonExactMatch.map { DataController.shared.mainQueueManagedObjectContext.object(with: $0) as! Mot })
    }
    
    var suggestions: some View {
        ForEach(searchHistory) { keyword in
            Text(keyword)
                .searchCompletion(keyword)
                .foregroundColor(.primary)
                .transition(.opacity.animation(.default))
        }
    }
    
    var exactMatchResultsList: some View {
        Section(searchResult?.exactMatch.count ?? 0 > 1 ? "Exact Matchs" : "Exact Match") {
            ForEach(searchResult?.exactMatch ?? []) { mot in
                NavigationLink(destination: MotDetailsView(mot: mot)) {
                    MotRowView(mot: mot)
                }
            }
        }
    }
    
    var nonExactMatchResultsList: some View {
        Section(searchResult?.nonExactMatch.count ?? 0 > 1 ? "Autres" : "Autre") {
            ForEach(searchResult?.nonExactMatch ?? []) { mot in
                NavigationLink(destination: MotDetailsView(mot: mot)) {
                    MotRowView(mot: mot)
                }
            }
        }
    }
    
    
    func submitSearch() {
        
        if let existingIndex = searchHistory.firstIndex(of: textFieldText) { searchHistory.remove(at: existingIndex) }
        searchHistory.insert(textFieldText, at: 0)
        if searchHistory.count > 100 { searchHistory.remove(at: searchHistory.endIndex - 1 )}
        
        searchResultObjID = nil
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        Task {
            searchResultObjID = try await quickSearch(textFieldText)
        }
    }
    
    /*
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
    */
    
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

    @StateObject private var vm:SearchPageViewModel
        
    init() {
        _vm = StateObject(wrappedValue: SearchPageViewModel())
    }
    
    var body: some View
    {
        Group {
            if let searchResult = vm.searchResult {
                List {
                    if !searchResult.exactMatch.isEmpty {
                        vm.exactMatchResultsList
                            .onAppear{vm.showSuggestions = false}
                    }
                    if !searchResult.nonExactMatch.isEmpty {
                        vm.nonExactMatchResultsList
                            .onAppear{vm.showSuggestions = false}
                    }
                }
            }
            else {
                ProgressView()
                    .onAppear{vm.showSuggestions = false}
            }
        }
        .searchable(text: $vm.textFieldText, placement: .navigationBarDrawer(displayMode: .always)) {
            if vm.showSuggestions { vm.suggestions }
        }
        
        .onSubmit(of: .search) { vm.submitSearch() }
    
        .onChange(of: vm.textFieldText) { _ in vm.showSuggestions = true }
        
        .navigationTitle("Recherche")
        .listStyle(.inset)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                showSideMenuButton
            }
        }
    }
    
    
    var showSideMenuButton: some View {
        Button {
            showSideMenu()
        } label: {
            Image(systemName: "list.bullet")
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
