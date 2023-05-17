//
//  ButtonLogoutView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 09/05/23.
//

import SwiftUI
import Firebase

struct ButtonLogoutView: View {
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    var body: some View {
        Button("Logout") {
            try! Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLogin")
            firebaseViewModel.show = false
        }
    }
}

struct ButtonLogoutView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonLogoutView()
            .environmentObject(FirebaseViewModel())
    }
}
