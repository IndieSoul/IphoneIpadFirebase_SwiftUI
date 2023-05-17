//
//  HomeView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 07/05/23.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State private var index = "Nintendo"
    @State private var menu = false
    
    var body: some View {
        NavigationStack {
            VStack {
                NavbarView(index: $index, menu: $menu)
                if menu {
                    HStack {
                        Spacer()
                        VStack {
                            ButtonView(index: $index, menu: $menu, title: "Nintendo")
                            ButtonView(index: $index, menu: $menu, title: "PlayStation")
                                .padding(.vertical)
                            ButtonView(index: $index, menu: $menu, title: "Xbox")
                                .padding(.top)
                            ButtonAddView()
                                .padding(.top)
                            ButtonLogoutView()
                                .padding(.top)
                        }
                        .padding()
                        Spacer()
                    }
                    .background(.gray.opacity(0.2))
                }
                switch index {
                case "Nintendo":
                    ListGamesView(platform: "nintendo")
                case "PlayStation":
                    ListGamesView(platform: "playstation")
                case "Xbox":
                    ListGamesView(platform: "xbox")
                default:
                    ListGamesView(platform: "nintendo")
                }
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
