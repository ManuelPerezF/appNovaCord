//
//  NotificacionesView.swift
//  AppNovaAMSOp
//
//  Created by FernandoHernandez on 27/11/25.
//

import SwiftUI

struct ReporteFallaCard: View {

    let ambulanciaId: String
    let tipoAmbulancia: String
    let nivelUrgencia: String
    let tipoFalla: String
    let descripcion: String
    let nombreReportante: String
    let tipoPersonal: String
    let estatus: String
    
    @State private var isExpanded: Bool = false
    
    // Color según nivel de urgencia
    private var urgenciaColor: Color {
        switch nivelUrgencia.lowercased() {
        case "alta", "crítica":
            return .red
        case "media", "moderada":
            return .orange
        case "baja":
            return .yellow
        default:
            return .gray
        }
    }
    
    // Color según estatus del reporte
    private var estatusColor: Color {
        switch estatus.lowercased() {
        case "resuelto", "completado":
            return .green
        case "en proceso", "en progreso":
            return .blue
        case "pendiente":
            return .orange
        default:
            return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Cabecera del reporte
            HStack(spacing: 12) {
                
                // Indicador de urgencia
                Circle()
                    .fill(urgenciaColor)
                    .frame(width: 12, height: 12)
                
                Text(tipoFalla)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image("ambulance")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                    Text(ambulanciaId)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                }
                
                // Botón expandir
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {

                        DetailRow(icon: "car.fill", label: "Tipo de Ambulancia", value: tipoAmbulancia)
                        
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(urgenciaColor)
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Nivel de Urgencia")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                Text(nivelUrgencia)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(urgenciaColor)
                            }
                            
                            Spacer()
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 14))
                                .foregroundColor(estatusColor)
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Estatus")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                                Text(estatus)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(estatusColor)
                            }
                            
                            Spacer()
                        }
                        
                        DetailRow(icon: "person.fill", label: "Reportante", value: nombreReportante)
                        
                        DetailRow(icon: "person.badge.shield.checkmark", label: "Tipo de Personal", value: tipoPersonal)
                        
                        DetailRow(icon: "text.alignleft", label: "Descripción", value: descripcion)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
}

#Preview {
    VStack(spacing: 16) {
        ReporteFallaCard(
            ambulanciaId: "AMB-003",
            tipoAmbulancia: "Tipo A",
            nivelUrgencia: "Alta",
            tipoFalla: "Falla Mecánica",
            descripcion: "Problema con el motor que requiere atención inmediata",
            nombreReportante: "María Torres",
            tipoPersonal: "Operador",
            estatus: "Pendiente"
        )
    }
    .padding(.vertical)
    .background(Color(red: 242/255, green: 242/255, blue: 242/255))
}
