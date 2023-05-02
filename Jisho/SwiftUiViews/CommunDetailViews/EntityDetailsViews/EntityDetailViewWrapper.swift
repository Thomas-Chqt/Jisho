//
//  EntityDetailViewWrapper.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/04/28.
//

import SwiftUI

struct EntityDetailViewWrapper: View {
	
	@ObservedObject var entity: Entity
	
    var body: some View {
		if let mot = entity as? Mot {
			MotDetailView(mot)
		}
		else if let japonais = entity as? Japonais {
			List {
				JaponaisDetailsView(japonais)
			}
		}
		else if let sense = entity as? Sense {
			List {
				SenseDetailView(sense)
			}
		}
		else if let metaData = entity as? MetaData {
			List {
				MetaDataDetailView(metaData)
			}
		}
		else if let tranduction = entity as? Traduction {
			List {
				TraductionDetailView(tranduction)
			}
		}
    }
}

struct EntityDetailViewWrapper_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			EntityDetailViewWrapper(entity: Mot(.preview))
		}
		.environment(\.managedObjectContext, DataController.shared.mainQueueManagedObjectContext)
		.environmentObject(Settings.shared)
    }
}
