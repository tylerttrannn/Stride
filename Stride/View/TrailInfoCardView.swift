//
//  TrailInfoCardView.swift
//  Stride
//
//  Created by Kathy Lo on 1/26/26.
//
import SwiftUI

struct ContentLengthPreference: PreferenceKey {
   static var defaultValue: CGFloat { 0 }
   
   static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      value = nextValue()
   }
}

struct TrailInfoCardView: View {
    @State var textHeight: CGFloat = 0

    let screenSize: CGRect = UIScreen.main.bounds
    let trailName: String
    let trailDistanceFromUser: Double
    let trailDifficulty: Int // [0...5]
    let trailLength: Double
    let trailSteps: Int
    
    init(trailName: String, trailDistanceFromUser: Double, trailDifficulty: Int, trailLength: Double, trailSteps: Int) {
        self.trailName = trailName
        self.trailDistanceFromUser = trailDistanceFromUser
        self.trailDifficulty = trailDifficulty
        self.trailLength = trailLength
        self.trailSteps = trailSteps
    }

    var body: some View {
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412)) // #f6f6f6
                .frame(height: textHeight)
            
            // Trail Information
            VStack(alignment: .leading) {
                Text(self.trailName)
                    .font(Font.system(size: 42, design: .serif))
                Divider()
                // Trail Additional Info
                VStack(alignment: .leading) {
                    Text("\(self.trailDistanceFromUser, specifier: "%.1f") mi away")
                    Text("Approx. \(self.trailSteps) steps")
                    Text("Length: \(self.trailLength, specifier: "%.1f") miles")
                    Text("Diffculty: \(self.trailDifficulty)/5")
                }
                .font(Font.system(size: 16, design: .serif))
                .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.058823529411764705)) // #00000f
                .opacity(0.75)
            }
            .overlay(
                GeometryReader { proxy in
                    Color
                        .clear
                        .preference(key: ContentLengthPreference.self,
                                    value: proxy.size.height)
                }
            )
            .padding(16)
            
        }
        // Dynamic info card sizing based on height of text content
        .onPreferenceChange(ContentLengthPreference.self) { value in
            DispatchQueue.main.async {
                self.textHeight = value + 48
            }
        }
        .padding(16)
    }
}

#Preview {
    VStack (alignment: .leading) {
        ForEach(1...1, id: \.self) { i in
            TrailInfoCardView(
                trailName: "Trail \(i)",
                trailDistanceFromUser: 10,
                trailDifficulty: i,
                trailLength: 1.2,
                trailSteps: 2200
            )
        }
        Spacer() // Pushes rest of the stack content to the top!
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)

}
