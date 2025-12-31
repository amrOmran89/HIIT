//
//  SettingsView.swift
//  HIIT
//
//  Created by Amr Omran on 15.12.25.
//

import SwiftUI

struct SettingsView: View {
 
    @Binding var workTime: Int
    @Binding var restTime: Int
    var onSettingsChanged: () -> Void
   
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper("Work Time: \(workTime)s", value: $workTime, in: 5...300, step: 5)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .onChange(of: workTime) { _, _ in
                            onSettingsChanged()
                        }
                } header: {
                    Text("Work Duration")
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Section {
                    Stepper("Rest Time: \(restTime)s", value: $restTime, in: 5...300, step: 5)
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .onChange(of: restTime) { _, _ in
                            onSettingsChanged()
                        }
                } header: {
                    Text("Rest Duration")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

