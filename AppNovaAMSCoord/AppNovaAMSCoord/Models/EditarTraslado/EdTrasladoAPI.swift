//
//  EdTrasladoAPI.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 02/12/25.
//

import Foundation

func fetchTraslado(id: Int) async throws -> TrasladoData {
    let urlString = "http://10.14.255.40:10205/traslado/\(id)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode(TrasladoData.self, from: data)
}

func updateTraslado(id: Int, body: UpdateTrasladoRequest) async throws {
    let urlString = "http://10.14.255.40:10205/traslado/\(id)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let jsonData = try JSONEncoder().encode(body)
    request.httpBody = jsonData

    let (_, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
}

func cancelarTraslado(id: Int) async throws {
    let urlString = "http:///10.14.255.40:10205/\(id)/cancelar"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "PUT"

    let (_, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
}
