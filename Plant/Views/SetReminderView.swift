import SwiftUI
import SwiftData

struct SetReminderView: View {
    @StateObject private var viewModel: SetReminderViewModel
    @Environment(\.dismiss) private var dismiss

    init(listViewModel: PlantListViewModel, plant: Plant? = nil) {
        _viewModel = StateObject(wrappedValue: SetReminderViewModel(listViewModel: listViewModel, plant: plant))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {

                    HStack(spacing: 12) {
                        Text("Plant Name")
                        TextField("Pothos", text: $viewModel.plantName)
                            .tint(Color.PrimaryGreen)
                    }
                }//end sec1

                Section {
                    Picker(selection: $viewModel.room) {
                        ForEach(Room.allCases, id: \.self) { room in
                            Text(room.rawValue).tag(room)
                        }
                    } label: {
                        Label("Room", systemImage: "location")
                            .foregroundStyle(Color.TextPrimary)
                    }

                    Picker(selection: $viewModel.light) {
                        ForEach(Light.allCases, id: \.self) { light in
                            Text(light.rawValue).tag(light)
                        }
                    } label: {
                        Label("Light", systemImage: "sun.max")
                            .foregroundStyle(Color.TextPrimary)
                    }
                }//end sec2

                Section {
                    Picker(selection: $viewModel.wateringDays) {
                        ForEach(WateringDays.allCases, id: \.self) { wateringDays in
                            Text(wateringDays.rawValue).tag(wateringDays)
                        }
                    } label: {
                        Label("Watering Days", systemImage: "drop")
                            .foregroundStyle(Color.TextPrimary)
                    }

                    Picker(selection: $viewModel.water) {
                        ForEach(WaterAmount.allCases, id: \.self) { water in
                            Text(water.rawValue).tag(water)
                        }
                    } label: {
                        Label("Water", systemImage: "drop")
                            .foregroundStyle(Color.TextPrimary)
                    }
                }//end sec3

                // زر الحذف يطلع في وضع التعديل فقط
                if viewModel.isEditing {
                    Section {
                        Button(role: .destructive) {
                            viewModel.delete()
                            dismiss()
                        } label: {
                            Text("Delete Reminder")
                                .frame(maxWidth: .infinity)
                        }
                    }//end sec4
                }
            }//end form
            .scrollContentBackground(.hidden)
            .background(Color.AppBackground)
            .navigationTitle("Set Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }// end of toolbar1
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.save()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color.PrimaryGreen)
                }// end of toolbar2
            }
        }//end NavigationStack
    }//end body
}

#Preview {
    let container = try! ModelContainer(for: Plant.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    SetReminderView(listViewModel: PlantListViewModel(context: container.mainContext))
}
