//
//  ListGamesView.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 15/05/23.
//

import SwiftUI

struct ListGamesView: View {
    var device = UIDevice.current.userInterfaceIdiom
    @Environment(\.horizontalSizeClass) var width
    
    @EnvironmentObject var firebaseViewModel: FirebaseViewModel
    
    let platform: String
    
    func getColums() -> Int {
        return (device == .pad) ? 3 : ((device == .phone && width == .regular) ? 3 : 1)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: getColums())) {
                ForEach(firebaseViewModel.gameModels, id:\.uid) { item in
                    CardView(gameModel: item)
                }
            }
        }
        .onAppear {
            firebaseViewModel.getGames(platform: platform) { error in
                print(error ?? "")
            }
        }
    }
}

struct ListGamesView_Previews: PreviewProvider {
    static var previews: some View {
        ListGamesView(platform: "nintendo")
            .environmentObject(FirebaseViewModel())
    }
}
