//
//  DashboardModel.swift
//  AppNovaAMSOp
//
//  Created by Alumno on 15/11/25.
//

import Foundation

struct ResumenResponse: Decodable {
    let success: Bool
    let resumen: Resumen
}

struct Resumen: Decodable {
    let activos: Int
    let pendientes: Int
    let completados: Int
}

struct ProximosTrasladosResponse: Decodable {
    let success: Bool
    let proximosTraslados: [TrasladoDashboard]
}

struct TrasladoDashboard: Decodable, Identifiable {
    let id: Int
    let IdAmbulancia: Int
    let ambulanciaId: String
    let nombrePaciente: String
    let operadorAsignado: String
    let idOperador: Int
    let tipoServicio: String
    let direccionOrigen: String
    let direccionDestino: String
    let hora: String
    let fecha: String
    let estatusAgenda: String
}
