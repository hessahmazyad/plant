import Foundation

enum Room: String, CaseIterable, Codable {
    case bedroom = "Bedroom"
    case livingroom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
}

enum Light: String, CaseIterable, Codable {
    case fullsun = "Full Sun"
    case partialsun = "Partial Sun"
    case lowlight = "Low Light"
}

enum WateringDays: String, CaseIterable, Codable {
    case everyday = "Every day"
    case every2days = "Every 2 days"
    case every3days = "Every 3 days"
    case onceAweek = "Once a week"
    case every10days = "Every 10 days"
    case every2weeks = "Every 2 weeks"

    var days: Int {
        switch self {
        case .everyday: return 1
        case .every2days: return 2
        case .every3days: return 3
        case .onceAweek: return 7
        case .every10days: return 10
        case .every2weeks: return 14
        }
    }
}

enum WaterAmount: String, CaseIterable, Codable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case extraLarge = "200-300 ml"
}
