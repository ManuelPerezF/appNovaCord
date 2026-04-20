//
//  PieChartView.swift
//  AppNovaAMSOp
//
//  Created by Alumno on 28/11/25.
//

import SwiftUI

struct PieChartSlice {
    let label: String
    let value: Double
    let color: Color
}

struct PieChartView: View {

    let slices: [PieChartSlice]

    var total: Double {
        slices.map { $0.value }.reduce(0, +)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            HStack(alignment: .center, spacing: 24) {

                // Grafica
                ZStack {
                    ForEach(0..<slices.count, id: \.self) { i in
                        let startAngle = angle(at: i)
                        let endAngle = angle(at: i + 1)

                        PieChartShape(startAngle: startAngle, endAngle: endAngle)
                            .fill(slices[i].color)
                    }
                }
                .frame(width: 140, height: 140)
                .padding(.leading, 4)

                // indicadores
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(slices, id: \.label) { slice in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(slice.color)
                                .frame(width: 11, height: 11)

                            Text("\(slice.label): \(Int(slice.value))")
                                .font(.system(size: 11))
                                .foregroundColor(.black)
                                    

                        }
                    }
                }

                Spacer()
            }
        }
        .padding(25)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        )
        .padding(.horizontal, 2)
    }

    private func angle(at index: Int) -> Angle {
        let sum = slices.prefix(index).map { $0.value }.reduce(0, +)
        return .degrees((sum / total) * 360)
    }
}

struct PieChartShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)

        path.addArc(
            center: center,
            radius: rect.width / 2,
            startAngle: startAngle - .degrees(90),
            endAngle: endAngle - .degrees(90),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}
