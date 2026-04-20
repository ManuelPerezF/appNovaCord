//
//  NotificacioneCard.swift
//  AppNovaAMSCoord
//
//  Created by FernandoHernandez on 01/12/25.
//

import SwiftUI

struct NotificacioneCard: View {

    let nombrePaciente: String
    let ambulanciaId: String
    let statusColor: Color
    let tipoServicio: String
    let operadorAsignado: String
    let destino: String
    let hora: String
    let direccionOrigen: String
    let direccionDestino: String
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Cabecera de la tarjeta
            HStack(spacing: 12) {
                
                // Indicador de estado
                Circle()
                    .fill(statusColor)
                    .frame(width: 12, height: 12)
                
                Text(nombrePaciente)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
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
            
            // Detalles expandidos
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {

                        DetailRow(icon: "stethoscope", label: "Tipo de Servicio", value: tipoServicio)
                        
                
                        DetailRow(icon: "person.fill", label: "Operador Asignado", value: operadorAsignado)
                        
                  
                        DetailRow(icon: "clock.fill", label: "Hora", value: hora)
                        
             
                        DetailRow(icon: "mappin.circle.fill", label: "Origen", value: direccionOrigen)
                        
               
                        DetailRow(icon: "arrow.right.circle.fill", label: "Destino", value: destino)
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

// Pequeña estructura para cada fila de detalle
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                Text(value)
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        NotificacioneCard(
            nombrePaciente: "María González",
            ambulanciaId: "AMB-001",
            statusColor: .green,
            tipoServicio: "Traslado Urgente",
            operadorAsignado: "Carlos Ramírez",
            destino: "Hospital General",
            hora: "09:00 AM",
            direccionOrigen: "Av. Insurgentes 1234, Col. Centro",
            direccionDestino: "Calle Juárez 567, Col. Norte"
        )
    }
    .padding(.vertical)
    .background(Color(red: 242/255, green: 242/255, blue: 242/255))
}
