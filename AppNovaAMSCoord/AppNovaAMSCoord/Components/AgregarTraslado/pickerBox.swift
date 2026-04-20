//
//  pickerBox.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 13/11/25.
//

import SwiftUI

struct pickerBox: View {
    
    @State public var title: String
    @State public var icon: String
    @Binding public var text: String
    @State public var arr: [String] = []
    
    @State public var azul = Color(red: 1/255, green: 104/255, blue: 138/255)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .padding(.leading, 10)
                .padding(.bottom, 5)
            HStack {
                Image(systemName: icon)
                    .foregroundColor(azul)
                    .padding(.leading, 10)
                    .imageScale(.large)
                Menu {
                    Picker("", selection: $text){
                        ForEach(arr, id: \.self) {
                            item in Text(item)
                        }
                    }
                } label: {
                    Text(text)
                }
                .padding(9)
                .tint(.black)
                Spacer()
            }
            .background(Color.white)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(azul, lineWidth: 1)
            )
            .padding(.bottom, 7)
        }
    }
}
