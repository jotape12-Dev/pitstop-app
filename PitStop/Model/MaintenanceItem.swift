//
//  MaintenanceItem.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import Foundation
import SwiftData

@Model
class MaintenanceItem {
    var title: String
    var intervalMileage: Int
    var lastServiceMileage: Int
    
    var motorcycle: Motorcycle?
    
    // Relacionamento: Histórico de todas as vezes que essa manutenção foi feita
    @Relationship(deleteRule: .cascade) var historyLogs: [ServiceRecord] = []
    
    init(title: String, intervalMileage: Int, lastServiceMileage: Int) {
        self.title = title
        self.intervalMileage = intervalMileage
        self.lastServiceMileage = lastServiceMileage
    }
    var mileageRemaining: Int {
        guard let moto = motorcycle else { return 0 }
        let nextServiceAt = lastServiceMileage + intervalMileage
        return nextServiceAt - moto.currentMileage
    }
}
