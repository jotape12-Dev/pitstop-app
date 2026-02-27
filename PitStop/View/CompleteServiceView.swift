//
//  CompleteServiceView.swift
//  PitStop
//
//  Created by Jota Pe on 25/02/26.
//

import SwiftData
import SwiftUI
import WidgetKit

struct CompleteServiceView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var item: MaintenanceItem
    
    @State private var costString: String = ""
    @State private var notes: String = ""
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Detalhes do Serviço")){
                    DatePicker("Data", selection: $date, displayedComponents: .date)
                        TextField("Custo (R$)", text: $costString)
                            .keyboardType(.decimalPad)
                        
                        TextField("Observações (Ex: Óleo Motul)", text: $notes)
                    }
                }
                .navigationTitle("Concluir: \(item.title)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancelar") { dismiss() }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Salvar") {
                            saveRecord()
                        }
                        .fontWeight(.bold)
                        .disabled(costString.isEmpty)
                    }
                }
            }
        }
                        
    private func saveRecord() {
        let costFormatted = costString.replacingOccurrences(of: ",", with: ".")
        let cost = Double(costFormatted) ?? 0.0
        
        let currentMileage = item.motorcycle?.currentMileage ?? 0
        
        let newRecord = ServiceRecord(date: date, mileageAtService: currentMileage, cost: cost, notes: notes)
        newRecord.maintenanceItem = item
        
        item.lastServiceMileage = currentMileage
        
        try? modelContext.save()
        WidgetCenter.shared.reloadAllTimelines()
        
        modelContext.insert(newRecord)
        
        dismiss()
    }
}
