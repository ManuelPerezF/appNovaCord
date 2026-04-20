//
//  ContentView.swift
//  LogInTry
//
//  Created by Natalia Cavazos on 12/10/25.
//

import SwiftUI

struct LoginView: View {
    @State private var colorPrincipal = Color(red: 1/255, green: 104/255, blue: 138/255)
    @State private var color1 = (Color(red: 242/255, green: 242/255, blue: 242/255))
    @State private var color2 = Color(red: 153/255, green: 153/255, blue: 153/255)
    @State private var usuario: String = ""
    @State private var contrasena: String = ""
    @State private var isValid: Bool = false
    @State private var showAlert = false
    @State private var serverAlert = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false


    
    var body: some View {
        NavigationStack{
            ZStack {
                Rectangle()
                    .fill(color1)
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorPrincipal)
                    .shadow(color: .gray.opacity(0.15), radius: 4, x: 0, y: 2)
                    .frame(width: 350, height: 650)
                Image("appLogo")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350, height: 200)
                    .padding(.bottom, 470)
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .gray.opacity(0.15), radius: 4, x: 0, y: 2)
                    .frame(width: 350, height: 500)
                    .padding(.top, 150)
                
                VStack
                {
                    Text("Iniciar Sesión")
                        .font(.title)
                        .padding(.bottom, 15)
                        .foregroundColor(colorPrincipal)
                        .fontWeight(.bold)
                    
                    Text("Usuario")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(color2)
                        .padding(.leading, -130)
                    
                    
                    HStack{
                        Image(systemName: "person")
                            .foregroundColor(color2)
                        TextField("Usuario", text: $usuario)
                            .textInputAutocapitalization(.never)
                    }
                    .frame(width: 250, height: 35)
                    .padding(6)
                    .background(.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorPrincipal, lineWidth: 1)
                    )
                    
                    Text("Contraseña")
                        .font(.title3)
                        .padding(.leading, -130)
                        .padding(.top, 20)
                        .fontWeight(.medium)
                        .foregroundColor(color2)
                    
                    
                    HStack{
                        Image(systemName: "lock")
                            .foregroundColor(color2)
                        SecureField("Contraseña", text: $contrasena)
                    }
                    .frame(width: 250, height: 35)
                    .padding(6)
                    .background(.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(colorPrincipal, lineWidth: 1)
                    )
                    .padding(.bottom,25)
                    
                    Button("Iniciar Sesión") {
                        Task {
                            do {
                                if usuario.isEmpty || contrasena.isEmpty {
                                    showAlert = true
                                    return
                                }
                                
                                let response = try await LoginService.shared.loginAPI(
                                    usuario: usuario,
                                    codigo: contrasena
                                )
                                
                                if response.success, let token = response.token {
                                    AuthStorage.shared.saveToken(token)

                                    isLoggedIn = true
                                    isValid = true
                                    
                                    UserDefaults.standard.set(usuario, forKey: "usuario")
                                } else {
                                    showAlert = true
                                }
                                
                            } catch LoginError.invalidCredentials {
                                showAlert = true
    
                            } catch {
                                serverAlert = true
                            }
                            
                        }
                    }
                    .frame(width: 300, height: 50)
                    .background(colorPrincipal)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                    .cornerRadius(7)
                    .padding()
                    .alert("Usuario o contraseña invalidos", isPresented: $showAlert) {
                            Button("OK") {}
                        }
                    .alert("Servidor no dispobile", isPresented: $serverAlert) {Button ("Reintentar") {}}
                  
                    
                }
                .padding(.top, 110)
                Image("LogoNova")
                    .offset(x: 0, y: 370)
              
            }
            .onAppear {
                if AuthStorage.shared.getToken() != nil {
                    isValid = true
                }
            }
    
            .background(color1)
            .navigationDestination(isPresented: $isValid){
                ContentView()
            
            }

        }
    }
}
#Preview {
    LoginView()
}
