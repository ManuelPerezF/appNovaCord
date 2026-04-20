//
//  editarAPI.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 03/12/25.
//

import Foundation

class TrasladosPendientesAPI {
    static let shared = TrasladosPendientesAPI()
    
    private let baseURL = "http://10.14.255.40:10205"
    
    private init() {}
    
    func fetchTrasladosPendientes() async throws -> [TrasladoPendiente] {
        let urlString = "\(baseURL)/traslados/pendientes"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(TrasladosPendientesResponse.self, from: data)
        
        return apiResponse.data
    }
    
    // Obtener un traslado específico por ID
    func fetchTraslado(id: Int) async throws -> TrasladoPendiente {
        let urlString = "\(baseURL)/traslado/\(id)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        let apiResponse = try decoder.decode(TrasladoResponse.self, from: data)
        
        return apiResponse.data
    }
}


struct TrasladoResponse: Codable {
    let success: Bool
    let message: String
    let data: TrasladoPendiente
}
