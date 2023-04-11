//
//  EditSheet.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/11.
//

import Foundation
import SwiftUI


struct EditSheet: ViewModifier {
	
	@Binding var isPresented: Bool
	var entity: Entity
	
	func body(content: Content) -> some View {
		content
			.sheet(isPresented: $isPresented, onDismiss: { DataController.shared.save() }) {
				if let mot = entity as? Mot {
					MotEditSheetView(mot)
				}
				else if let japonais = entity as? Japonais {
					NavigationStack {
						JaponaisEditSheetView(japonais)
					}
				}
				else if let sense = entity as? Sense {
					NavigationStack {
						SenseEditSheetView(sense)
					}
				}
				else if let traduction = entity as? Traduction {
					NavigationStack {
						TraductionEditSheetView(traduction: traduction)
					}
				}
				else {
					Text("Error, no edit view")
				}
		}
	}
}

extension View {
	func editSheet(isPresented: Binding<Bool>, entityToEdit: Entity) -> some View {
		self.modifier(EditSheet(isPresented: isPresented, entity: entityToEdit))
	}
}

struct EditSheet_Previews: PreviewProvider {
	static var previews: some View {
		WrappedView()
	}
	
	struct WrappedView: View {
		
		@State var isShow: Bool = false
		var entity = Mot(.preview)
		
		var body: some View {
			Button("Show sheet") {
				isShow.toggle()
			}
			.editSheet(isPresented: $isShow, entityToEdit: entity)
		}
	}
}


