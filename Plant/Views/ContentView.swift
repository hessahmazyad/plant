import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack{
            Text("My Plants 🌱")
            
            Image("")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text("Start your plant journey!")
            Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
            Button("Set Plant Remonder"){}
            
        }.padding()
    }
}

#Preview {
    ContentView()
}
