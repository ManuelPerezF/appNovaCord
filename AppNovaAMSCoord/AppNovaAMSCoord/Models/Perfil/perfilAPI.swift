//
//  PerfilAPI.swift
//  AppNovaAMSOp
//
//  Created by Alumno on 26/11/25.
//

import Foundation

func fetchPerfil(matricula: String) async throws -> PerfilData{
    let urlString = "http://10.14.255.40:10205/perfil/\(matricula)"
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    let (data, _) = try await URLSession.shared.data(from: url)
    let perfil = try JSONDecoder().decode(PerfilData.self, from: data)
    return perfil
}
