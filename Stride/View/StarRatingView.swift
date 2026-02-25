import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    var maxRating = 5
        
    var body: some View {
        HStack {
            ForEach(1...maxRating, id: \.self) { number in
                Image(systemName: number <= rating ? "star.fill" : "star")
                    .foregroundColor(Color(red: 0.0, green: 0.0, blue: 0.058823529411764705))
                    .opacity(0.75)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var rating = 2
        
    VStack(spacing: 20) {
        StarRatingView(rating: $rating)
    }
    .padding()
}
