//
//  ListeRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/04.
//

import SwiftUI

struct ListeRowView: View {
	@ObservedObject var liste: Liste
	@Binding var editedListe: UUID?
	
	@FocusState var isFocused: Bool
	
    var body: some View {
		if editedListe == liste.id {
			TextField("Nom", text: $liste.name)
				.focused($isFocused)
				.onAppear { isFocused = true }
				.onSubmit { editedListe = nil; DataController.shared.save() }
		}
		else {
			NavigationLink("\(liste.name) (\(liste.parent?.name ?? "nil"))", value: liste)
				.contextMenu {
					Button("Modifier") {
						editedListe = liste.id
					}
				}
				.onDrag(allowMulitpleSelection: false) { NSItemProvider(object: liste) }
		}
    }
}




struct ListeRowView_Previews: PreviewProvider {
    static var previews: some View {
		WrappedView()
    }
	
	struct WrappedView: View {
		
		@State private var editedListe: UUID? = nil
		
		var body: some View {
			NavigationSplitView {
				NavigationStack {
					List {
						ListeRowView(liste: Liste(.preview), editedListe: $editedListe)
					}
					.listStyle(.plain)
				}
				.navigationTitle(AppPages.listes.fullName)
				.showSideMenuButton()
				.addButton { }
			} detail: {
				
			}
		}
	}
}
