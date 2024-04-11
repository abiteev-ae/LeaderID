import SwiftUI

struct EventFeedView: View {
    typealias Event = EventsDecodable.EventDecodable
    @State var vm: ViewModel
    init(_ vm: ViewModel) {
        self.vm = vm
        vm.getUser(id: vm.dependencies.accessTokenDecodable.userId)
    }
    
    var columns: [GridItem] = [
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ZStack {
            Color.bg.ignoresSafeArea(.all)  
            switch vm.state {
            case .loading:
                ProgressView()
            case .loaded(let events):
                ScrollView{
                    LazyVGrid(columns: columns, spacing: Guides.spacingBetweenEvents) {
                        ForEach(events.items) { event in
                            NavigationLink(destination: EventView(event)) {
                                EventDetailedView(event)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .padding()
                        }
                    }
                }
            case .failed(let error):
                ErrorView(error: error)
            }
        }
    }
    
    struct Guides {
        static let spacingBetweenEvents: CGFloat = 24
    }
}



