//
//  ImageFirebaseView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 16/05/23.
//

import SwiftUI
import FirebaseStorage

struct ImageFirebaseView: View {
    let urlImage: String
    
    init(urlImage: String) {
        self.urlImage = urlImage
    }
    
    @State private var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            } else {
                ProgressView()
            }
        }
        .onAppear {
            downloadImageFromFirebase()
        }
    }

    func downloadImageFromFirebase() {
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: urlImage)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Ocurrió un error: \(error)")
            } else {
                self.image = UIImage(data: data!)
            }
        }
    }
}
