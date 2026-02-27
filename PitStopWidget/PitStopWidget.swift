//
//  PitStopWidget.swift
//  PitStopWidget
//
//  Created by Jota Pe on 26/02/26.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> PitStopEntry {
        PitStopEntry(date: Date(), motoName: "Minha Moto", mileage: 15000, nextMaintenance: "Óleo", remainingKM: 200)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (PitStopEntry) -> ()) {
        let entry = PitStopEntry(date: Date(), motoName: "Fazer 250", mileage: 15000, nextMaintenance: "Óleo", remainingKM: 200)
        completion(entry)
    }

    @MainActor
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entry: PitStopEntry
        
        do {
            let container = DatabaseManager.shared.container
            let motos = try container.mainContext.fetch(FetchDescriptor<Motorcycle>())
            
            if let moto = motos.first {
                let urgente = moto.maintenanceItems.min(by: { $0.mileageRemaining < $1.mileageRemaining })
                
                entry = PitStopEntry(
                    date: Date(),
                    motoName: moto.name,
                    mileage: moto.currentMileage,
                    nextMaintenance: urgente?.title ?? "Tudo OK",
                    remainingKM: urgente?.mileageRemaining ?? 0
                )
            } else {
                entry = PitStopEntry(date: Date(), motoName: "Garagem Vazia", mileage: 0, nextMaintenance: "-", remainingKM: 0)
            }
        } catch {
            entry = PitStopEntry(date: Date(), motoName: "Erro de Dados", mileage: 0, nextMaintenance: "-", remainingKM: 0)
        }
        
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
struct PitStopEntry: TimelineEntry {
    let date: Date
    let motoName: String
    let mileage: Int
    let nextMaintenance: String
    let remainingKM: Int
}
struct PitStopWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "motorcycle")
                    .foregroundColor(.accentColor)
                Text(entry.motoName)
                    .font(.headline)
                    .lineLimit(1)
            }
            
            Text("\(entry.mileage) km")
                .font(.title2)
                .fontWeight(.bold)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("Próxima revisão:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text(entry.nextMaintenance)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    Spacer()
                    
                    if entry.nextMaintenance != "-" && entry.nextMaintenance != "Tudo OK" {
                        Text("\(entry.remainingKM) km")
                            .font(.caption)
                            .foregroundColor(statusColor)
                    }
                }
            }
        }
        .containerBackground(for: .widget) {
            Color(uiColor: .systemBackground)
        }
    }

    private var statusColor: Color {
        if entry.remainingKM <= 0 { return .red }
        if entry.remainingKM <= 500 { return .orange }
        return .green
    }
}

@main
struct PitStopWidget: Widget {
    let kind: String = "PitStopWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PitStopWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Status da Moto")
        .description("Acompanhe a quilometragem e a próxima revisão.")
        .supportedFamilies([.systemSmall])
    }
}
