import Foundation

struct AuthViewDI {

    var authView: AuthView {
        AuthView(viewModel: authViewModel)
    }
    private var authViewModel: AuthView.ViewModel {
        AuthView.ViewModel(networking: networking)
    }
    private var networking: AuthAPI {
        AuthAPI()
    }
}
