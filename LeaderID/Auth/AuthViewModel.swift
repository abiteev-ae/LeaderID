import SwiftUI
import Combine

extension AuthView {
    @Observable
    final class ViewModel {
        enum State {            
            case unAuthed
            case loading
            case authed(AccessTokenDecodable)
            case failed(ErrorType)
        }
        
        
        // MARK: - Published properties
        
        var code: String?
        private(set) var activateRootLink = false
        private(set) var state = State.unAuthed
        
        // MARK: - Properties
        
        @ObservationIgnored private var subscriptions: Set<AnyCancellable> = []
        @ObservationIgnored private let networking: AuthAPIProtocol
        
        // OAuth properties, key and secret Key u can get from LeaderID: https://leader-id.ru/developers
        @ObservationIgnored private let key = "c8c610ed-3e62-4e5d-9502-57cde9bdd349"
        @ObservationIgnored private let secretKey = "dz09CLqrJirOM9Ax1jk39N33hD4Djy9K"
        @ObservationIgnored private let redirectURI = "klonhero.github.io/leaderid/"
        @ObservationIgnored public lazy var authorizeURL: URL = {
            return URL(string: "https://leader-id.ru/apps/authorize?client_id=\(self.key)&redirect_uri=\(redirectURI)&response_type=code")!
        }()
        
        // MARK: - Initializers
        
        init(networking: AuthAPIProtocol) {
            self.networking = networking
        }
        
        // MARK: - Methods
        func returnToAuth() {
            activateRootLink = true
        }
        
        func startAuth() {
            
        }
        
        func auth(_ code: String) {
            self.state = .loading
            networking.getAccessToken(codable: AccessTokenCodable(
                clientID: key,
                clientSecret: secretKey,
                grantType: .authorizationCode,
                code: code
            )).sink {[weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error.errorDescription)
                    }
                    if let code = error.responseCode {
                        self.state = .failed(.backend(code))
                    }
                    if error.isSessionTaskError {
                        self.state = .failed(.noInternet)
                    }
                    if error.isResponseSerializationError {
                        self.state = .failed(.decoding)
                    }
                    if error.isSessionTaskError {
                        self.state = .failed(.encoding)
                    }
                case .finished:
                    break
                }
            } receiveValue: {[weak self] value in
                guard let self = self else { return }
                self.state = .authed(value)
            }
            .store(in: &subscriptions)
        }
        
        func updateAccessToken(refreshToken: String) {
            self.state = .loading
            networking.getAccessToken(codable: AccessTokenCodable(
                clientID: key,
                clientSecret: secretKey,
                grantType: .refreshToken,
                refreshToken: nil
            )).sink {[weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    if let code = error.responseCode {
                        self.state = .failed(.backend(code))
                    }
                    if error.isSessionTaskError {
                        self.state = .failed(.noInternet)
                    }
                    if error.isResponseSerializationError {
                        self.state = .failed(.decoding)
                    }
                    if error.isSessionTaskError {
                        self.state = .failed(.encoding)
                    }
                case .finished:
                    break
                }
            } receiveValue: {[weak self] value in
                guard let self = self else { return }
                self.state = .authed(value)
            }
            .store(in: &subscriptions)
        }
    }
}


