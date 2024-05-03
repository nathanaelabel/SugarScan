//
//  ProgressBar.swift
//  SugarScan
//
//  Created by Nathanael Abel on 02/05/24.
//

import SwiftUI

struct CircularProgressBar: View {
    var progress: Float
    var total: Double
    
    private var percentage: CGFloat {
        return CGFloat(progress / Float(total))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: percentage)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(percentageColor))
                .rotationEffect(Angle(degrees: 270))
                .animation(.linear, value: percentage)
            
            Text("\(Int(progress))/\(Int(total))g")
                .font(.title2)
                .bold()
        }
    }
    
    private var percentageColor: Color {
        switch percentage {
        case 0..<0.5:
            return .green
        case 0.5..<0.9:
            return .yellow
        default:
            return .red
        }
    }
}
