//
//  DetalleView.swift
//  MultiplesPantallas
//
//  Created by Natalia Cavazos on 06/10/25.
//

import SwiftUI

struct InicioView: View {
    // @Environment(\.dismiss) private var dismiss
    @Binding public var user: String
    @Binding public var password: String
    
    var body: some View {
        VStack{
            TopBarComp()
            Spacer()
            Text("Bienvenido \(user)")
            Spacer()
            
            
            
            
            
            
            
        }
        .toolbar(.hidden)
    }
        
}

#Preview {
    InicioView(user: .constant(""), password: .constant(""))
}
