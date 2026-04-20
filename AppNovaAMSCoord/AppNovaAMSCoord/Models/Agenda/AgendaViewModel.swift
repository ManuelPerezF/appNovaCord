//
//  AgendaViewModel.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 01/12/25.
//

import Foundation

class AgendaViewModel: ObservableObject {

    @Published var traslados: [TrasladoAPI] = []

    private let baseURL = "http://10.14.255.40:10205"

    // Cargar todos los registros
    func cargarAgenda() {
        guard let url = URL(string: "\(baseURL)/agenda") else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([TrasladoAPI].self, from: data) {
                    DispatchQueue.main.async {
                        self.traslados = decoded
                    }
                }
            }
        }.resume()
    }

    // Aceptar tarea / cambia estatus
    func activarTraslado(id: Int) {
        guard let url = URL(string: "\(baseURL)/agenda/\(id)/activar") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                self.cargarAgenda()
            }
        }.resume()
    }
}
