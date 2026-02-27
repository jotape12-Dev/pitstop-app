//
//  AddMaintenanceView.swift
//  PitStop
//
//  Created by Jota Pe on 24/02/26.
//

import SwiftUI
import SwiftData

struct AddMaintenanceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var moto: Motorcycle
    
    @State private var title: String = ""
    @State private var intervalString: String = ""
    @State private var lastServiceString: String = ""
    
    var isFormValid: Bool {
        !title.isEmpty && !intervalString.isEmpty && !lastServiceString.isEmpty
    }
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("O que vamos rastrear?")) {
                    TextField("Nome (Ex: Óleo do Motor)", text: $title)
                }
                
                Section(header: Text("Regras"), footer: Text("Ex: Se você troca o óleo a cada 3000km, e a última troca foi aos 12000km, preencha 3000 e 12000 respectivamente.")) {
                    TextField("Intervalo de troca (KM)", text: $intervalString)
                        .keyboardType(.numberPad)
                    TextField("KM da última troca", text: $lastServiceString)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Novo Alerta")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Salvar") { saveMaintenance() }
                        .fontWeight(.bold)
                        .disabled(!isFormValid)
                }
            }
        }
    }
    private func saveMaintenance() {
        let interval = Int(intervalString) ?? 0
        let lastService = Int(lastServiceString) ?? 0
        
        let newItem = MaintenanceItem(title: title, intervalMileage: interval, lastServiceMileage: lastService)
        
        moto.maintenanceItems.append(newItem)
        
        dismiss()
    }
}
