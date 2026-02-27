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
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(DatabaseManager.shared.container)
    }
}
