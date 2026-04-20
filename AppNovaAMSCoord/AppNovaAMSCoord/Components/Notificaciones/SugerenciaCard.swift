//
//  SugerenciaCard.swift
//  AppNovaAMSCoord
//
//  Created by FernandoHernandez on 02/12/25.
//

import SwiftUI

struct SugerenciaCard: View {

    let nombreSolicitante: String
    let tipoPersonal: String
    let titulo: String
    let nombreCategoria: String
    let detalles: String
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Cabecera de sugerencia
            HStack(spacing: 12) {
                
                Circle()
                    .fill(.yellow)
                    .frame(width: 12, height: 12)
                
                Text(titulo)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Spacer()
                
                // Categoría
                HStack(spacing: 4) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                    Text(nombreCategoria)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                        .lineLimit(1)
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
            
            // Detalles de sugerencia
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 10) {

                        DetailRow(icon: "person.fill", label: "Solicitante", value: nombreSolicitante)
                        
                        DetailRow(icon: "person.badge.shield.checkmark", label: "Tipo de Personal", value: tipoPersonal)
                        
                        DetailRow(icon: "text.alignleft", label: "Detalles", value: detalles)
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
        SugerenciaCard(
            nombreSolicitante: "Carlos Ramírez",
            tipoPersonal: "Operador",
            titulo: "Mejorar ruta hacia Hospital ABC",
            nombreCategoria: "Operaciones",
            detalles: "Sugiero optimizar la ruta para reducir tiempo de traslado",
        )
    }
    .padding(.vertical)
    .background(Color(red: 242/255, green: 242/255, blue: 242/255))
}
