//
//  NotificacionesAPI.swift
//  AppNovaAMSCoord
//
//  Created by FernandoHernandez on 01/12/25.
//

import Foundation

class NotificacionesAPI {
    
    static let shared = NotificacionesAPI()
    
    private let baseURL = "http://10.14.255.40:10205"
    
    func fetchNotificaciones(fecha: String) async throws -> [Notificacion] {
        let urlString = "\(baseURL)/notificaciones?fecha=\(fecha)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let notificacionesResponse = try JSONDecoder().decode(NotificacionesResponse.self, from: data)
        return notificacionesResponse.notificaciones
    }
    
    func fetchNotificacionesOperador(idPersonal: Int, fecha: String) async throws -> [Notificacion] {
        let urlString = "\(baseURL)/notificaciones/operador/\(idPersonal)?fecha=\(fecha)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let notificacionesResponse = try JSONDecoder().decode(NotificacionesResponse.self, from: data)
        return notificacionesResponse.notificaciones
    }
    
    func fetchSugerencias(fecha: String? = nil) async throws -> [Sugerencia] {
        var urlString = "\(baseURL)/sugerencias"
        if let fecha = fecha {
            urlString += "?fecha=\(fecha)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let sugerenciasResponse = try JSONDecoder().decode(SugerenciasResponse.self, from: data)
        return sugerenciasResponse.sugerencias
    }
    
    func fetchSugerenciaById(id: Int) async throws -> Sugerencia {
        let urlString = "\(baseURL)/sugerencias/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let sugerenciaResponse = try JSONDecoder().decode(SugerenciaResponse.self, from: data)
        
        guard let sugerencia = sugerenciaResponse.sugerencia else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return sugerencia
    }
    
    // Obtener reportes de falla (opcional por fecha)
    func fetchReportesFalla(fecha: String? = nil) async throws -> [ReporteFalla] {
        var urlString = "\(baseURL)/reportes-falla"
        if let fecha = fecha {
            urlString += "?fecha=\(fecha)"
        }
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let reportesResponse = try JSONDecoder().decode(ReportesFallaResponse.self, from: data)
        return reportesResponse.reportesFalla
    }
    
    func fetchReporteFallaById(id: Int) async throws -> ReporteFalla {
        let urlString = "\(baseURL)/reportes-falla/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let reporteResponse = try JSONDecoder().decode(ReporteFallaResponse.self, from: data)
        
        guard let reporteFalla = reporteResponse.reporteFalla else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return reporteFalla
    }
    
    func fetchReportesFallaByAmbulancia(idAmbulancia: Int) async throws -> [ReporteFalla] {
        let urlString = "\(baseURL)/reportes-falla/ambulancia/\(idAmbulancia)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let reportesResponse = try JSONDecoder().decode(ReportesFallaByAmbulanciaResponse.self, from: data)
        return reportesResponse.reportesFalla
    }
}
