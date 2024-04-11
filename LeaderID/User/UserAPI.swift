import Alamofire
import Combine
import Foundation


protocol UserAPIProtocol {
    func  getUser(id: Int) -> AnyPublisher<UserDecodable, AFError>
}

struct UserAPI: UserAPIProtocol {
    let token: String
    init(_ token: String) {
        self.token = token
    }
    
    func getUser(id: Int) -> AnyPublisher<UserDecodable, AFError> {
        let url = URL(string: "https://apps.leader-id.ru/api/v1/users/\(id)")!
        return AF.request(
            url,
            method: .get,
            headers: [
                .authorization(bearerToken: token)
            ]
        )
        .validate()
        .publishDecodable(type: UserDecodable.self)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

struct UserDecodable: Decodable {
    struct Adress: Decodable {
        let cityId: Int
    }
    let address: Adress
}
