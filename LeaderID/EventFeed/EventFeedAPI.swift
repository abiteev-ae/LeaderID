import Alamofire
import Foundation
import Combine

protocol EventFeedAPIProtocol {
    func getEvents(codable: GetEventsCodable) -> AnyPublisher<EventsDecodable, AFError>
}

struct EventFeedAPI: EventFeedAPIProtocol {
    let token: String
    func getEvents(codable: GetEventsCodable) -> AnyPublisher<EventsDecodable, AFError> {
        //Example of request: https://apps.leader-id.ru/api/v1/events/search?paginationPage=1&paginationSize=15&sort=weight&onlyWithActuralRegistration=1&cityId=893&participationFormat=person&onlyActual=1
        let url = URL(string: "https://apps.leader-id.ru/api/v1/events/search")!
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return AF.request(
            url,
            method: .get,
            parameters: codable,
            encoder: URLEncodedFormParameterEncoder(destination: .queryString),
            headers: [
                .authorization(bearerToken: token)
            ]
        )
        .validate()
        .publishDecodable(type: EventsDecodable.self, decoder: jsonDecoder)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    init(_ token: String) {
        self.token = token
    }
}

struct GetEventsCodable: Codable {
    let paginationPage: Int
    let paginationSize: Int
    let sort: String
    let onlyWithActuralRegistration: Int
    let cityId: Int
    let participationFormat: String
    let onlyActual: Int
}

struct EventsDecodable: Decodable {
    struct EventDecodable: Decodable, Identifiable {
        let dateStart: String
        let dateEnd: String
        let id: Int
        let fullName: String
        let photo: String
    }
    
    let items: [EventDecodable]
}
