//
//  ContentView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 07/05/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        Group {
            if firebaseViewModel.show {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            if let isLogin = UserDefaults.standard.object(forKey: "isLogin") as? Bool {
                if isLogin {
                    firebaseViewModel.show = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(FirebaseViewModel())
    }
}
