import Kingfisher
import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let title: String
}

extension EventFeedView {
    struct EventView: View {
        
        let event: Event
        init(_ event: Event) {
            self.event = event
        }
        
        var body: some View {
            VStack {
                Spacer()
                KFImage(URL(string: event.photo)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: Guides.imageHeight)
                Spacer(minLength: Guides.textsTopAndBotomInsets)
                VStack(alignment: .leading, spacing: 16) {
                    Text(event.fullName)
                        .foregroundColor(.black)
                    Text("С \(event.dateStart) до \(event.dateEnd)")
                        .foregroundColor(.gray)
                }.padding(EdgeInsets(
                    top: Guides.textsTopAndBotomInsets,
                    leading: Guides.textsTrailingAndLeadingInsets/2,
                    bottom: Guides.textsTopAndBotomInsets,
                    trailing: Guides.textsTrailingAndLeadingInsets
                ))
                Spacer()
            }
            .clipShape(RoundedRectangle(cornerRadius: Guides.cornerRadius))
            .frame(minHeight: Guides.minHeight)
            .background(Color.white)
        }
        
        struct Guides {
            static let imageHeight: CGFloat = 203
            static let textsTopAndBotomInsets: CGFloat = 24
            static let textsTrailingAndLeadingInsets: CGFloat = 20
            static let cornerRadius: CGFloat = 8
            static let minHeight: CGFloat = 200
        }
    }
    
}



