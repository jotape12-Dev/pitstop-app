import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query(sort: \ServiceRecord.date, order: .reverse) private var records: [ServiceRecord]
    
    var body: some View {
        NavigationStack {
            Group {
                if records.isEmpty {
                    ContentUnavailableView(
                        "Sem Histórico",
                        systemImage: "chart.pie.dashed",
                        description: Text("Realize manutenções na sua moto para ver os gráficos de gastos aqui.")
                    )
                } else {
                    List {
                        Section(header: Text("Gastos por Serviço")) {
                            Chart {
                                ForEach(records) { record in
                                    BarMark(
                                        x: .value("Serviço", record.maintenanceItem?.title ?? "Geral"),
                                        y: .value("Gasto", record.cost),
                                        width: .fixed(50)
                                    )
                                    .foregroundStyle(by: .value("Item", record.maintenanceItem?.title ?? "Geral"))
                                }
                            }
                            .frame(height: 250)
                            .padding(.vertical)
                        }
                        
                        Section(header: Text("Últimos Serviços Realizados")) {
                            ForEach(records) { record in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(record.maintenanceItem?.title ?? "Serviço")
                                            .font(.headline)
                                        Text(record.date, format: .dateTime.day().month().year())
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(String(format: "R$ %.2f", record.cost))
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Estatísticas")
        }
    }
}
