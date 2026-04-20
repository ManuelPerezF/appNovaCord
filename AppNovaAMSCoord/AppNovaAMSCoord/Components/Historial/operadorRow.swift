//
//  operadorRow.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 25/11/25.
//

import SwiftUI

struct operadorRow: View {
    var operador: Operador
    
    var statusColor: Color {
        if (operador.status == "Disponible") {
            return .green
        }
        if (operador.status == "En Traslado") {
            return .yellow
        }
        return .gray
    }
    
    
    var body: some View {
        VStack(spacing: 12) 
        {
            HStack(alignment: .top, spacing: 12)
            {
                Image(systemName: "person")
                    .padding(.top, 6)
                
                // Nombrr / asignados / completados
                VStack(alignment: .leading, spacing: 6)
                {

                    Text(operador.nombre)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.gray)

                    Text("Traslados asignados: \(operador.asignados)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)

                    Text("Traslados completados: \(operador.completados)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                }
                
                Spacer()
                VStack(alignment: .trailing, spacing: 6)
                {
                    Text(operador.status)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(statusColor)
                        .clipShape(Capsule())
                    
                    Image(systemName: "square.and.arrow.down")
                        .padding(.top, 27)
                    
                    
                }
            }
            
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        
    }
}

#Preview {
    operadorRow(operador: Operador(id: 1, nombre: "Manuel", status: "En servicio", asignados: 6, completados: 7))
}
