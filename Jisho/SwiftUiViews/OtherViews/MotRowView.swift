//
//  MotRowView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/05/06.
//

import SwiftUI

struct MotRowView: View {
	
	@ObservedObject var mot: Mot
	
    var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(alignment: .bottom, spacing: 0) {
				kanji
				kana
			}
			traduction
		}
		.frame(height: 55)
    }
	
	
	@ViewBuilder
	var kanji: some View {
		if let kanji = mot.primary {
			Text(kanji).font(mot.details != nil ? .title : .largeTitle)
		}
	}
	
	@ViewBuilder
	var kana: some View {
		if let kana = mot.secondary {
			if mot.primary != nil {
				Text("「\(kana)」")
			}
			else {
				Text(kana).font(mot.details != nil ? .title : .largeTitle)
			}
		}
	}
	
	@ViewBuilder
	var traduction: some View {
		if let traduction = mot.details {
			Text(traduction).font(mot.primary != nil || mot.secondary != nil ? .body : .title)
		}
	}
}

struct MotRowView_Previews: PreviewProvider {
    static var previews: some View {
        WrappedView()
			.environmentObject(Settings.shared)
    }
	
	struct WrappedView: View {
		
		@State var selection: Mot?
		
		static var motPerso: Mot {
			let mot = Mot(.empty)
			mot.japonais = [Japonais(kanas: ["ねこ"])]
			
			return mot
		}
		
		static var motPerso2: Mot {
			let mot = Mot(.empty)
			mot.japonais = [Japonais(kanjis: ["猫"])]
			
			return mot
		}
		
		static var motPerso3: Mot {
			let mot = Mot(.empty)
			mot.japonais = [Japonais(kanas: ["ねこ"])]
			mot.senses.append(Sense(traductions: [Traduction(langue: .francais, text: "Traduction")]))
			
			return mot
		}
		
		static var motPerso4: Mot {
			let mot = Mot(.empty)
			mot.japonais = [Japonais(kanjis: ["猫"])]
			mot.senses.append(Sense(traductions: [Traduction(langue: .francais, text: "Traduction")]))
			
			return mot
		}
		
		static var motPerso5: Mot {
			let mot = Mot(.empty)
			
			mot.senses.append(Sense(traductions: [Traduction(langue: .francais, text: "Traduction")]))
			
			return mot
		}
		
		static var motPerso6: Mot {
			let mot = Mot(.preview)
			
			mot.japonais.first?.kanjis[0] = "猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫猫"
			mot.japonais.first?.kanas[0] = "ねこねこねこねこねこねこねこねこねこねこねこねこねこねこねこねこねこねこねこねこ"
			mot.senses.first?.traductions.firstMatch()?.text = "ababababababababababababababababababababababababababaabababababa"

			return mot
		}
		
		let mots = [Mot(.preview), Mot(.preview), motPerso, motPerso2, motPerso3, motPerso4, motPerso5, motPerso6]
		
		var body: some View {
			NavigationSplitView {
				NavigationStack {
					List(selection: $selection) {
						ForEach(mots){ mot in
							MotRowView(mot: mot)
						}
					}
					.listStyle(.plain)
				}
				.navigationTitle("Preview")
			} detail: {
				selection?.view
			}
		}
	}
}
