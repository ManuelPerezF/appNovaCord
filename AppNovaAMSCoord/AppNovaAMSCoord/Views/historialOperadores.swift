//
//  historialOperadores.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 25/11/25.
//

import SwiftUI

struct historialOperadores: View {
    @State private var operadores: [Operador] = []
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var connection: WebSocketConnection<[Operador], Operador>?
    
    @State private var selectedOperador: String = "Todos"
    @State private var selectedStatus: String = "Todos"
    let statusOptions = ["Todos", "Disponible", "En Traslado", "No disponible"]


    private var operadorOptions: [String] {
        let nombres = operadores.map { $0.nombre }
        let uniqueNames = Array(Set(nombres)).sorted()
        return ["Todos"] + uniqueNames
    }
    
    private var filteredOperadores: [Operador] {
        var filtered = operadores

        if selectedOperador != "Todos" {
            filtered = filtered.filter { operador in
                operador.nombre == selectedOperador
            }
        }
        
        if selectedStatus != "Todos" {
            filtered = filtered.filter { operador in
                operador.status == selectedStatus
            }
        }
        
        return filtered
    }

    private func start() {
        Task {
            await loadOperadores()
            await connectWebSocket()
        }
    }
    
    private func stop() {
        connection?.close()
        connection = nil
    }
    
    @MainActor
    private func loadOperadores() async {
        isLoading = true
        errorMessage = nil
        
        do {
            operadores = try await OperadoresAPI.shared.fetchOperadores()
            
        } catch {
            errorMessage = "No se pudo conectar con el servidor."
        }
        
        isLoading = false
    }
    
    // websocket
    
    @MainActor
    private func connectWebSocket() async {
        guard let url = URL(string: "ws://10.14.255.40:10205/operadores/ws") else {
            errorMessage = "URL de WebSocket inválida."
            return
        }
        
        let task = URLSession.shared.webSocketTask(with: url)
        let conn = WebSocketConnection<[Operador], Operador>(webSocketTask: task)
        self.connection = conn
        
        Task { @MainActor in
            do {
                for try await lista in conn.receive() {
                    self.operadores = lista
                }
            } catch {
                print("Error en WebSocket:", error)
                self.errorMessage = "Error de conexción con el servidor."
            }
        }
    }
    
    
    var body: some View {
        VStack (spacing: 0) {
            TopBarComp(nameIcon: "heart.text.square", nameTag: "Historial Operadores")
            
            VStack {
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        // Picker para operador
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Operador")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Picker("Coordinador", selection: $selectedOperador) {
                                ForEach(operadorOptions, id: \.self) { operador in
                                    Text(operador == "Todos" ? "Todos" : operador)
                                        .tag(operador)
                                }
                            }
                            .tint(Color(red: 50/255, green: 130/255, blue: 160/255))
                            .pickerStyle(MenuPickerStyle())
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                  
                        }
                        
                        // Picker para estatus
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Estatus")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            
                            Picker("Estatus", selection: $selectedStatus) {
                                ForEach(statusOptions, id: \.self) { status in
                                    Text(status)
                                        .tag(status)
                                }
                            }
                            .tint(Color(red: 50/255, green: 130/255, blue: 160/255))
                            .pickerStyle(MenuPickerStyle())
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .background(Color(red: 242/255, green: 242/255, blue: 242/255))
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isLoading && operadores.isEmpty {
                    VStack {
                        Spacer()
                        ProgressView()
                        Text("Cargando operadores…")
                        Spacer()
                    }
                    .frame (maxWidth: .infinity)
                }
                else {
                    // No resultado para el filtrp
                    if filteredOperadores.isEmpty && !operadores.isEmpty {
                        VStack {
                            Spacer()
                            Image(systemName: "person.slash")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("No se encontraron operadores")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        List(filteredOperadores) { item in
                            ZStack {
                                operadorRow(operador: item)
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Regresar")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(Color(red: 50/255, green: 130/255, blue: 160/255))
                }
            }
        }
        .onAppear {
            start()
        }
        .onDisappear {
            stop()
        }
    }
}

#Preview {
    historialOperadores()
}
