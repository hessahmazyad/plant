import Foundation
import SwiftData
import Combine

class PlantListViewModel: ObservableObject {
    @Published var plants: [Plant] = []

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
        fetch()//تجيب النباتات كل ما فتحت التطبيق 
        resetExpiredWatering()// عشان تشتغل كاف ما فتحت التطبيق
    }

    // MARK: - نباتات اليوم
    var todayPlants: [Plant] {
        plants.filter { isDueToday($0) }
    }// الغرض منها تمشي على القائمة كامله و تحفظ فقط اللي الشرط حقها يرجع لي true

    var wateredCount: Int { // كم نبته من نباتات اليوم في المصفوفه حقت اليوم انسقت؟
        todayPlants.filter { $0.isWatered }.count
    }

    var allWatered: Bool { // هل مريت على كل النباتات؟
        !todayPlants.isEmpty && wateredCount == todayPlants.count
    }

    var progress: Double { // عشان الشريط اللي فوق يمشي على عدد النباتات
        todayPlants.isEmpty ? 0 : Double(wateredCount) / Double(todayPlants.count) // دام فيه نباتات اليوم سو لي الحسبه التاليه
    }

    private func isDueToday(_ plant: Plant) -> Bool {
        if plant.isWatered { return true }// بتختفي القائمه لو ما حطيت ذا الشرط
        let endOfToday = Calendar.current.startOfDay(for: Date())// الغرض تعطيني بداية اليوم من السلعه ١٢ بالليل
            .addingTimeInterval(24 * 60 * 60)
        return plant.nextWateringDate < endOfToday// هل موعدها قبل نهاية اليوم ؟
    }

    // MARK: - جلب وحفظ
    private func fetch() {
        let descriptor = FetchDescriptor<Plant>(sortBy: [SortDescriptor(\.plantName)])
        plants = (try? context.fetch(descriptor)) ?? []
    }
     //يكتب المتغيرات في القاعده
    //حاول فشلت؟ تجاهل الخطأ
    //ارجع جب النباتات من القاعده و حطها بالمصفوفه
    private func saveContext() {
        try? context.save()
        fetch()
    }

    // MARK: - إضافة وحذف وتعديل
    func addPlant(_ plant: Plant) {
        plant.nextWateringDate = Date()
        context.insert(plant)
        saveContext()
        NotificationManager.shared.schedule(for: plant, at: nextDate(for: plant))
    }

    func deletePlant(_ plant: Plant) {
        NotificationManager.shared.cancel(for: plant)
        context.delete(plant)
        saveContext()
    }

    func updatePlant(_ plant: Plant) {
        saveContext()
        NotificationManager.shared.cancel(for: plant)
        NotificationManager.shared.schedule(for: plant, at: nextDate(for: plant))
    }

    // MARK: - التيك
    func toggleWatered(_ plant: Plant) {
        plant.isWatered.toggle()// عشان يرجع حاله المبته على حسب الضغط
        NotificationManager.shared.cancel(for: plant)// الغي الاشعار

        if plant.isWatered {
            plant.lastWateredDate = Date()//اجيب موعد السقي الحالي عشان اعرف متى اصفر
            plant.nextWateringDate = nextDate(for: plant)//تحسب الموعد القادم
        } else {
            plant.lastWateredDate = nil//ما انسقت
            plant.nextWateringDate = Date()//رجع الموعد لأنها مستحقه اليوم
        }
        saveContext()
        NotificationManager.shared.schedule(for: plant, at: nextDate(for: plant))
    }

    // MARK: - تصفير التيك عند يوم جديد
    private func resetExpiredWatering() {
        var changed = false
        for plant in plants {
            if plant.isWatered,
               let last = plant.lastWateredDate,
               !Calendar.current.isDateInToday(last) {
                plant.isWatered = false
                changed = true
            }
        }
        if changed { saveContext() }
    }
    // الداله اللي تصفر العداد


    private func nextDate(for plant: Plant) -> Date {
        Calendar.current.date(byAdding: .day, value: plant.wateringDays.days, to: Date()) ?? Date()
    }
   
}
