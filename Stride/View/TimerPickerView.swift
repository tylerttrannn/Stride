//
//  TimerPicker.swift
//  Stride
//
//  Created by Tyler Tran on 2/7/26.
//

import SwiftUI

struct TimerPicker: View {
    @Binding var minutes: Int
    var color: Color = .blue
    
    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2
            
            ZStack {
                // background track
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 20)
                
                // active progress fill
                Circle()
                    .trim(from: 0, to: CGFloat(minutes) / 60.0)
                    .stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: minutes)
                
                // knob
                Circle()
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                    .frame(width: 32, height: 32)
                    .offset(y: -radius) // Move to top edge
                    .rotationEffect(.degrees(Double(minutes) * 6))
                
                VStack(spacing: 0) {
                    Text("\(minutes)")
                        .font(.system(size: 64, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())
                    Text("MIN")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            // Drag gesture logic
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let vector = CGVector(dx: value.location.x - center.x, dy: value.location.y - center.y)
                        
                        var angle = atan2(vector.dy, vector.dx) + .pi / 2
                        if angle < 0 { angle += 2 * .pi }
                        
                        let progress = angle / (2 * .pi)
                        let newMinutes = Int(round(progress * 60))
                        
                        if newMinutes == 60 { self.minutes = 0 }
                        else { self.minutes = min(max(newMinutes, 0), 59) }
                    }
            )
        }
        .frame(width: 250, height: 250) 
    }
}
