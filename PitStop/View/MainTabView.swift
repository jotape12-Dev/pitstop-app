//
//  MainTabView.swift
//  PitStop
//
//  Created by Jota Pe on 25/02/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View{
        TabView{
            GarageView()
                .tabItem{
                    Label("Garagem", systemImage: "motorcycle")
                }
            StatisticsView()
                .tabItem{
                    Label("Histórico", systemImage: "chart.bar.fill")
                }
        }
        .onAppear {
            NotificationManager.shared.requestPermission()
        }
    }
}
