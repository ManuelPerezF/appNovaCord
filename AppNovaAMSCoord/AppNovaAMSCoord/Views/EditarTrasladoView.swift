//
//  EditarTrasladoView.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 27/11/25.
//

import SwiftUI

struct EditarTrasladoView: View {
    
    @Environment(\.dismiss) var dismiss
    
    // Traslado a editar
    let traslado: TrasladoPendiente?
    
    @State public var idUser = 1
    @State public var NSocio: Int? = nil
    @State public var tipoTraslado: Int? = nil
    @State public var origen = ""
    @State public var destino = ""
    @State public var fecha = Date()
    @State public var hora = Date()
    @State private var ambulancia: String = ""
    @State private var operador: String = ""
    @State private var azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    @State private var showAlert = false
    @State private var canSave = false
    @State private var cancelAlert = false
    
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
            let numeroString = String(ambulancia.dropFirst(4)) 
            return Int(numeroString)
        }
        return nil
    }
    
    // Cargar datos del traslado si existe
    private func cargarDatosTraslado() {
        guard let traslado = traslado else { return }
        
        NSocio = traslado.idNumeroSocio
        tipoTraslado = traslado.idServicio
        origen = traslado.origen
        destino = traslado.destino
        
        // Convertir la fecha del traslado
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let fechaDate = dateFormatter.date(from: traslado.fechaSolicitud) {
            fecha = fechaDate
        }
        
        // Convertir la hora del traslado
        if let horaSolicitud = traslado.horaSolicitud {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            if let horaDate = timeFormatter.date(from: horaSolicitud) {
                hora = horaDate
            }
        }
        
        // Cargar ambulancia
        if let idAmbulancia = traslado.idAmbulancia {
            ambulancia = "AMB-\(String(format: "%02d", idAmbulancia))"
        } else {
            ambulancia = "sin asignar"
        }
        
        // Cargar operador (necesitarías obtenerlo de la API)
        operador = traslado.idPersonal != nil ? "Operador asignado" : "sin asignar"
    }

    
    let viajes = [
        1: "Sencillo",
        2: "Redondo"
    ]
    
    // Inicializador
    init(traslado: TrasladoPendiente? = nil) {
        self.traslado = traslado
    }
    

    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                TopBarComp(nameIcon: "pencil", nameTag: "Editar Traslado")
                ZStack {
                    Color(red: 242/255, green: 242/255, blue: 242/255)
                        .ignoresSafeArea(edges: .bottom)
                    VStack(alignment: .leading, spacing: 0){
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Número de socio")
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .padding(.leading, 10)
                                .padding(.bottom, 5)
                            HStack {
                                Image(systemName: "person.text.rectangle")
                                    .foregroundColor(azul)
                                    .padding(.leading, 10)
                                    .imageScale(.large)
                                Text(NSocio != nil ? "\(NSocio!)" : "Sin asignar")
                                    .padding(8)
                                Spacer()
                            }
                            .background(Color(red: 211/255, green: 211/255, blue: 211/255))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(azul, lineWidth: 1)
                            )
                            .padding(.bottom, 7)
                        }
                        
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
                                    if (NSocio != nil && tipoTraslado != nil && !origen.isEmpty && !destino.isEmpty){
                                        canSave = true
                                        showAlert = false
                                    }
                                    else {
                                        showAlert = true
                                        canSave = false
                                    }
                                }
                            }){
                                Spacer()
                                Text("Guardar Cambios")
                                    .foregroundStyle(.white)
                                    .frame(height: 25)
                                Spacer()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(azul)
                            .alert("Por favor, llena todos los campos", isPresented: $showAlert){
                                Button("OK"){}
                            }
                            .alert("Los cambios se han guardado con éxito", isPresented: $canSave){
                                Button("OK"){
                                    dismiss()
                                }
                            }
                        }
                        .padding(.bottom, 10)
                        
                        HStack(alignment: .center){
                            Button(action: { cancelAlert = true }){
                                Spacer()
                                Text("Cancelar Traslado")
                                    .foregroundStyle(.white)
                                    .frame(height: 25)
                                Spacer()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(red: 182/255, green: 13/255, blue: 13/255))
                            
                        }
                        .alert("¿Estás segur@ de cancelar el traslado?", isPresented: $cancelAlert){
                            Button("Cancelar Traslado", role: .destructive){
                                dismiss()
                            }
                            Button("Atrás", role: .cancel) {}
                        } message: {
                            Text("El traslado será eliminado y no se podrá recuperar")
                        }
                        .padding(.bottom, 10)
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
            }
        }
        .onAppear {
    
            cargarDatosTraslado()
        }
        
    
    }
}

#Preview {
    EditarTrasladoView()
}
