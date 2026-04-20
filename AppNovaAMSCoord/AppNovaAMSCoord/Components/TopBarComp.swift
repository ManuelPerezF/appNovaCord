//
//  TopBarComp.swift
//  LogInTry
//
//  Created by Natalia Cavazos on 14/10/25.
//

import SwiftUI

struct TopBarComp: View {
    @State public var nameIcon = "cross.case"
    @State public var nameTag = "Dashboard"
    
    
    var body: some View {
        
        VStack{
            HStack{
                Image(systemName: nameIcon)
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.white)
                    .frame(width: 25, height: 25)
                    .padding( 10)
                    .background(Color(red: 1/255, green: 104/255, blue: 138/255))
                    .bold(true)
                    .cornerRadius(7)
                VStack(alignment: .leading){
                    Text(nameTag)
                        .font(.title)
                    Text("Hospital Clínica Nova")
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .padding(.bottom, -10)
            Divider()

        }
        .padding(.leading, 10)
        
            
        
    }
}

#Preview {
    TopBarComp()
}
