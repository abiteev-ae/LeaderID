import Alamofire
import Combine
import SwiftUI

protocol AuthAPIProtocol {
    func getAccessToken(codable: AccessTokenCodable) -> AnyPublisher<AccessTokenDecodable, AFError> 
}

struct AuthAPI: AuthAPIProtocol {
    
    func getAccessToken(codable: AccessTokenCodable) -> AnyPublisher<AccessTokenDecodable, AFError> {
        /* Example of API answer
         {
         "user_id": 123456,
         "user_validated": true,
         "refresh_token": "eyJ0eXA_______",
         "access_token": "eyJ0eXA_______",
         }
         */
        let url = URL(string: "https://apps.leader-id.ru/api/v1/oauth/token")!
        
        
        let parameterEncoder: JSONParameterEncoder = {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            return JSONParameterEncoder.json(encoder: jsonEncoder)
        }()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return AF.request(
            url,
            method: .post,
            parameters: codable,
            encoder: parameterEncoder
        )
        .validate()
        .publishDecodable(type: AccessTokenDecodable.self, decoder: jsonDecoder)
        .value()
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}


struct AccessTokenCodable: Codable {
    enum GrantType: String {
        case authorizationCode = "authorization_code"
        case refreshToken = "refresh_token"
    }
    let clientID: String
    let clientSecret: String
    let grantType: String
    let code: String? // TODO: что-то из code или refresh должно быть не nil, нужно обработать кейс если человек не передал ни того, ни другого и выкинуть ошибку
    let refreshToken: String?
    
    init(clientID: String, clientSecret: String, grantType: GrantType, code: String? = nil, refreshToken: String? = nil) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.grantType = grantType.rawValue
        self.code = code
        self.refreshToken = refreshToken
    }
}

struct AccessTokenDecodable: Decodable {
    let userId: Int
    let userValidated: Bool
    let refreshToken: String
    let accessToken: String
}
