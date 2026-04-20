import SwiftUI

struct DashboardView: View {

    @StateObject var vm = DashboardViewModel()
    @State private var nombreUsuario: String = ""
    @State private var add = false

    @State private var errorMessage: String? = nil
    @State private var isLoading: Bool = false


    var body: some View {
        VStack(spacing: 0) {

            TopBarComp()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Text(nombreUsuario)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    // grafica
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Información sobre los traslados de hoy")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        
                        PieChartView(
                            slices: [
                                PieChartSlice(label: "Activos", value: Double(vm.activos), color: PaletaTema.novaColors.NaranjaNova),
                                PieChartSlice(label: "Pendientes", value: Double(vm.pendientes), color: PaletaTema.novaColors.AzulNova),
                                PieChartSlice(label: "Completados", value: Double(vm.completados), color: PaletaTema.ProgressBar.GrayTitulo)
                            ]
                        )
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Agregar Traslado button
                    HStack{
                        Spacer()
                        VStack {
                            Text("Agregar Traslado")
                                .foregroundColor(.white)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.bottom, 7)
                            Button(action: {add = true}){
                                Text("+ Nuevo Traslado")
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                            }
                            .padding(.vertical, 7)
                            .padding(.horizontal, 90)
                            .background(Color(red: 255/255, green: 153/255, blue: 0/255))
                            .cornerRadius(8)
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(20)
                        .background(Color(red: 1/255, green: 104/255, blue: 138/255))
                        .cornerRadius(8)
                        .sheet(isPresented: $add) {
                            AgregarTrasladoView()
                                .toolbar(.hidden)
                        }
                        Spacer()
                    }

                    Text("Próximos traslados")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .padding(.top, 4)


                    VStack(alignment: .leading, spacing: 8) {

                        // cargando
                        if isLoading {
                            ProgressView("Cargando información…")
                                .padding(.top, 10)
                        }

                        // mensaje error para api aapagada
                        if let errorMessage = errorMessage {
                            VStack(spacing: 12) {

                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)

                                Button(action: {
                                    Task {
                                        await loadDashboardData()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Reintentar")
                                    }
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(Color(red: 1/255, green: 104/255, blue: 138/255))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                            
                        }


                        // lista
                        if !isLoading && errorMessage == nil {
                            ForEach(vm.proximos) { traslado in
                                ProximosTrasladosCard(
                                    ambulanciaId: traslado.ambulanciaId,
                                    operadorNombre: traslado.operadorAsignado,
                                    operadorId: traslado.idOperador,
                                    nombrePaciente: traslado.nombrePaciente,
                                    tipoServicio: traslado.tipoServicio,
                                    origen: traslado.direccionOrigen,
                                    destino: traslado.direccionDestino,
                                    hora: traslado.hora,
                                    fecha: traslado.fecha
                                )
                            }
                        }

                    }

                }
                .padding(.top, 8)
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        }

        .toolbar(.hidden)
        .onAppear {
            Task {
                await loadDashboardData()
            }

            if let nombre = UserDefaults.standard.string(forKey: "usuario") {
                nombreUsuario = nombre
            }
        }
    }


    // funcion para servidor apagado
    @MainActor
    func loadDashboardData() async {
        isLoading = true
        errorMessage = nil

        do {
            try await vm.fetchDashboard()
        } catch {
            errorMessage = "No se mantiene una conexión al servidor"
        }

        isLoading = false
    }
}


#Preview {
    DashboardView()
}
