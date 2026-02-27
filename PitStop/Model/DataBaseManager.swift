//
//  DataBaseManager.swift
//  PitStop
//
//  Created by Jota Pe on 26/02/26.
//

import Foundation
import SwiftData

class DatabaseManager {
    static let shared = DatabaseManager()
    let container: ModelContainer
    
    private init() {
        let schema = Schema([Motorcycle.self, MaintenanceItem.self, ServiceRecord.self])
        
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.PitStopApp") else {
            fatalError("App Group não encontrado. Verifique se o nome está exato nas Capabilities.")
        }
        
        let dbURL = groupURL.appendingPathComponent("PitStop.sqlite")
        let config = ModelConfiguration(url: dbURL)
        
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Falha ao criar o banco de dados compartilhado: \(error)")
        }
    }
}
