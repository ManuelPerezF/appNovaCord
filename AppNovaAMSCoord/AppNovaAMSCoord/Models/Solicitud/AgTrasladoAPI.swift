//
//  AgTrasladoAPI.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 25/11/25.
//

import Foundation

func postSolicitud(_ traslado: TrasladoPost) async throws {
    guard let url = URL(string:"http://10.14.255.40:10205/solicitud") else{
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    let jsonData = try encoder.encode(traslado)
    request.httpBody = jsonData
    
    // Log del JSON que se está enviando
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print("📤 Enviando JSON:")
        print(jsonString)
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)
    if let http = response as? HTTPURLResponse {
        print("STATUS:", http.statusCode)
        if let bodyString = String(data: data, encoding: .utf8) {
            print("BODY:", bodyString)
        } else {
            print("BODY: NO BODY")
        }
    }
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
        throw URLError(.badServerResponse)
    }
}
