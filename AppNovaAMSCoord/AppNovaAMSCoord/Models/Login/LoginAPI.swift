//
//  loginView.swift
//  AppNovaAMSOp
//
//  Created by Manuel Antonio Perez Fonseca on 14/11/25.
//

import Foundation

enum LoginError: Error {
    case invalidCredentials
    case serverError
}

class LoginService {
    static let shared = LoginService()
    
    func loginAPI(usuario: String, codigo: String) async throws -> LoginResponse {
        
        guard let url = URL(string: "http://10.14.255.40:10205/login/coordinador") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 5
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["matricula":usuario, "vcCodigoUsuario":codigo]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw LoginError.serverError
        }
        
        let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
        
        if http.statusCode == 200 {
            if let token = loginResponse.token {
                AuthStorage.shared.saveToken(token)
            }
            return loginResponse
        } else {
            throw LoginError.invalidCredentials
        }
        
    }
}
