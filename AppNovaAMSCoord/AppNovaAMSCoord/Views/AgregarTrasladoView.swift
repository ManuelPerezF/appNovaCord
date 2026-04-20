//
//  AgregarTrasladoView.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 12/11/25.
//

import SwiftUI

struct AgregarTrasladoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var idUser = 1
    @State private var NSocio: Int? = nil
    @State private var tipoTraslado: Int? = nil
    @State private var origen = ""
    @State private var destino = ""
    @State private var fecha = Date()
    @State private var hora = Date()
    @State private var ambulancia: String = ""
    @State private var operador: String = ""
    @State private var azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    @State private var showAlert = false
    @State private var canSave = false
    


    private func obtenerIdOperador(nombre: String) async -> Int? {
        if nombre == "sin asignar" || nombre == "Seleccionar Operador..." || nombre.isEmpty {
            return nil
        }
        
        // Buscar el operador por nombre usando la API
        do {
            let operadores = try await OperadoresAPI.shared.fetchOperadores()
            return operadores.first(where: { $0.nombre == nombre })?.id
        } catch {
            print("Error al obtener operadores: \(error)")
            return nil
        }
    }
    
    private func obtenerIdAmbulancia(ambulancia: String) -> Int? {
        if ambulancia == "sin asignar" || ambulancia == "Asignar Ambulancia" || ambulancia.isEmpty {
            return nil
        }
        if ambulancia.hasPrefix("AMB-") {
            let numeroString = String(ambulancia.dropFirst(4)) // Quitar "AMB-"
            return Int(numeroString)
        }
        return nil
    }
 

    
    let viajes = [
        1: "Sencillo",
        2: "Redondo"
    ]
    
    
    var body: some View {
            VStack(spacing: 0){
                TopBarComp(nameIcon: "pencil", nameTag: "Agregar Traslado")
                ZStack {
                    Color(red: 242/255, green: 242/255, blue: 242/255)
                        .ignoresSafeArea(edges: .bottom)
                    VStack(alignment: .leading, spacing: 0){
                        
                        intBox(title: "Número de socio", icon: "person.text.rectangle", num: $NSocio, color: azul)
                        
                        intPicker(title: "Tipo de traslado", icon: "cross.circle", num: $tipoTraslado, arr: viajes)
                            
                        textBox(title: "Dirección de origen", icon: "mappin", text: $origen, color: azul)
                        
                        textBox(title: "Dirección de destino", icon: "paperplane", text: $destino, color: Color(red: 255/255, green: 153/255, blue: 0/255))
                        
                        HStack(spacing: 0){
                            VStack(alignment: .leading, spacing: 0){
                                Text("Fecha")
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 5)
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(azul)
                                        .padding(.leading, 10)
                                        .imageScale(.large)
                                    DatePicker("", selection: $fecha, displayedComponents: .date)
                                        .labelsHidden()
                                        .padding(3)
                                }
                                .background(Color.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(azul, lineWidth: 1)
                                )
                            }
                            Spacer()
                            VStack(alignment: .leading, spacing: 0){
                                Text("Hora")
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                    .padding(.leading, 10)
                                    .padding(.bottom, 5)
                                HStack {
                                    Image(systemName: "clock")
                                        .foregroundColor(azul)
                                        .padding(.leading, 10)
                                        .imageScale(.large)
                                    DatePicker("", selection: $hora, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .padding(3)
                                }
                                .background(Color.white)
                                .cornerRadius(5)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(azul, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.bottom, 7)
                        
                        AmbulanciasPicker(selectedAmbulancia: $ambulancia)
                        OperadorPicker(selectedOperador: $operador)
                            .padding(.bottom, 40)
                        
                        
                        HStack(alignment: .center){
                        Button(action: {
                            Task{
                                
                                if (NSocio != nil && tipoTraslado != nil && origen != "" && destino != ""){
                                    do {
                                        // Crear un Calendar y componentes de fecha en la zona horaria local
                                        let calendar = Calendar.current
                                        
                                        // Extraer componentes de la fecha seleccionada
                                        let fechaComponents = calendar.dateComponents([.year, .month, .day], from: fecha)
                                        let horaComponents = calendar.dateComponents([.hour, .minute], from: hora)
                                        
                                        // Formatear fecha en formato YYYY-MM-DD
                                        let fechaString = String(format: "%04d-%02d-%02d",
                                                                fechaComponents.year ?? 2024,
                                                                fechaComponents.month ?? 1,
                                                                fechaComponents.day ?? 1)
                                        
                                        // Formatear hora en formato HH:mm:ss
                                        let horaString = String(format: "%02d:%02d:00",
                                                               horaComponents.hour ?? 0,
                                                               horaComponents.minute ?? 0)
                                            
                                            let idMedicoSolicita = await obtenerIdOperador(nombre: operador)
                                            
                                            let solicitud = TrasladoPost(
                                                IdAmbulancia: obtenerIdAmbulancia(ambulancia: ambulancia),
                                                IdPersonal: idUser,
                                                IdNumeroSocio: NSocio,
                                                FechaSolicitud: fechaString,
                                                HoraSolicitud: horaString,
                                                IdServicio: tipoTraslado,
                                                IdMedicoSolicita: idMedicoSolicita,
                                                Destino: destino,
                                                Origen: origen
                                            )
                                            try await postSolicitud(solicitud)
                                            print(solicitud)
                                            canSave = true
                                            showAlert = false
                                        } catch {
                                            print("Error al enviar sugerencia: \(error)")
                                            showAlert = true
                                            canSave = false
                                        }
                                    } else {
                                        showAlert = true
                                        canSave = false
                                    }
                                }
                            }){
                                Spacer()
                                Text("Crear Traslado")
                                
                                    .foregroundStyle(.white)
                                    .frame(height: 25)
                                Spacer()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(azul)
                            .alert("Por favor, llena todos los campos", isPresented: $showAlert){
                                Button("OK"){}
                            }
                            .alert("Tu solicitud se ha agregado con éxito", isPresented: $canSave){
                                Button("OK"){
                                    dismiss()
                                }
                            }

                        }
                        .padding(.bottom, 10)
                        
                        HStack(alignment: .center){
                            Button(action: { dismiss() }){
                                Spacer()
                                Text("Cancelar")
                                    .foregroundStyle(.gray)
                                    .frame(height: 25)
                                Spacer()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.white)
                            
                        }
                        
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        )
                        .padding(.bottom, 10)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }

        
    
    }
}

#Preview {
    AgregarTrasladoView()
}
