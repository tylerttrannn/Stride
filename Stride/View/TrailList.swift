//
//  TrailList.swift
//  Stride
//
//  Created by Kathy Lo on 1/29/26.
//

import SwiftUI

struct TrailList: View {
    let screenSize: CGRect = UIScreen.main.bounds

    var body: some View {
        ScrollView {
            VStack {
                List(trails) {
                    trail in TrailInfoCard(trail: trail)
                }.frame(minHeight: screenSize.height*0.9).border(Color.red)
            }
        }
    }
}

#Preview {
    TrailList()
}
