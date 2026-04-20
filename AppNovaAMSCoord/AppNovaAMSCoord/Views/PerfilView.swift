import SwiftUI

struct PerfilView: View {
    @State var username: String = ""
    
    @State private var totalNotificationsCount: Int = 0
    @State private var isLoadingNotifications: Bool = false
    
    func loadPerfil() async {
        do {
            _ = try await fetchPerfil(matricula: username)

        } catch {
            print("Error cargando perfil:", error)
        }
    }
    

    func loadNotificationCounts() async {
        isLoadingNotifications = true
        

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        
        async let notificacionesTask = try? await NotificacionesAPI.shared.fetchNotificaciones(fecha: todayString)
        async let sugerenciasTask = try? await NotificacionesAPI.shared.fetchSugerencias(fecha: todayString)
        async let reportesTask = try? await NotificacionesAPI.shared.fetchReportesFalla(fecha: todayString)
        
        let notificaciones = await notificacionesTask ?? []
        let sugerencias = await sugerenciasTask ?? []
        let reportes = await reportesTask ?? []
        
        totalNotificationsCount = notificaciones.count + sugerencias.count + reportes.count
        
        isLoadingNotifications = false
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                
                TopBarComp(nameIcon: "person.circle", nameTag: "Perfil")
                
                ZStack {
                    Color(red: 242/255, green: 242/255, blue: 242/255)
                        .ignoresSafeArea(edges: .bottom)
                    
                    
                    VStack(spacing:20) {
                        
                        PerfilCard(name: username , description: "Coordinador", avatarColor: Color(red: 50/255, green: 130/255, blue: 160/255))
                           
                          
                        ButtonCard(
                            textImage: "bell",
                            textTitle: "Notificaciones",
                            textButton: isLoadingNotifications
                                ? "Cargando notificaciones..."
                                : totalNotificationsCount == 0
                                    ? "No hay notificaciones hoy"
                                    : totalNotificationsCount == 1
                                        ? "Tienes 1 notificación hoy"
                                        : "Tienes \(totalNotificationsCount) notificaciones hoy",
                            destination: AnyView(NotificacionesView())
                        )
                   
                        
                        ButtonCard(
                            textImage: "person",
                            textTitle: "Historial de operadores",
                            textButton: "Ver historial de los operadores",
                            destination: AnyView(historialOperadores())
                        )
                     
                        CerrarSesion()
                    }
                }
            }
            .onAppear {
                if (UserDefaults.standard.string(forKey: "usuario") != nil ){
                    username = UserDefaults.standard.string(forKey: "usuario")!
                    Task { await loadPerfil() }
                }
                Task { await loadNotificationCounts() }
            }

        }
       
    }
}

#Preview {
    PerfilView()
}
