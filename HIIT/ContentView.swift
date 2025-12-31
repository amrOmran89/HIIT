//
//  ContentView.swift
//  HIIT
//
//  Created by Amr Omran on 15.12.25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var workTime = 20
    @State private var restTime = 10
    @State private var timeRemaining = 20
    @State private var isActive = false
    @State private var timer: Timer?
    @State private var isResting = false
    @State private var totalWorkoutDuration = 0
    @State private var cyclesCompleted = 0
    
    @State private var showSettingsSheet = false
    @State private var showCountDownSheet = false
    
    var currentTotalTime: Int {
        isResting ? restTime : workTime
    }
    
    var progress: Double {
        Double(timeRemaining) / Double(currentTotalTime)
    }
    
    var formattedTotalDuration: String {
        let minutes = totalWorkoutDuration / 60
        let seconds = totalWorkoutDuration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 40) {

                    Text(isResting ? "REST TIME" : "WORK TIME")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(isResting ? .orange : .white)
                        .animation(.easeInOut, value: isResting)
                    
                    ZStack {
                        // Background circle
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                            .frame(width: 250, height: 250)
                        
                        // Progress circle
                        Circle()
                            .trim(from: 0, to: progress)
                            .stroke(
                                isResting ? Color.orange : (isActive ? Color.green : Color.blue),
                                style: StrokeStyle(lineWidth: 20, lineCap: .round)
                            )
                            .frame(width: 250, height: 250)
                            .rotationEffect(.degrees(-90))
                            .animation(.linear(duration: 0.1), value: progress)
                        
                        // Countdown text
                        Text("\(timeRemaining)")
                            .font(.system(size: 100, weight: .bold))
                            .italic()
                            .foregroundStyle(.white)
                        
                    }
                    
                    Button {
                        if totalWorkoutDuration > 0 {
                            toggleTimer()
                        } else {
                            showCountDownSheet.toggle()
                        }
                    } label: {
                        Text(isActive ? "STOP" : "START")
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 60)
                            .background(isActive ? Color.red : Color.green)
                            .cornerRadius(30)
                    }

                    
                    // Reset button
                    Button(action: resetTimer) {
                        Text("RESET")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    // Total duration display
                    if isActive || totalWorkoutDuration > 0 {
                        HStack {
                            VStack(spacing: 8) {
                                Text("Total Duration")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.gray)
                                Text(formattedTotalDuration)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .transition(.opacity)
                            
                            VStack(spacing: 8) {
                                Text("Cycles")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    .foregroundColor(.gray)
                                Text(cyclesCompleted, format: .number)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                            }
                            .transition(.opacity)
                        }

                    } else {
                        VStack { }
                    }
                }
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(workTime: $workTime, restTime: $restTime) {
                    // Update timeRemaining if timer is not active
                    if !isActive {
                        timeRemaining = isResting ? restTime : workTime
                    }
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $showCountDownSheet) {
                CountdownView {
                    toggleTimer()
                }
            }
        }
    }
    
    func toggleTimer() {
        isActive.toggle()
        
        if isActive {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            totalWorkoutDuration += 1
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Switch between work and rest continuously
                if !isResting {
                    isResting = true
                    timeRemaining = restTime
                } else {
                    isResting = false
                    timeRemaining = workTime
                    cyclesCompleted += 1  // Increment cycle when rest period ends
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func resetTimer() {
        stopTimer()
        isActive = false
        isResting = false
        timeRemaining = workTime
        totalWorkoutDuration = 0
        cyclesCompleted = 0
    }
}

#Preview {
    ContentView()
}
