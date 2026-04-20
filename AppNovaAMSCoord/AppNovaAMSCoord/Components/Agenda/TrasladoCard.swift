//
//  TrasladoCard.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 03/12/25.
//

import SwiftUI

struct TrasladoCard: View {
    let traslado: TrasladoPendiente
    let ambulancia: String
    @Binding var selectedTraslado: TrasladoPendiente?
    @Binding var showEditView: Bool
    
    // Inicializador público explícito
    init(traslado: TrasladoPendiente, ambulancia: String, selectedTraslado: Binding<TrasladoPendiente?>, showEditView: Binding<Bool>) {
        self.traslado = traslado
        self.ambulancia = ambulancia
        self._selectedTraslado = selectedTraslado
        self._showEditView = showEditView
    }
    
    private var azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    
    private var estadoBadgeColor: Color {
        switch traslado.estadoAsignacion {
        case .asignado:
            return azul
        case .noAsignado:
            return Color.gray
        case .enCurso:
            return Color.orange
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Encabezado con nombre y badge de estado
            HStack {
                Image(systemName: "person.fill")
                    .foregroundColor(azul)
                    .imageScale(.medium)
                
                Text(traslado.nombreAsociado ?? "Sin nombre")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(traslado.estadoAsignacion.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(estadoBadgeColor)
                    .cornerRadius(12)
            }
            
            // Información del horario
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                Text(traslado.horaSolicitud ?? "Sin hora")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Origen
            HStack(spacing: 4) {
                Image(systemName: "mappin")
                    .foregroundColor(azul)
                    .imageScale(.small)
                Text(traslado.origen)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            // Destino
            HStack(spacing: 4) {
                Image(systemName: "location.fill")
                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                    .imageScale(.small)
                Text(traslado.destino)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            // Información de viaje
            HStack(spacing: 4) {
                Image(systemName: "car.fill")
                    .foregroundColor(.gray)
                    .imageScale(.small)
                
                if traslado.idServicio == 1 {
                    Text("VIAJE SENCILLO")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("VIAJE REDONDO")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Ambulancia asignada
            HStack(spacing: 4) {
                Image(systemName: "cross.case.fill")
                    .foregroundColor(azul)
                    .imageScale(.small)
                Text(ambulancia)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(azul)
            }
            
          
            if traslado.estadoAsignacion == .asignado || traslado.estadoAsignacion == .enCurso {
                if let nombreOperador = traslado.nombrePersonal {
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(azul)
                            .imageScale(.small)
                        Text("Operador: \(nombreOperador)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(azul)
                    }
                }
            }
            
            // Botón de editar
            Button(action: {
                selectedTraslado = traslado
                showEditView = true
            }) {
                HStack {
                    Spacer()
                    Text("Editar")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(azul)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}
