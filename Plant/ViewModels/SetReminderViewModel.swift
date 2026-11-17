import Foundation
import Combine

class SetReminderViewModel: ObservableObject {
    @Published var plantName: String = ""
    @Published var room: Room = .bedroom
    @Published var light: Light = .fullsun
    @Published var wateringDays: WateringDays = .everyday
    @Published var water: WaterAmount = .small

    private var editingPlant: Plant?
    private let listViewModel: PlantListViewModel

    var isEditing: Bool {
        editingPlant != nil
    }

    init(listViewModel: PlantListViewModel, plant: Plant? = nil) {
        self.listViewModel = listViewModel
        if let plant {
            editingPlant = plant
            plantName = plant.plantName
            room = plant.room
            light = plant.light
            wateringDays = plant.wateringDays
            water = plant.water
        }
    }

    func save() {
        if let plant = editingPlant {          
            plant.plantName = plantName
            plant.room = room
            plant.light = light
            plant.wateringDays = wateringDays
            plant.water = water
            listViewModel.updatePlant(plant)
        } else {
            let newPlant = Plant(plantName: plantName, room: room, light: light, wateringDays: wateringDays, water: water)
            listViewModel.addPlant(newPlant)
        }
    }

    func delete() {
        if let plant = editingPlant {
            listViewModel.deletePlant(plant)
        }
    }
}
