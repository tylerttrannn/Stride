//
//  ProgressBarView.swift
//  Stride
//
//  Created by Kathy Lo on 1/26/26.
//
import SwiftUI

struct ProgressBarView: View {
    var stepsCount: Int
    var stepsGoal: Int
    var progress: Double
    
    let lineWidth: CGFloat = 25

    let progressColor: Color = .blue.opacity(0.5)
    let trackColor: Color = .blue.opacity(0.25)
    
    init(stepsCount: Int, stepsGoal: Int) {
        self.stepsCount = stepsCount
        self.stepsGoal = stepsGoal
        self.progress = Double(stepsCount) / Double(stepsGoal)
    }
    
    var body: some View {
        ZStack (alignment: .leading) {
            // Tracker Circle
            
            Circle()
                .stroke(
                    self.trackColor,
                    style: StrokeStyle(lineWidth: lineWidth)
                )
            
            // Steps Progress Circle
            ZStack (alignment: .center){
                // Steps Progress Information
                VStack (alignment: .center){
                    Text(String(self.stepsCount))
                        .font(Font.system(size: 72, design: .serif))
                        .fontWeight(Font.Weight.bold)
                    Text("Goal: \(self.stepsGoal) steps")
                        .font(Font.system(size:14, design: .serif))
                        .foregroundStyle(.gray)
                    Text(String(format: "%.0f", self.progress*100) + "% Completed")
                        .font(Font.system(size:14, design: .serif))
                        .foregroundStyle(.gray)
                }
                Circle()
                    .trim(from: 0, to: self.progress)
                    .stroke(
                        self.progressColor,
                        style: StrokeStyle(
                            lineWidth: self.lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 10), value: self.progress)
            }

        }
        .frame(width: 300, height: 300)

    }
}

#Preview {
    ProgressBarView(stepsCount: 100, stepsGoal: 500)
}
