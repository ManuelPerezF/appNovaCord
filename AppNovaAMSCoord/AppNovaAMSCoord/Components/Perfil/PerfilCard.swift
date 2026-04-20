//
//  PerfilCard.swift
//  User-Entrega1
//
//  Created by Manuel Antonio Perez Fonseca on 13/10/25.
//

import SwiftUI

struct PerfilCard: View {
    var name: String
    var description: String
    var avatarColor: Color
    
    var body: some View {
        VStack {
            // Avatar Circular
            Circle()
                .fill(avatarColor)
                .frame(width: 80, height: 80) // Tamaño del avatar
                .overlay(
                    Text(String(name.prefix(1))) // Letra inicial
                        .foregroundColor(.white)
                        .font(.title)
                )
            
            // Nombre
            Text(name)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            // Descripción
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 2)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 20)
    }
}

#Preview {
    PerfilCard(name: "Juan Rodríguez", description: "Paramédico", avatarColor: .blue)
}
