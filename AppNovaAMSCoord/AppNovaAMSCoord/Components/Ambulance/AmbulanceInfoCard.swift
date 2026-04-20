//
//  AmbulanceInfoCard.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 06/11/25.
//

import SwiftUI

struct AmbulanceInfoCard: View {
    public let ambulance: Ambulancia 
    @State private var colorPrincipal = Color(red: 1/255, green: 104/255, blue: 138/255)
    
    var typeColor: Color {
        if (ambulance.type == "Soporte") {
            return colorPrincipal
        }
        if (ambulance.type == "Transporte") {
            return colorPrincipal.opacity(0.2)
        }
        return .gray
    }
    
    var statusColor: Color {
        if (ambulance.status == "Disponible") {
            return .green
        }
        if (ambulance.status == "En Servicio") {
            return Color(red:186/255, green:141/255, blue:35/255)
            
        }
        return .gray
    }
    
    var textTypeColor: Color {
        if (ambulance.type == "Soporte") {
            return .white
        }
        if (ambulance.type == "Transporte") {
            return colorPrincipal
        }
        return .gray
    }


    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image("ambulance")
                            .resizable()
                            .scaledToFit()
                            .padding(10)
                    )
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("AMB-\(ambulance.id)")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.gray)
                    
                    Text(ambulance.type)
                        .font(.caption)
                        .foregroundColor(textTypeColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(typeColor)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Text(ambulance.status)
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            HStack {
                Text("Kilometraje: ")
                    .font(.subheadline)
                + Text("\(ambulance.km)km")
                    .font(.subheadline)
                    .bold()
                
                Spacer()
              /*
                Text("Ubicación: ")
                    .font(.subheadline)
                + Text(ambulance.ubication)
                    .font(.subheadline)
                    .bold()
               */
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
    }
}

#Preview {
    AmbulanceInfoCard(ambulance: Ambulancia(id: 1, type: "Transporte", status: "En Servicio" , km: 4000 /*, ubication: "Clinica Nova"*/))
}
