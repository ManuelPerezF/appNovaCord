//
//  CerrarSesion.swift
//
//
//  Created by Alumno on 14/10/25.
//

import SwiftUI

struct CerrarSesion: View {
    
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @Environment(\.dismiss) var dismiss
    

    
    var body: some View {
            VStack{
                HStack {
                    Button(action: {
                        AuthStorage.shared.clearToken()
                        UserDefaults.standard.removeObject(forKey: "usuario")
                        DispatchQueue.main.async {
                            isLoggedIn = false
                        }
                    }) {
                        
                        Label("Cerrar Sesión", systemImage: "iphone.and.arrow.forward.outward")
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                            .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
                    )
                    .padding(.horizontal, 20)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        
        
    }
    
}

#Preview {
    CerrarSesion()
}
