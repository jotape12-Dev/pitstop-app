//
//  PitStopApp.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import SwiftUI
import SwiftData

@main
struct PitStopApp: App {
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .modelContainer(for: Motorcycle.self)
    }
}
