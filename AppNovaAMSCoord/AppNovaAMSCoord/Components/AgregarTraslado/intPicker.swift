//
//  intPicker.swift
//  AppNovaAMSCoord
//
//  Created by Alumno on 15/11/25.
//

import SwiftUI

struct intPicker: View {
    
    @State public var title: String
    @State public var icon: String
    @Binding public var num: Int?
    @State private var nums: [Int] = [1, 2]
    @State public var arr: [Int:String] = [:]
    
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
                    Picker("", selection: $num){
                        ForEach(nums, id: \.self) {
                            item in Text(arr[item] ?? "\(item)").tag(item)
                        }
                    }
                } label: {
                    Text(num == nil ? "Seleccionar..." : "\(num!)")
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
