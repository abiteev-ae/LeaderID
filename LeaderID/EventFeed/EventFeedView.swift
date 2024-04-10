import SwiftUI

struct EventFeedView: View {
    // 1. Number of items will be display in row
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 100)),
    ]

    // 3. Get mock cards data
    let cards: [Card] = MockStore.cards
    
    var body: some View {
        ScrollView {
            // 4. Populate into grid
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(cards) { card in
                    CardView(title: card.title)
                }
            }
            .padding()
        }
    }
}

#Preview{
    EventFeedView()
}
