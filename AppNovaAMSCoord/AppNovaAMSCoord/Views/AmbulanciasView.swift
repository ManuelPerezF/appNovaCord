//
//  AmbulanciasView.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 06/11/25.
//

import SwiftUI

struct AmbulanciasView: View {
    
    @State private var ambulancias: [Ambulancia] = []
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    
    @State private var connection: WebSocketConnection<[Ambulancia], Ambulancia>?
    
    private func start() {
        Task {
            await loadAmbulancias()
            await connectWebSocket()
        }
    }
    
    private func stop() {
        connection?.close()
        connection = nil
    }
    
    private var disponibles: Int {
        ambulancias.filter { $0.status == "Disponible" }.count
    }
    
    private var enServicio: Int {
        ambulancias.filter { $0.status == "En Servicio" }.count
    }
    
    @MainActor
    func loadAmbulancias() async {
        isLoading = true
        errorMessage = nil
        
        do {
            ambulancias = try await AmbulanciaAPI.shared.fetchAmbulancias()
        } catch {
            errorMessage = "No se pudo conectar con el servidor."
        }
        
        isLoading = false
    }
    
    @MainActor
    private func connectWebSocket() async {
        guard let url = URL(string: "ws://10.14.255.40:10205/ambulancias/ws") else {
            errorMessage = "URL de WebSocket inválida."
            return
        }
        
        let task = URLSession.shared.webSocketTask(with: url)
        let conn = WebSocketConnection<[Ambulancia], Ambulancia>(webSocketTask: task)
        self.connection = conn
        
        Task { @MainActor in
            do {
                for try await lista in conn.receive() {
                    self.ambulancias = lista
                }
            } catch {
                print("Error en WebSocket:", error)
            }
        }
    }
    
    
    var body: some View {
        VStack(spacing: 0){
            TopBarComp(nameIcon: "cross", nameTag: "Ambulancias")
            // Estadísticas disponible/en servicio
            VStack
            {
                HStack(spacing: 10)
                {
                    BoxCardAmbulance(
                        title: "Disponibles",
                        value: "\(disponibles)",
                        cardBg: Color.white.opacity(0.8),
                        iconFg: .gray,
                        iconBadgeBg: .green.opacity(0.15),
                        systemIcon: "checkmark.circle"
                    )
                    
                    BoxCardAmbulance(
                        title: "En servicio",
                        value: "\(enServicio)",
                        cardBg: Color.white.opacity(0.8),
                        iconFg: .gray,
                        iconBadgeBg: .red.opacity(0.15),
                        systemIcon: "x.circle"
                    )
                    
                }
                .padding(.horizontal)
                .padding(.top, 20)
                Spacer()
                
                if isLoading {
                    ProgressView("Cargando ambulancias…")
                        .padding(.top, 20)
                }
                
                if let errorMessage = errorMessage {
                    VStack(spacing: 12) {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            Task {
                                await loadAmbulancias()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                Text("Reintentar")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color(red: 1/255, green: 104/255, blue: 138/255))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .padding(.top, 20)
                }
                
                if !isLoading && errorMessage == nil {
                    List(ambulancias) { item in
                        ZStack {
                            AmbulanceInfoCard(ambulance: item)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
                
            }
            
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
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
    AmbulanciasView()
}
    
