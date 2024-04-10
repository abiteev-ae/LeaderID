import SwiftUI
extension AuthView {
    enum ErrorType {
        case encoding
        case decoding
        case noInternet
        case backend(Int)
    }
    
    struct ErrorView: View {
        
        let error: ErrorType
        
        var body: some View {
            VStack {
                Text("Something went wrong")
                    .font(.title)
                    .padding()
                Group {
                    switch error {
                    case .decoding:
                        EmptyView()
                    case .encoding:
                        Text("Please contact developer")
                    case .noInternet:
                        Text("Please check your internet connection")
                    case .backend(let code):
                        switch code {
                        default:
                            Text("Server error code: \(code)")
                        }
                    }
                }
                .padding()
            }
        }
    }
}
