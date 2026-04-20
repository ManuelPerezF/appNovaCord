//
//  DashboardViewModel.swift
//  AppNovaAMSOp
//
//  Created by Alumno on 15/11/25.
//

import Foundation

@MainActor
class DashboardViewModel: ObservableObject {

    @Published var pendientes = 0
    @Published var activos = 0
    @Published var completados = 0

    @Published var proximos: [TrasladoDashboard] = []

    private let baseURL = "http://10.14.255.40:10205/dashboard"

    
    func fetchDashboard() async throws {
        // Fetch resumen data
        try await fetchResumen()
        
        // Fetch proximos traslados
        try await fetchProximosTraslados()
    }
    
    private func fetchResumen() async throws {
        guard let url = URL(string: "\(baseURL)/resumen") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(ResumenResponse.self, from: data)

        self.activos = decoded.resumen.activos
        self.pendientes = decoded.resumen.pendientes
        self.completados = decoded.resumen.completados
    }
    
    private func fetchProximosTraslados() async throws {
        guard let url = URL(string: "\(baseURL)/proximos-traslados?limit=10") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoded = try JSONDecoder().decode(ProximosTrasladosResponse.self, from: data)
        self.proximos = decoded.proximosTraslados
    }
}
