//
//  AddMotorcycleView.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddMotorcycleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var brand: String = ""
    @State private var currentMileage: String = ""
    
    private var isFormValid: Bool {
        !name.isEmpty && !brand.isEmpty && !currentMileage.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Detalhes da Moto")) {
                    TextField("Apelido (Ex: Fazer 250)", text: $name)
                    TextField("Marca (Ex: Yamaha)", text: $brand)
                }
                
                Section(header: Text("Hodômetro"), footer: Text("Insira a quilometragem atual que marca no painel da sua moto.")) {
                    TextField("KM Atual (Ex: 15000)", text: $currentMileage)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Nova Moto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") {
                        saveMotorcycle()
                    }
                    .fontWeight(.bold)
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private func saveMotorcycle() {
        let mileage = Int(currentMileage) ?? 0
        let newMoto = Motorcycle(name: name, brand: brand, currentMileage: mileage)

        try? modelContext.save()
        
        WidgetCenter.shared.reloadAllTimelines()
        
        modelContext.insert(newMoto)
        
        dismiss()
    }
}
