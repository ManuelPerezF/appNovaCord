//
//  AppNovaAMSCoordApp.swift
//  AppNovaAMSCoord
//
//  Created by FernandoHernandez on 23/10/25.
//

import SwiftUI

@main
struct AppNovaAMSCoordApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else{
                LoginView()
            }
                
        }
    }
}
