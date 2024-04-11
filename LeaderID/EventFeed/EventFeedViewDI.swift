import Alamofire
import Foundation

struct EventFeedViewDI {
    typealias ATD = AccessTokenDecodable
    struct Dependencies {
        let eventFeedAPI: EventFeedAPI
        let userAPI: UserAPI
        let accessTokenDecodable: ATD
        init(_ eventFeedAPI: EventFeedAPI, userAPI: UserAPI, atd: ATD) {
            self.eventFeedAPI = eventFeedAPI
            self.userAPI = userAPI
            self.accessTokenDecodable = atd
        }
    }
    
    func eventFeedView(_ atd: ATD) -> EventFeedView {
        EventFeedView(eventFeedViewModel(atd: atd))
    }
    private func eventFeedViewModel(atd: ATD) -> EventFeedView.ViewModel {

        return EventFeedView.ViewModel(Dependencies(
            EventFeedAPI(atd.accessToken),
            userAPI: UserAPI(atd.accessToken),
            atd: atd
        ))
    }
}
