//
//  editar.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 03/12/25.
//

import Foundation


struct TrasladoPendiente: Identifiable, Codable {
    let id: Int
    let idNumeroSocio: Int
    let idServicio: Int
    let origen: String
    let destino: String
    let fechaSolicitud: String
    let horaSolicitud: String?
    let idAmbulancia: Int?
    let idPersonal: Int?
    let idEstatusAgenda: Int?
    let nombrePersonal: String?
    let nombreAsociado: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "IdSolicitudAmbulancia"
        case idNumeroSocio = "IdNumeroSocio"
        case idServicio = "IdServicio"
        case origen = "Origen"
        case destino = "Destino"
        case fechaSolicitud = "FechaSolicitud"
        case horaSolicitud = "HoraSolicitud"
        case idAmbulancia = "IdAmbulancia"
        case idPersonal = "IdPersonal"
        case idEstatusAgenda = "IdEstatusAgenda"
        case nombrePersonal = "NombrePersonal"
        case nombreAsociado = "NombreAsociado"
    }
    
    // Computed properties para facilitar el uso
    var ambulanciaAsignada: Bool {
        return idAmbulancia != nil
    }
    
    var operadorAsignado: Bool {
        return idPersonal != nil
    }
    
    var estadoAsignacion: EstadoAsignacion {
        guard let estatusAgenda = idEstatusAgenda else {
            return .noAsignado
        }
        
        switch estatusAgenda {
        case 1:
            return .asignado
        case 2:
            return .enCurso
        default:
            return .noAsignado
        }
    }
}

// Enum para el estado de asignaccion
enum EstadoAsignacion: String {
    case asignado = "asignado"      
    case noAsignado = "no asignado"
    case enCurso = "en curso"
    
    var color: String {
        switch self {
        case .asignado:
            return "blue"
        case .noAsignado:
            return "gray"
        case .enCurso:
            return "orange"
        }
    }
}

// Response del backend
struct TrasladosPendientesResponse: Codable {
    let success: Bool
    let message: String
    let data: [TrasladoPendiente]
}
