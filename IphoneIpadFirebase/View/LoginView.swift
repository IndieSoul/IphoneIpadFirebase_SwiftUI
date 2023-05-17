//
//  LoginView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 09/05/23.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    @State private var isLoading = false
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            VStack(alignment: .leading) {
                Text("Email:")
                TextField("Your email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                Text("Password:")
                SecureField("Your password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .frame(width: device == .pad ? 400 : nil)
            VStack {
                Button("Login") {
                    if !email.isEmpty && !password.isEmpty {
                        isLoading = true
                        firebaseViewModel.login(email: email, password: password) { done, error in
                            if done {
                                UserDefaults.standard.set(true, forKey: "isLogin")
                                firebaseViewModel.show.toggle()
                                isLoading = false
                                return
                            } else {
                                errorMessage = error!
                                showAlert = true
                                isLoading = false
                                return
                            }
                        }
                    } else {
                        errorMessage = "All fields must have information."
                        showAlert = true
                    }
                }
                .disabled(isLoading)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                
                Button("Register") {
                    if !email.isEmpty && !password.isEmpty {
                        isLoading = true
                        firebaseViewModel.createUser(email: email, password: password) { done, error in
                            if done {
                                UserDefaults.standard.set(true, forKey: "isLogin")
                                firebaseViewModel.show.toggle()
                                isLoading = false
                                return
                            } else {
                                errorMessage = error!
                                showAlert = true
                                isLoading = false
                                return
                            }
                        }
                    } else {
                        errorMessage = "All fields must have information."
                        showAlert = true
                    }
                }
                .disabled(isLoading)
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Error"),
                        message: Text(errorMessage),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.top)
            }
            .padding(.top, 32)
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(FirebaseViewModel())
    }
}
