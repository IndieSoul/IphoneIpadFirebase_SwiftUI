//
//  GameModel.swift
//  IphoneIpadFirebase
//
//  Created by Luis Enrique Rosas Espinoza on 10/05/23.
//

import Foundation

struct GameModel: Codable  {
    var uid: String
    var title: String
    var description: String
    var platform: String
    var cover: String
    var emailUser: String
    var idUser: String
}
