//
//  OperadorPicker.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 01/12/25.
//

import SwiftUI

struct OperadorPicker: View {
    @State private var azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    @Binding var selectedOperador: String
   
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var operadores: [Operador] = []
    
    private var operadorOptions: [String] {
        let nombres = operadores.map { $0.nombre }
        let uniqueNames = Array(Set(nombres)).sorted()
        return ["Asignar Operador"] + uniqueNames
    }
    
    private var selectedOperadorName: String {
        if selectedOperador.isEmpty || selectedOperador == "sin asignar" {
            return "Asignar Operador..."
        }
        return selectedOperador
    }
    
    private func loadOperadores() async {
        isLoading = true
        errorMessage = nil
        
        do {
            operadores = try await OperadoresAPI.shared.fetchOperadores()
            
            if selectedOperador.isEmpty {
                selectedOperador = "sin asignar"
            }
            
        } catch {
            errorMessage = "No se pudo conectar con el servidor."
        }
        
        isLoading = false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Operador Asignado")
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.leading, 10)
                .padding(.bottom, 5)
            HStack {
                Image(systemName: "list.bullet.clipboard")
                    .foregroundColor(azul)
                    .padding(.leading, 10)
                    .imageScale(.large)
             
                    Menu {
                        ForEach(operadorOptions, id: \.self) { operador in
                            Button(operador) {
                                selectedOperador = operador == "Asignar Operador..." ? "sin asignar" : operador
                            }
                        }
                    } label: {
                        Text(selectedOperadorName)
                            .foregroundColor(.black)
                    }
                
                .padding(9)
                .tint(.black)
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(azul, lineWidth: 1)
            )
            .padding(.bottom, 7)
        }
        .onAppear {
            Task {
                await loadOperadores()
            }
        }
    }
}

#Preview {
    OperadorPicker(selectedOperador: .constant("sin asignar"))
}
