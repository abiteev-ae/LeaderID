import Combine
import SwiftUI

extension EventFeedView {
    @Observable
    final class ViewModel {
        enum State {
            case loading
            case loaded(EventsDecodable)
            case failed(ErrorType)
        }
        var events: EventsDecodable?
        var state: State = .loading // TODO: можно сделать шимер и сюда и добавить тогда новый state .idle
        
        @ObservationIgnored let dependencies: EventFeedViewDI.Dependencies
        @ObservationIgnored private var subscriptions: Set<AnyCancellable> = []
        
        init(_ dependencies: EventFeedViewDI.Dependencies) {
            self.dependencies = dependencies
        }
        
        func getUser(id: Int) {
            self.state = .loading
            dependencies.userAPI.getUser(id: id)
                .sink {[weak self] completion in
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
                    self.getEvents(cityId: value.address.cityId)
                }
                .store(in: &subscriptions)
        }
        
        func getEvents(cityId: Int) {
            //https://apps.leader-id.ru/api/v1/events/search?paginationPage=1&paginationSize=15&sort=weight&onlyWithActuralRegistration=1&cityId=893&participationFormat=person&onlyActual=1
            dependencies.eventFeedAPI.getEvents(codable: GetEventsCodable(
                paginationPage: 1,
                paginationSize: 15,
                sort: "weight",
                onlyWithActuralRegistration: 1,
                cityId: cityId,
                participationFormat: "person",
                onlyActual: 1
            ))
            .sink {[weak self] completion in
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
                
                self.events = value
                self.state = .loaded(value)
            }
            .store(in: &subscriptions)
        }
        
        
    }
}


