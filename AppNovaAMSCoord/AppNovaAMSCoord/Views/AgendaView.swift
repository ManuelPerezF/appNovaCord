//
//  AgendaView.swift
//  LogInTry
//
//  Created by Natalia Cavazos on 13/10/25.
//

import SwiftUI

struct AgendaView: View {
    @State var username: String = ""
    @StateObject var vm = AgendaViewModel()
    @State private var selectedFilter: FiltroEstado = .todos
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var trasladosPendientes: [TrasladoPendiente] = []
    @State private var selectedTraslado: TrasladoPendiente?
    @State private var showEditView = false
    
    private let azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    
    enum FiltroEstado: String, CaseIterable {
        case todos = "Todos"
        case asignados = "Asignados"
        case noAsignados = "No asignados"
        case enCurso = "En curso"
    }

    var trasladosFiltrados: [TrasladoPendiente] {
        switch selectedFilter {
        case .todos:
            return trasladosPendientes
        case .asignados:
            return trasladosPendientes.filter { $0.estadoAsignacion == .asignado }
        case .noAsignados:
            return trasladosPendientes.filter { $0.estadoAsignacion == .noAsignado }
        case .enCurso:
            return trasladosPendientes.filter { $0.estadoAsignacion == .enCurso }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TopBarComp(nameIcon: "calendar", nameTag: "Agenda")
                
     
                
                // Filtros
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(FiltroEstado.allCases, id: \.self) { filtro in
                            Button(action: {
                                withAnimation {
                                    selectedFilter = filtro
                                }
                            }) {
                                Text(filtro.rawValue)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedFilter == filtro ? .white : azul)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedFilter == filtro ? azul : Color.white)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(azul, lineWidth: selectedFilter == filtro ? 0 : 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }
                
                if isLoading {
                    Spacer()
                    ProgressView()
                        .scaleEffect(1.5)
                    Spacer()
                } else if let error = errorMessage {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        Text("Error al cargar traslados")
                            .font(.headline)
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                        Button("Reintentar") {
                            Task {
                                await cargarTraslados()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(azul)
                    }
                    .padding()
                    Spacer()
                } else if trasladosFiltrados.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text("No hay traslados")
                            .font(.headline)
                        Text("No se encontraron traslados para este filtro")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(trasladosFiltrados) { traslado in
                                TrasladoCard(
                                    traslado: traslado,
                                    ambulancia: obtenerNombreAmbulancia(traslado),
                                    selectedTraslado: $selectedTraslado,
                                    showEditView: $showEditView
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                    }
                    .background(Color(red: 242/255, green: 242/255, blue: 242/255))
                }
            }
            .onAppear {
                if let savedUsername = UserDefaults.standard.string(forKey: "usuario") {
                    username = savedUsername
                }
                Task {
                    await cargarTraslados()
                }
            }
            .sheet(isPresented: $showEditView) {
                if let traslado = selectedTraslado {
                    EditarTrasladoView(traslado: traslado)
                }
            }
            .toolbar(.hidden)
        }
    }
    

    private func cargarTraslados() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let traslados = try await TrasladosPendientesAPI.shared.fetchTrasladosPendientes()
            await MainActor.run {
       
                var uniqueTraslados: [TrasladoPendiente] = []
                var seenIDs = Set<Int>()
                
                for traslado in traslados {
                    if !seenIDs.contains(traslado.id) {
                        seenIDs.insert(traslado.id)
                        uniqueTraslados.append(traslado)
                    }
                }
                
                self.trasladosPendientes = uniqueTraslados
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func obtenerNombreAmbulancia(_ traslado: TrasladoPendiente) -> String {
        if let idAmbulancia = traslado.idAmbulancia {
            return "AMB-\(String(format: "%02d", idAmbulancia))"
        } else {
            return "Sin asignar"
        }
    }
}

#Preview {
    AgendaView()
}
