//
//  AmbulanciasPicker.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 01/12/25.
//

import SwiftUI

struct AmbulanciasPicker: View {
    @State private var azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    @Binding var selectedAmbulancia: String
   
    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false
    @State private var ambulancias: [Ambulancia] = []
    
    private var ambulanciaOptions: [String] {
        let ids = ambulancias.map { "AMB-\(String(format: "%03d", $0.id))" }
        let uniqueIds = Array(Set(ids)).sorted()
        return ["Asignar Ambulancia"] + uniqueIds
    }
    
    private var selectedAmbulanciaName: String {
        if selectedAmbulancia.isEmpty || selectedAmbulancia == "sin asignar" {
            return "Asignar Ambulancia..."
        }
        return selectedAmbulancia
    }
    
    private func loadAmbulancias() async {
        isLoading = true
        errorMessage = nil
        
        do {
            ambulancias = try await AmbulanciaAPI.shared.fetchAmbulancias()
            
            if selectedAmbulancia.isEmpty {
                selectedAmbulancia = "sin asignar"
            }
            
        } catch {
            errorMessage = "No se pudo conectar con el servidor."
        }
        
        isLoading = false
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("Ambulancia asignada")
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.leading, 10)
                .padding(.bottom, 5)
            HStack {
                Image(systemName: "car")
                    .foregroundColor(azul)
                    .padding(.leading, 10)
                    .imageScale(.large)
             
                    Menu {
                        ForEach(ambulanciaOptions, id: \.self) { ambulancia in
                            Button(ambulancia) {
                                selectedAmbulancia = ambulancia == "Asignar Ambulancia" ? "sin asignar" : ambulancia
                            }
                        }
                    } label: {
                        Text(selectedAmbulanciaName)
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
                await loadAmbulancias()
            }
        }
    }
}

#Preview {
    AmbulanciasPicker(selectedAmbulancia: .constant("sin asignar"))
}
