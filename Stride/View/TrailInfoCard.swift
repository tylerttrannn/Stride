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

struct TrailInfoCard: View {
    var trail: Trail
    @State var textHeight: CGFloat = 0
    @ObservedObject var ratingsVM: RatingViewModel
    
    let screenSize: CGRect = UIScreen.main.bounds

    var body: some View {
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.9647058823529412, green: 0.9647058823529412, blue: 0.9647058823529412)) // #f6f6f6
                .frame(height: textHeight)
            
            // Trail Information
            VStack(alignment: .leading) {
                Text(trail.name)
                    .font(Font.system(size: 32, design: .serif))
                Divider()
                // Trail Additional Info
                VStack(alignment: .leading) {
                    let trail_distance_from_user_miles = trail.distance_from_user / 1609.344
                    Text("\(trail_distance_from_user_miles, specifier: "%.2f") mi away")
                    Text("Approx. \(trail.estimated_steps, specifier: "%.0f") steps")
                    Text("Length: \(trail.length_miles, specifier: "%.2f") miles")
                    if let difficulty = trail.difficulty {
                        Text("Diffculty: \(String(difficulty))/5")
                    }
                    StarRatingView(
                        rating: Binding(
                            get: {ratingsVM.ratings[trail.id] ?? 0 },
                            set: { newValue in
                                ratingsVM.ratings[trail.id] = newValue
                                Task {
                                    await ratingsVM.updateRating(for: trail.id, rating: newValue)
                                }
                            }
                        )
                    )
                    .padding(.top, 1)
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
//    Group {
//        TrailInfoCard(trail: trails[0])
//        TrailInfoCard(trail: trails[1])
//    }
    Text("Trail Card Info")
}
