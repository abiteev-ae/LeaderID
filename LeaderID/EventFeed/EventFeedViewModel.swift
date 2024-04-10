import SwiftUI
import Combine

extension EventFeedView {
    @Observable
    final class ViewModel {
        enum State {
            case unAuthed
            case loading
            case authed
            case failed
        }
    }
}


