import AppIntents
import SwiftData
import Foundation
import WidgetKit

struct AtualizarHodometroIntent: AppIntent {
    static let title: LocalizedStringResource = "Update KM / Atualizar KM"
    static let description = IntentDescription("Updates the motorcycle's odometer in PitStop.")
    
    @Parameter(title: "Moto / Motorcycle")
    var nomeDaMoto: String
    
    @Parameter(title: "Nova KM / New Mileage")
    var novaKM: Int
    
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        let isPortuguese = languageCode.hasPrefix("pt")
        
        do {
            let container = DatabaseManager.shared.container
            let context = container.mainContext
            
            let todasAsMotos = try context.fetch(FetchDescriptor<Motorcycle>())
            
            guard let moto = todasAsMotos.first(where: { $0.name.localizedCaseInsensitiveContains(nomeDaMoto) }) else {
                let errorMsg = isPortuguese
                    ? "Não encontrei a moto \(nomeDaMoto) na sua garagem."
                    : "I couldn't find a motorcycle named \(nomeDaMoto) in your garage."
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
            
            let successMsg = isPortuguese
                ? "Pronto! O hodômetro da \(moto.name) foi atualizado para \(novaKM) quilômetros."
                : "Done! The odometer for \(moto.name) has been updated to \(novaKM) kilometers."
            
            return .result(dialog: IntentDialog(stringLiteral: successMsg))
            
        } catch {
            let failMsg = isPortuguese ? "Desculpe, ocorreu um erro." : "Sorry, an error occurred."
            return .result(dialog: IntentDialog(stringLiteral: failMsg))
        }
    }
}
struct PitStopShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AtualizarHodometroIntent(),
            phrases: [
                //Ingles
                "Update mileage in \(.applicationName)",
                "Change bike KM in \(.applicationName)",
                //Portugues
                "Atualizar a quilometragem no \(.applicationName)",
                "Mudar o KM da moto no \(.applicationName)"
            ],
            shortTitle: "Update KM",
            systemImageName: "speedometer"
        )
    }
}
