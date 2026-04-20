import Foundation
import SwiftUI

struct Notificacion: Codable, Identifiable {
    var id: Int
    var nombrePaciente: String
    var ambulanciaId: String
    var tipoServicio: String
    var operadorAsignado: String
    var destino: String
    var hora: String
    var direccionOrigen: String
    var direccionDestino: String
    var fecha: String
    var estatusAgenda: String
    
    var statusColor: Color {
        switch estatusAgenda.lowercased() {
        case "completado", "finalizado":
            return .green
        case "en proceso", "en curso", "activo":
            return .yellow
        case "pendiente", "programado":
            return .blue
        default:
            return .gray
        }
    }
}

struct NotificacionesResponse: Codable {
    var success: Bool
    var fecha: String
    var notificaciones: [Notificacion]
    var idPersonal: Int?
}

struct Sugerencia: Codable, Identifiable {
    var id: Int
    var idSolicitante: Int
    var nombreSolicitante: String
    var tipoPersonal: String
    var titulo: String
    var idCategoria: Int
    var nombreCategoria: String
    var detalles: String
    var fechaCreacion: String
    
    enum CodingKeys: String, CodingKey {
        case id = "IdSugerencia"
        case idSolicitante = "IdSolicitante"
        case nombreSolicitante = "nombreSolicitante"
        case tipoPersonal = "tipoPersonal"
        case titulo = "Titulo"
        case idCategoria = "IdCategoria"
        case nombreCategoria = "NombreCategoria"
        case detalles = "Detalles"
        case fechaCreacion = "FechaCreacion"
    }
}

struct SugerenciasResponse: Codable {
    var success: Bool
    var sugerencias: [Sugerencia]
}

struct SugerenciaResponse: Codable {
    var success: Bool
    var sugerencia: Sugerencia?
    var message: String?
}

// Modelo de reporte de falla
struct ReporteFalla: Codable, Identifiable {
    var id: Int
    var idAmbulancia: Int
    var ambulanciaId: String
    var tipoAmbulancia: String
    var idUrgencia: Int
    var nivelUrgencia: String
    var idTipoFalla: Int
    var tipoFalla: String
    var descripcion: String
    var fechaReporte: String
    var idPersonal: Int
    var nombreReportante: String
    var tipoPersonal: String
    var estatus: String
    
    enum CodingKeys: String, CodingKey {
        case id = "IdReporteFalla"
        case idAmbulancia = "IdAmbulancia"
        case ambulanciaId = "ambulanciaId"
        case tipoAmbulancia = "tipoAmbulancia"
        case idUrgencia = "IdUrgencia"
        case nivelUrgencia = "nivelUrgencia"
        case idTipoFalla = "IdTipoFalla"
        case tipoFalla = "tipoFalla"
        case descripcion = "Descripcion"
        case fechaReporte = "FechaReporte"
        case idPersonal = "IdPersonal"
        case nombreReportante = "nombreReportante"
        case tipoPersonal = "tipoPersonal"
        case estatus = "Estatus"
    }
}

struct ReportesFallaResponse: Codable {
    var success: Bool
    var reportesFalla: [ReporteFalla]
}

struct ReporteFallaResponse: Codable {
    var success: Bool
    var reporteFalla: ReporteFalla?
    var message: String?
}

struct ReportesFallaByAmbulanciaResponse: Codable {
    var success: Bool
    var idAmbulancia: Int
    var reportesFalla: [ReporteFalla]
}
