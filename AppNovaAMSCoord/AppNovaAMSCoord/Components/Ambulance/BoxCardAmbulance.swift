//
//  BoxCardAmbulance.swift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 06/11/25.
//

import SwiftUI

struct BoxCardAmbulance: View {
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
                
                HStack
                {
                    Text(value)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.black)
                    Spacer()
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

            }
            
            Spacer(minLength: 0) // icono hacia la derecha

        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBg)
        )
    }
}

#Preview {
    BoxCardAmbulance(
        title: "Disponibles",
        value: "3",
        cardBg: Color.white.opacity(0.8),
        iconFg: .gray,
        iconBadgeBg: .green.opacity(0.15),
        systemIcon: "clock.arrow.trianglehead.counterclockwise.rotate.90"
    )
}
