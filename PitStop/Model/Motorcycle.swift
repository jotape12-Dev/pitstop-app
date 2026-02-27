//
//  Item.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import Foundation
import SwiftData

@Model
class Motorcycle {
    var name : String
    var brand: String
    var currentMileage: Int = 0    
    
    @Attribute(.externalStorage) var photoData: Data?
    
    // Relacionamento: Uma moto tem uma lista de itens de manutenção
    @Relationship(deleteRule: .cascade) var maintenanceItems: [MaintenanceItem] = []
    
    init(name: String, brand: String, currentMileage: Int) {
        self.name = name
        self.brand = brand
        self.currentMileage = currentMileage
    }
}
