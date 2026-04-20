//
//  operadorModel.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 25/11/25.
//

import Foundation

struct Operador: Codable, Identifiable {
    var id: Int
    var nombre: String
    var status: String
    var asignados: Int
    var completados: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "IdPersonal"
        case nombre = "Nombre"
        case status = "EstatusPersonal"
        case asignados = "TrasladosAsignados"
        case completados = "TrasladosCompletados"
        
    }
}
