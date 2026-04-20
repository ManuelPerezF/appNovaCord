//
//  NotificacionesView.swift
//  AppNovaAMSOp
//
//  Created by FernandoHernandez on 27/11/25.
//

import SwiftUI

struct NotificacionesView: View {

    @State private var selectedDate = Date()
    @State private var notificaciones: [Notificacion] = []
    @State private var sugerencias: [Sugerencia] = []
    @State private var reportes: [ReporteFalla] = []
    @State private var isLoading = false
    
    @Environment(\.dismiss) private var dismiss
    
    private var bgGray: Color { Color(red: 242/255, green: 242/255, blue: 242/255) }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var trasladosEnCurso: [Notificacion] {
        notificaciones.filter { $0.estatusAgenda.lowercased() == "activo" || $0.estatusAgenda.lowercased() == "en proceso" }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBarComp(nameIcon: "bell", nameTag: "Notificaciones")
            
            VStack {
                HStack(spacing: 12) {
                    Spacer()
                    
                    Text("Fecha")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.gray)
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .labelsHidden()
                        .frame(width: 100)
                        .onChange(of: selectedDate) { _, _ in
                            Task { await loadData() }
                        }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }

            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                    } else {
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "car.fill")
                                    .foregroundColor(Color(red: 3/255, green: 104/255, blue: 138/255))
                                Text("Traslados en Curso")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(trasladosEnCurso.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            if trasladosEnCurso.isEmpty {
                                Text("No hay traslados en curso para esta fecha")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ForEach(trasladosEnCurso) { notif in
                                    NotificacioneCard(
                                        nombrePaciente: notif.nombrePaciente,
                                        ambulanciaId: notif.ambulanciaId,
                                        statusColor: notif.statusColor,
                                        tipoServicio: notif.tipoServicio,
                                        operadorAsignado: notif.operadorAsignado,
                                        destino: notif.destino,
                                        hora: notif.hora,
                                        direccionOrigen: notif.direccionOrigen,
                                        direccionDestino: notif.direccionDestino
                                    )
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text("Sugerencias")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(sugerencias.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            if sugerencias.isEmpty {
                                Text("No hay sugerencias disponibles")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ForEach(sugerencias) { sug in
                                    SugerenciaCard(
                                        nombreSolicitante: sug.nombreSolicitante,
                                        tipoPersonal: sug.tipoPersonal,
                                        titulo: sug.titulo,
                                        nombreCategoria: sug.nombreCategoria,
                                        detalles: sug.detalles
                                    )
                                }
                            }
                        }
                        
                        Divider()
                            .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.orange)
                                Text("Reportes de Falla")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                                Text("\(reportes.count)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            if reportes.isEmpty {
                                Text("No hay reportes de falla disponibles")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ForEach(reportes) { rep in
                                    ReporteFallaCard(
                                        ambulanciaId: rep.ambulanciaId,
                                        tipoAmbulancia: rep.tipoAmbulancia,
                                        nivelUrgencia: rep.nivelUrgencia,
                                        tipoFalla: rep.tipoFalla,
                                        descripcion: rep.descripcion,
                                        nombreReportante: rep.nombreReportante,
                                        tipoPersonal: rep.tipoPersonal,
                                        estatus: rep.estatus
                                    )
                                }
                            }
                        }
                        
                        if trasladosEnCurso.isEmpty && sugerencias.isEmpty && reportes.isEmpty {
                            VStack(spacing: 8) {
                                Image(systemName: "calendar.badge.exclamationmark")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("No hay datos disponibles")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Fecha: \(dateFormatter.string(from: selectedDate))")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                        }
                    }
                }
                .padding(.vertical, 16)
            }
            .background(bgGray)
        }
        .background(bgGray)

        .navigationBarBackButtonHidden(true)
        .toolbar {

            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Regresar")
                            .font(.system(size: 17))
                    }

                    .foregroundColor(Color(red: 50/255, green: 130/255, blue: 160/255))
                }
            }
        }
        .task { await loadData() }
    }
    
    // Carga de datos desde API
    private func loadData() async {
        isLoading = true
        
        let fechaString = dateFormatter.string(from: selectedDate)
        
        // Llamadas paralelas a API
        async let notifTask = try? await NotificacionesAPI.shared.fetchNotificaciones(fecha: fechaString)
        async let sugTask = try? await NotificacionesAPI.shared.fetchSugerencias(fecha: fechaString)
        async let repTask = try? await NotificacionesAPI.shared.fetchReportesFalla(fecha: fechaString)
        
        notificaciones = await notifTask ?? []
        sugerencias = await sugTask ?? []
        reportes = await repTask ?? []
        
        isLoading = false
    }
}

#Preview {
    NotificacionesView()
}
