//
//  ScoreView.swift
//  smart-notification-swift
//
//  Created by 신동규 on 9/14/25.
//

import SwiftUI

struct ScoreView: View {
    let score: Int
    
    var body: some View {
        Text("\(score > 0 ? "+" : "")\(score)")
            .font(.caption.bold())
            .foregroundColor(scoreColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(scoreColor.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var scoreColor: Color {
        if score > 0 {
            return .green
        } else if score < 0 {
            return .red
        } else {
            return .gray
        }
    }
}
