//
//  SideMenuButtonView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/28.
//

import SwiftUI

struct SideMenuButtonView: View {
    
    var icone:Image
    var text:String
    var action: () -> Void
    
    
    var body: some View {
        
        Button {
            
            action()
            
        } label: {
            HStack {
                icone.padding(.leading).scaleEffect(1.5)
                Text(text).font(.title).padding(.leading, 10)
                Spacer()
            }
            .frame(width: 250, height: 45)
            .background(.background)
        }
        .buttonStyle(.plain)
        .background(.background)
    }
}

struct SideMenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(.black.opacity(0.2)).ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                SideMenuButtonView(icone: Image(systemName: "magnifyingglass"), text: "Recherche") {
                    
                }
                
                Divider().frame(width: 250)
                
                SideMenuButtonView(icone: Image(systemName: "gearshape"), text: "Paramètres") {
                    
                }
            }
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.primary.opacity(0.5), lineWidth: 1))
            .offset(x: 10, y: 10)
        }
        .previewDevice("iPhone X")
    }
}
