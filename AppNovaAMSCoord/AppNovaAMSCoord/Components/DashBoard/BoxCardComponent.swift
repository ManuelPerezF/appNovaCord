//
//  BoxCardComponent.swift
//  dashboardNovaAMS
//
//  Created by FernandoHernandez on 13/10/25.
//
import SwiftUI

struct BoxCardComponent: View {
    var title: String
    var value: String
    var cardBg: Color = .white
    var iconFg: Color = .gray
    var iconBadgeBg: Color = .gray.opacity(0.15)
    var systemIcon: String? = nil
    var assetIcon: String? = nil
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                
                Text(value)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.black)
            }
            
            Spacer(minLength: 0) // icono hacia la derecha
            
            if systemIcon != nil || assetIcon != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(iconBadgeBg)
                        .frame(width: 40, height: 40)
                    
                    if let name = systemIcon {
                        Image(systemName: name)
                            .foregroundColor(iconFg)
                            .font(.system(size: 20, weight: .semibold))
                    } else if let name = assetIcon {
                        Image(name)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(iconFg)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBg)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
        )
    }
}
