//
//  TrasladosAPI.swift
//  AppNovaAMSOp
//
//  Created by Alumno on 13/11/25.
//

import Foundation

struct TrasladoAPI: Identifiable, Codable {
    let id: Int
    let nombrePaciente: String
    let hora: String
    let origen: String
    let destino: String
    let codigoAmbulancia: String
    let estatus: String
    let tipoViaje: String

    enum CodingKeys: String, CodingKey {
        case id = "IdAgendaAmbulancia"
        case nombrePaciente = "NombrePaciente"
        case hora = "Hora"
        case origen = "Origen"
        case destino = "Destino"
        case codigoAmbulancia = "CodigoAmbulancia"
        case estatus = "Estatus"
        case tipoViaje = "TipoViaje"
    }
}

