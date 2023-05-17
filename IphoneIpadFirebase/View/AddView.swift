//
//  AddView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 09/05/23.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct AddView: View {
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    @State private var title = ""
    @State private var description = ""
    
    @State private var platform = "nintendo"
    
    @State private var isLoading = false
    
    @State private var showAlert = false
    @State private var titleMessage = ""
    @State private var alertMessage = ""
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    @State var gameModel: GameModel?
    
    var consols = ["nintendo", "playstation", "xbox"]
    var device = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        VStack {
            Text(gameModel == nil ? "Add Game" : "Edit Game")
                .font(.title)
                .fontWeight(.bold)
            Spacer ()
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 250, height: 250)
                    
            }
            if selectedImageData == nil {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Text("Select Cover")
            }
            .padding(.vertical)
            .onChange(of: selectedItem) { newItem in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
            VStack(alignment: .leading) {
                Text("Title:")
                TextField("Title game", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Description:")
                    .padding(.top)
                TextField("Description game", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                HStack {
                    Spacer()
                    Picker("Platform", selection: $platform) {
                        ForEach(consols, id: \.self) { item in
                            Text(item.capitalized)
                        }
                    }
                    Spacer()
                }
                .padding(.top)
            }
            .frame(width: device == .pad ? 400 : nil)
            .padding()
            
            Button("Save") {
                if title.isEmpty && description.isEmpty && selectedImageData == nil {
                    titleMessage = "Complete the information"
                    alertMessage = "No field should be empty."
                    showAlert = true
                    return
                }
                
                isLoading = true
                
                if gameModel == nil {
                    
                    firebaseViewModel.saveData(title: title, description: description, platform: platform, cover: selectedImageData!) { error in
                        if error == nil {
                            titleMessage = "Data Saved"
                            alertMessage = "The game has been added to your collection."
                            isLoading = false
                            showAlert = true
                            return
                        } else {
                            alertMessage = error!
                            isLoading = false
                            showAlert = true
                            return
                        }
                    }
                    
                } else {
                    gameModel!.title = title
                    gameModel!.description = description
                    gameModel!.platform = platform
                    
                    firebaseViewModel.edit(index: gameModel!, cover: selectedImageData!) { error in
                        if error == nil {
                            titleMessage = "Data Saved"
                            alertMessage = "The game has been added to your collection."
                            isLoading = false
                            showAlert = true
                            return
                        } else {
                            alertMessage = error!
                            isLoading = false
                            showAlert = true
                            return
                        }
                    }
                }
                
            }
            .padding(.vertical)
            .disabled(isLoading)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(titleMessage),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Spacer()
        }
        .onAppear {
            if gameModel != nil {
                self.title = gameModel!.title
                self.description = gameModel!.description
                self.platform = gameModel!.platform
                
                let storage = Storage.storage()
                let storageRef = storage.reference(forURL: gameModel!.cover)
                
                storageRef.getData(maxSize: 10 * 1024 * 1024) { [self] data, error in
                    if let error = error {
                        print("Ocurrió un error: \(error)")
                    } else {
                        self.selectedImageData = data!
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(gameModel: nil)
            .environmentObject(FirebaseViewModel())
    }
}
