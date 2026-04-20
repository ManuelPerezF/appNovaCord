//
//  AgTraslado.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 25/11/25.
//

import Foundation

struct TrasladoPost: Codable {
    var IdAmbulancia: Int?
    var IdPersonal: Int?
    var IdNumeroSocio: Int?
    var FechaSolicitud: String
    var HoraSolicitud: String
    var IdServicio: Int?
    var IdMedicoSolicita: Int?
    var Destino: String
    var Origen: String
}
