//
//  ProximosTrasladosCard.swift
//  dashboardNovaAMS
//
//  Created by FernandoHernandez on 13/10/25.
//

import SwiftUI

struct ProximosTrasladosCard: View {
    var ambulanciaId: String
    var operadorNombre: String
    var operadorId: Int
    var nombrePaciente: String
    var tipoServicio: String
    var origen: String
    var destino: String
    var hora: String
    var fecha: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Ambulancia ID
            HStack {
                Image(systemName: "cross.case.fill")
                    .foregroundColor(Color(red: 255/255, green: 153/255, blue: 0/255))
                Text(ambulanciaId)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 1/255, green: 104/255, blue: 138/255))
                
                Spacer()
                
                // Date and time
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formatDate(fecha))
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(hora)
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            // Patient name
            HStack(spacing: 8) {
                Image(systemName: "person.fill")
                    .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                    .frame(width: 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Paciente")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(nombrePaciente)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
            }
            
            // Operator name and ID
            HStack(spacing: 8) {
                Image(systemName: "person.badge.shield.checkmark")
                    .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                    .frame(width: 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Operador")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(operadorNombre) (ID: \(operadorId))")
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
            }
            
            // Service type
            HStack(spacing: 8) {
                Image(systemName: "list.clipboard")
                    .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                    .frame(width: 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Tipo de servicio")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(tipoServicio)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                }
            }
            
            Divider()
            
            // Origin
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.green)
                    .frame(width: 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Origen")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(origen)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.85))
                }
            }
            
            // Destination
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
                    .frame(width: 16)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Destino")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(destino)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.85))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let date = formatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MMM/yyyy"
            outputFormatter.locale = Locale(identifier: "es_MX")
            return outputFormatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    VStack(spacing: 12) {
        ProximosTrasladosCard(
            ambulanciaId: "AMB-001",
            operadorNombre: "Juan Pérez",
            operadorId: 123,
            nombrePaciente: "María González",
            tipoServicio: "Traslado de Emergencia",
            origen: "IMSS 20, Calle Principal #123",
            destino: "Hospital General, Av. Central #456",
            hora: "09:00",
            fecha: "2024-12-02T09:00:00"
        )
    }
}
