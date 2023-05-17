//
//  ButtonAddView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 09/05/23.
//

import SwiftUI

struct ButtonAddView: View {
    var body: some View {
        NavigationLink(destination: AddView(gameModel: nil)) {
            HStack {
                Image(systemName: "plus")
                Text("Add Game")
            }
            .foregroundColor(.blue)
        }
    }
}

struct ButtonAddView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonAddView()
    }
}
