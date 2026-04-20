//
//  ContentView.swift
//  LogInTry
//
//  Created by Natalia Cavazos on 13/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var colorPrincipal = (Color(red: 1/255, green: 104/255, blue: 138/255))
    @State var username: String = ""
    
    
    var body: some View {
        VStack{
            TabView{
                DashboardView()
                    .tabItem{
                        Image(systemName: "house")
                            .tint(.gray)
                        Text("Inicio")
                    }
                AmbulanciasView()
                    .tabItem {
                        Image("ambulance")
                            .renderingMode(.template)
        
                        Text("Ambulancias")
                    }
                
                AgendaView()
                    .tabItem{
                        Image(systemName: "calendar")
                        Text("Agenda")
                    }
                 
                PerfilView()
                    .tabItem{
                        Image(systemName: "person")
                        Text("Perfil")
                    }
                
            }
            .tint(colorPrincipal)
            
        }
        .onAppear(){
            if (UserDefaults.standard.string(forKey: "usuario") != nil ){
                username = UserDefaults.standard.string(forKey: "usuario")!
                
            }
        }
    }
}

#Preview {
    ContentView()
}
