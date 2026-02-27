//
//  ServiceRecord.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import Foundation
import SwiftData

@Model
class ServiceRecord {
    var date: Date            // Data que o serviço foi feito
    var mileageAtService: Int // KM exato no momento da troca
    var cost: Double          // Quanto custou? (Para gerar os gráficos depois)
    var notes: String         // Ex: "Usei óleo Motul 5000"
    
    var maintenanceItem: MaintenanceItem?
    
    init(date: Date, mileageAtService: Int, cost: Double, notes: String = "") {
        self.date = date
        self.mileageAtService = mileageAtService
        self.cost = cost
        self.notes = notes
    }
}
