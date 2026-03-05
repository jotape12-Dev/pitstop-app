import AppIntents
import SwiftData
import Foundation
import WidgetKit

struct AtualizarHodometroIntent: AppIntent {
    // Títulos e descrições na língua base do app (Português)
    static let title: LocalizedStringResource = "Atualizar KM"
    static let description = IntentDescription("Atualiza o hodômetro da moto no PitStop.")
    
    @Parameter(title: "Moto")
    var nomeDaMoto: String
    
    @Parameter(title: "Nova KM")
    var novaKM: Int
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        do {
            let container = DatabaseManager.shared.container
            let context = container.mainContext
            
            let todasAsMotos = try context.fetch(FetchDescriptor<Motorcycle>())
            
            guard let moto = todasAsMotos.first(where: { $0.name.localizedCaseInsensitiveContains(nomeDaMoto) }) else {
                // Usando String(localized:) com a frase base em português
                let errorMsg = String(localized: "Não encontrei a moto \(nomeDaMoto) na sua garagem.")
                return .result(dialog: IntentDialog(stringLiteral: errorMsg))
            }
            
            moto.currentMileage = novaKM
            
            for item in moto.maintenanceItems {
                if item.mileageRemaining <= 100 {
                    NotificationManager.shared.scheduleMaintenanceAlert(
                        itemName: item.title,
                        remainingKM: item.mileageRemaining,
                        motoName: moto.name
                    )
                }
            }
            
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
            
            // Usando String(localized:) com a frase base em português
            let successMsg = String(localized: "Pronto! O hodômetro da \(moto.name) foi atualizado para \(novaKM) quilômetros.")
            return .result(dialog: IntentDialog(stringLiteral: successMsg))
            
        } catch {
            let failMsg = String(localized: "Desculpe, ocorreu um erro.")
            return .result(dialog: IntentDialog(stringLiteral: failMsg))
        }
    }
}

struct PitStopShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AtualizarHodometroIntent(),
            phrases: [
                "Atualizar a quilometragem no \(.applicationName)",
                "Mudar o KM da moto no \(.applicationName)",
                "Atualizar KM no \(.applicationName)"
            ],
            shortTitle: "Atualizar KM",
            systemImageName: "speedometer"
        )
    }
}
