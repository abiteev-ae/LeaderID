import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let title: String
}

struct CardView: View {
    let title: String
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8).foregroundColor(.random)
            Text(title)
                .font(.title2)
        }
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

struct MockStore {
    static var cards = [
        Card(title: "Italy"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
        Card(title: "Italy"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
    ]
}

#Preview {
    CardView(title: "Hello world")
}
