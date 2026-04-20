//
//  ButtonCard.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 02/12/25.
//

import SwiftUI

struct ButtonCard: View {
    var textImage: String
    var textTitle: String
    var textButton: String
    var destination: AnyView

    @State private var colorPrincipal = Color(red: 1/255, green: 104/255, blue: 138/255)
    var body: some View {
        ZStack {
            NavigationLink(destination: destination) {
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack {
                        Image(systemName: textImage)
                            .foregroundColor(colorPrincipal)
                            .bold(true)
                        Text(textTitle)
                            .font(.title2)
                            .foregroundColor(.gray)
                            .bold(true)
                        Spacer()
                    }
                    
                    HStack {
                        Text(textButton)
                            .foregroundColor(.gray)
                            .font(.headline)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.headline)
                    }
                    .padding()
                    .background(colorPrincipal.opacity(0.2))
                    .cornerRadius(20)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal, 20)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
    

#Preview {
    NavigationStack {
        ButtonCard(
            textImage: "person",
            textTitle: "Historial de operadores",
            textButton: "Ver historial de los operadores",
            destination: AnyView(historialOperadores())
        )
    }
}
