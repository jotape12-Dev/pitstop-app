//
//  NotificationManager.swift
//  PitStop
//
//  Created by Jota Pe on 27/02/26.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("✅ Permissão de Notificação concedida!")
            } else {
                print("❌ Permissão negada ou erro: \(String(describing: error))")
            }
        }
    }
    
    func scheduleMaintenanceAlert(itemName: String, remainingKM: Int, motoName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Atenção: \(motoName) 🏍️"
        content.body = "Sua manutenção de '\(itemName)' está próxima! Faltam apenas \(remainingKM) km."
        content.sound = .default // Usa o som padrão de notificação do iPhone
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Erro ao agendar notificação: \(error.localizedDescription)")
            }
        }
    }
}
