//
//  operadoresAPI.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 27/11/25.
//

import Foundation


import Foundation

class OperadoresAPI {
    
    static let shared = OperadoresAPI()

    func fetchOperadores() async throws -> [Operador] {
        guard let url = URL(string: "http://10.14.255.40:10205/operadores")
        else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        if let token = AuthStorage.shared.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200
        else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode([Operador].self, from: data)
    }
    

}
