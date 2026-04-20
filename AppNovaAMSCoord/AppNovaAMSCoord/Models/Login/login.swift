//
//  login.swift
//  AppNovaAMSOp
//
//  Created by Manuel Antonio Perez Fonseca on 14/11/25.
//

import Foundation

struct LoginData: Codable {
    let IdTipoPersonal: Int
    let Matricula: String
}

struct LoginResponse: Codable {
    let data: LoginData?
    let message: String
    let success: Bool
    let token: String?
}
