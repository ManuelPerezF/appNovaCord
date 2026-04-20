//
//  EdTrasladoModel.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 02/12/25.
//

import Foundation

struct TrasladoData: Codable {
    let IdSolicitudAmbulancia: Int
    let IdAmbulancia: Int
    let IdNumeroSocio: Int
    let FechaSolicitud: String
    let HoraSolicitud: String
    let Origen: String
    let Destino: String
    let IdServicio: Int
    let IdMedicoSolicita: Int

    let IdAgendaAmbulancia: Int
    let IdEstatusAgenda: Int
}

struct UpdateTrasladoRequest: Codable {
    var IdAmbulancia: Int
    var IdServicio: Int
    var FechaSolicitud: String
    var HoraSolicitud: String
    var Origen: String
    var Destino: String
    var IdMedicoSolicita: Int
}


