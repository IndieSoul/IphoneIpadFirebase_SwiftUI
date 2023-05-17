//
//  ButtonView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 07/05/23.
//

import SwiftUI

struct ButtonView: View {
    @Binding var index: String
    @Binding var menu: Bool
    
    var title: String
    
    var body: some View {
        Button {
            withAnimation {
                index = title
            }
        } label: {
            Text(title)
                .font(.title)
                .fontWeight(index == title ? .bold : .light)
        }
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        let myText = Binding.constant("test")
        let myBool = Binding.constant(true)
        ButtonView(index: myText, menu: myBool, title: "Hola")
    }
}
