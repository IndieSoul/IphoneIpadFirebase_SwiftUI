//
//  FirebaseViewModel.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 09/05/23.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseViewModel: ObservableObject {
    @Published var show = false
    @Published var gameModels: [GameModel] = []
    
    func login(email: String, password: String, completer: @escaping (_ done: Bool, _ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error in firebase", error.localizedDescription)
                completer(false, error.localizedDescription)
            } else {
                print("Login Complete!")
                completer(true, nil)
            }
        }
    }
    
    func createUser(email: String, password: String, completer: @escaping (_ done: Bool, _ error: String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Error in firebase", error.localizedDescription)
                completer(false, error.localizedDescription)
            } else {
                print("Register Complete!")
                completer(true, nil)
            }
        }
    }
    
    func saveData(
        title: String,
        description: String,
        platform: String,
        cover: Data,
        completer: @escaping (_ error: String?) -> Void)
    {
        let storage = Storage.storage().reference()
        let nameCover = UUID().uuidString
        let directory = storage.child("covers/\(nameCover)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directory.putData(cover, metadata: metadata) { data, error in
            if error == nil {
                let db = Firestore.firestore()

                guard let idUser = Auth.auth().currentUser?.uid else { return }
                guard let emailUser = Auth.auth().currentUser?.email else { return }

                let mapData: [String: Any] = [
                    "uid": nameCover,
                    "title": title,
                    "description": description,
                    "platform": platform,
                    "cover": String(describing: directory),
                    "idUser": idUser,
                    "emailUser": emailUser
                ]

                db.collection("games").document(nameCover).setData(mapData) { error in
                    if let error = error?.localizedDescription {
                        completer(error)
                    } else {
                        completer(nil)
                    }
                }
            } else {
                if let error = error?.localizedDescription {
                    completer(error)
                } else {
                    completer(nil)
                }
            }
            
        }
    }
    
    func getGames(platform: String, completer: @escaping (_ error: String?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("games").whereField("platform", isEqualTo: platform).addSnapshotListener { QuerySnapshot, error in
            if let error = error?.localizedDescription {
                completer(error)
            } else {
                self.gameModels.removeAll()
                for document in QuerySnapshot!.documents {
                    let data = document.data()
                    
                    DispatchQueue.main.async {
                        self.gameModels.append(GameModel(
                            uid: data["uid"] as? String ?? "",
                            title: data["title"] as? String ?? "",
                            description: data["description"] as? String ?? "",
                            platform: data["platform"] as? String ?? "",
                            cover: data["cover"] as? String ?? "",
                            emailUser: data["emailUser"] as? String ?? "",
                            idUser: data["idUser"] as? String ?? ""
                        ))
                    }
                    
                }
            }
        }
        
    }
    
    func delete(index: GameModel) {
        let id = index.uid
        let db = Firestore.firestore()
        
        db.collection("games").document(id).delete()
        
        let image = index.cover
        let deleteImage = Storage.storage().reference(forURL: image)
        deleteImage.delete(completion: nil)
    }
    
    func edit(index: GameModel, cover: Data, completer: @escaping (_ error: String?) -> Void) {
        let db = Firestore.firestore()
        
        let storage = Storage.storage().reference()
        let nameCover = index.uid
        let directory = storage.child("covers/\(nameCover)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        
        directory.putData(cover, metadata: metadata) { data, error in
            if error != nil {
                completer(error?.localizedDescription)
            } else {
                do {
                    let jsonData = try JSONEncoder().encode(index)
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [AnyHashable: Any] {
                        db.collection("games").document(index.uid).updateData(jsonObject) { error in
                            if error != nil {
                                completer(error!.localizedDescription)
                            }
                            completer("Update complete.")
                        }
                    }
                } catch {
                    completer(error.localizedDescription)
                }
            }
        }
        
        
    }
    
}
