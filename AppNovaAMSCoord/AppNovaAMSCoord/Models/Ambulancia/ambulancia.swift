//
//  ambulancia.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 06/11/25.
//

import Foundation

struct Ambulancia: Codable,Identifiable {
    var id: Int
    var type: String
    var status: String
    var km: Int
  

    enum CodingKeys: String, CodingKey {
        case id = "IdAmbulancia"
        case type = "TipoAmbulancia"
        case status = "EstatusAmbulancia"
        case km = "KmActual"
    }
}

