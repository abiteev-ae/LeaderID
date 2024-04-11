import Foundation

struct AuthViewDI {

    var authView: AuthView {
        AuthView(authViewModel)
    }
    private var authViewModel: AuthView.ViewModel {
        AuthView.ViewModel(networking)
    }
    var networking: AuthAPI {
        AuthAPI()
    }
}
