//
//  CountdownView.swift
//  HIIT
//
//  Created by Amr Omran on 15.12.25.
//

import SwiftUI
import AudioToolbox

struct CountdownView: View {
   
    @Environment(\.dismiss) private var dismiss
    @State private var count = 3
    let onFinished: () -> Void
    
    private var textColor: Color {
        switch count {
        case 3:
            return .yellow
        case 2:
            return .orange
        case 1:
            return .red
        case 0:
            return .green
        default:
            return .white
        }
    }
    
    private var backgroundColors: [Color] {
        switch count {
        case 3:
            [Color.blue, Color.purple]
        case 2:
            [Color.orange, Color.red]
        case 1:
            [Color.red, Color.black]
        case 0:
            [Color.green, Color.mint]
        default:
            [Color.black, Color.gray]
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.6), value: count)
            
            Text(count == 0 ? "GO!" : "\(count)")
                .font(.system(size: 120, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
                .scaleEffect(count == 0 ? 1.2 : 1.0)
                .opacity(1)
                .animation(.spring(response: 0.45, dampingFraction: 0.7), value: count)
        }
        .onAppear {
            startCountdown()
        }
    }
    
    private func startCountdown() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in            
            if count > 0 {
                count -= 1
            } else {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    dismiss()
                    onFinished()
                }
            }
        }
    }
}

#Preview {
    CountdownView(onFinished: {})
}
