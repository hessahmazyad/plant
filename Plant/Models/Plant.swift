import Foundation
import SwiftData
//هنا انا قاعده اعلن انه هذي البيانات ابيك تحفظها بقاعدة البيانات
@Model
final class Plant {
    var id : UUID
    var isWatered: Bool // يعطيني فقط نعم ولا مو متى
    var lastWateredDate: Date? //متى اخر مره اسقت؟
    var nextWateringDate: Date //موعد سقيها القادم
    //النبتة تظهر اليوم إذا موعدها القادم قبل نهاية اليوم.
    var plantName: String
    var room: Room
    var light: Light
    var wateringDays: WateringDays
    var water: WaterAmount
    
    init(plantName: String, room: Room, light: Light, wateringDays: WateringDays, water: WaterAmount) {
        self.id = UUID()
        self.isWatered = false
        self.lastWateredDate = nil
        self.nextWateringDate = Date()
        self.plantName = plantName
        self.room = room
        self.light = light
        self.wateringDays = wateringDays
        self.water = water
    }
    
}
