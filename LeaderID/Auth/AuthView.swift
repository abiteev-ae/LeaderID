import SwiftUI

struct AuthView: View {
    @State private var vm: ViewModel
    
    init(_ vm: ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        NavigationStack {
            switch vm.state {
            case .unAuthed:
                Link("Auth", destination: vm.authorizeURL)
                    .onOpenURL { url in
                        let components = URLComponents(
                            url: url, resolvingAgainstBaseURL: false
                        )
                        let code = components?.queryItems?.first(where: { $0.name == "code" })?.value ?? "nothing"
                        
                        vm.auth(code)
                    }
                // TODO: По хорошему переделать навигацию через координаторы и включать следующий экран через него а не onOpenURL с NavigationLink
            case .authed(let accessTokenDecodable):
                NavigationLink("Event Feed") {
                    EventFeedViewDI().eventFeedView(accessTokenDecodable)
                }
            case .loading:
                ProgressView()
            case .failed(let error):
                ErrorView(error: error)
            }
        }
    }
}

#Preview {
    AuthViewDI().authView
}
