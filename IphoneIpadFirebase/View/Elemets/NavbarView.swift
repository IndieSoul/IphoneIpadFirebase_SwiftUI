//
//  NavbarView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 07/05/23.
//

import SwiftUI

struct NavbarView: View {
    @Binding var index: String
    @Binding var menu: Bool
    
    var device = UIDevice.current.userInterfaceIdiom
    var body: some View {
        HStack {
            Text("My Games")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            if device == .pad {
                HStack {
                    ButtonView(index: $index, menu: $menu, title: "Nintendo")
                    ButtonView(index: $index, menu: $menu, title: "PlayStation")
                        .padding(.horizontal)
                    ButtonView(index: $index, menu: $menu, title: "Xbox")
                    ButtonAddView()
                        .padding(.leading)
                    ButtonLogoutView()
                        .padding(.leading)
                }
            } else {
                Button {
                    withAnimation {
                        menu.toggle()
                    }
                } label: {
                    if menu {
                        Image(systemName: "xmark")
                    } else {
                        Image(systemName: "line.horizontal.3")
                    }
                }
            }
        }
        .padding()
    }
}

struct NavbarView_Previews: PreviewProvider {
    static var previews: some View {
        let myText = Binding.constant("Hola")
        let myBool = Binding.constant(true)
        NavbarView(index: myText, menu: myBool)
    }
}
