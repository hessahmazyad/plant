import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false

    var body: some View {
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

            Spacer()

            VStack(spacing: 12) {
                Image("Image 1")
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.4
                    }

                Text("Start your plant journey!")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.TextPrimary)

                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.TextSecondary)
                    .containerRelativeFrame(.horizontal) { width, _ in
                        width * 0.65
                    }
            }

            Spacer()

            Button {
                hasSeenWelcome = true
            } label: {
                Text("Set Plant Reminder")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.capsule)
            .controlSize(.regular)           
            .tint(Color.PrimaryGreen)
            .padding(.bottom, 80)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.AppBackground.ignoresSafeArea())
    }
}

#Preview {
    ContentView()
}
