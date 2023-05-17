//
//  CardView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 07/05/23.
//

import SwiftUI

struct CardView: View {
    
    let gameModel: GameModel
    let firebaseViewModel = FirebaseViewModel()
    
    var body: some View {
        VStack(spacing: 8) {
            ImageFirebaseView(urlImage: gameModel.cover)
            HStack {
                Spacer()
            }
            Text(gameModel.title)
                .font(.title)
                .fontWeight(.bold)
            Text(gameModel.description)
                .multilineTextAlignment(.center)
                .padding(.bottom)
        }
        .padding()
        .background(Color.white) // Color de fondo
        .cornerRadius(10) // Bordes redondeados
        .shadow(radius: 2)
        .padding()
        .contextMenu {
            NavigationLink {
                AddView(gameModel: gameModel)
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            Button {
                firebaseViewModel.delete(index: gameModel)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(gameModel: GameModel(uid: "000000", title: "Title", description: "Description", platform: "nintendo", cover: "gs://flutter-test-c3743.appspot.com/covers/DB9B84AC-BD9A-4A55-A9CF-0C4F377BDCE3", emailUser: "email@test.com", idUser: "1289432"))
    }
}
