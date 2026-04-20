//
//  AmbulanciaAPI.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 13/11/25.
//

import Foundation

class AmbulanciaAPI {
    
    static let shared = AmbulanciaAPI()

    func fetchAmbulancias() async throws -> [Ambulancia] {
        guard let url = URL(string: "http://10.14.255.40:10205/ambulancias")
        else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        if let token = AuthStorage.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Enviando JWT: \(token)")
        } else {
            print("No hay token guardado")
            throw URLError(.userAuthenticationRequired)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Ambulancia].self, from: data)
    }
    

}
