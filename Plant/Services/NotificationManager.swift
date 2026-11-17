import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    private let center = UNUserNotificationCenter.current()

    // طلب الإذن من المستخدم
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    // جدولة إشعار مرة وحدة في تاريخ محدد
    func schedule(for plant: Plant, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Time to water 💧"
        content.body = "You haven't watered \(plant.plantName) today. It needs \(plant.water.rawValue)."
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )
        center.add(request)
    }

    // إلغاء إشعار نبتة
    func cancel(for plant: Plant) {
        center.removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }
}
