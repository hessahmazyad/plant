import SwiftUI
import SwiftData

struct PlantListView: View {
    @StateObject private var listViewModel: PlantListViewModel
    @State private var showSheet = false
    @State private var plantToEdit: Plant?

    init(context: ModelContext) {
        _listViewModel = StateObject(wrappedValue: PlantListViewModel(context: context))
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                HStack {
                    Text("My Plants 🌱")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.TextPrimary)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Divider()
                    .padding(.top, 8)

                // المحتوى حسب الحالة
                if listViewModel.plants.isEmpty {
                    emptyView
                } else if listViewModel.todayPlants.isEmpty || listViewModel.allWatered {
                    allDoneView
                } else {
                    plantsView
                }
            }

            addButton
        }
        .background(Color.AppBackground.ignoresSafeArea())
        // شيت الإضافة
        .sheet(isPresented: $showSheet) {
            SetReminderView(listViewModel: listViewModel)
        }
        // شيت التعديل
        .sheet(item: $plantToEdit) { plant in
            SetReminderView(listViewModel: listViewModel, plant: plant)
        }
    }

    // MARK: - الحالة الفاضية
    private var emptyView: some View {
        VStack {
            Spacer()
            Text("No reminders set yet..")
                .font(.caption)
                .foregroundStyle(Color.TextSecondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - كل النباتات انسقت
    private var allDoneView: some View {
        VStack(spacing: 8) {
            Spacer()
            Image("alldone")
                .resizable()
                .scaledToFit()
                .containerRelativeFrame(.horizontal) { width, _ in
                    width * 0.4
                }

            Text("All Done! 🎉")
                .font(.headline)
                .foregroundStyle(Color.TextPrimary)
                .padding(.top, 24)

            Text("All Reminders Completed")
                .font(.caption)
                .foregroundStyle(Color.TextSecondary)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - القائمة مع الشريط
    private var plantsView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 14) {
                Text(headerText)
                    .font(.footnote)
                    .foregroundStyle(Color.TextPrimary)

                ProgressView(value: listViewModel.progress)
                    .tint(Color.PrimaryGreen)
            }
            .padding(.horizontal, 24)
            .padding(.top, 48)
            .padding(.bottom, 40)

            List(listViewModel.todayPlants) { plant in
                plantRow(plant)
                    .listRowBackground(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        plantToEdit = plant
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            listViewModel.deletePlant(plant)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
    }

    private var headerText: String {
        if listViewModel.wateredCount == 0 {
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(listViewModel.wateredCount) of your plants feel loved today✨"
        }
    }

    // MARK: - صف النبتة
    private func plantRow(_ plant: Plant) -> some View {
        HStack(spacing: 12) {
            Button {
                listViewModel.toggleWatered(plant)
            } label: {
                Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(plant.isWatered ? Color.PrimaryGreen : Color.TextSecondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Label("in \(plant.room.rawValue)", systemImage: "location")
                    .font(.caption)
                    .foregroundStyle(Color.TextSecondary)

                Text(plant.plantName)
                    .font(.title3)
                    .foregroundStyle(Color.TextPrimary)

                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "sun.max")
                        Text(plant.light.rawValue)
                    }
                    .foregroundStyle(Color.SunYellow)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1), in: Capsule())

                    HStack(spacing: 4) {
                        Image(systemName: "drop")
                        Text(plant.water.rawValue)
                    }
                    .foregroundStyle(Color.WaterBlue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.1), in: Capsule())
                }
                .font(.caption2)
            }
        }
        .opacity(plant.isWatered ? 0.5 : 1)
    }

    // MARK: - زر +
    private var addButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(.glassProminent)
                .buttonBorderShape(.circle)
                .controlSize(.large)
                .tint(Color.PrimaryGreen)
            }
        }
        .padding()
    }
}

#Preview {
    let container = try! ModelContainer(for: Plant.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    PlantListView(context: container.mainContext)
}
