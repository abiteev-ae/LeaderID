import Kingfisher
import SwiftUI

extension EventFeedView {
    struct EventDetailedView: View {
        
        struct Model {
            let photo: String
            let fullName: String
            let dateStart: String
            let dateEnd: String
        }
        let event: Model
        init(_ event: Event) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateStart = dateFormatter.date(from: event.dateStart)!
            let dateEnd = dateFormatter.date(from: event.dateEnd)!
            dateFormatter.dateFormat = "MM.dd HH:mm"
            self.event = Model(
                photo: event.photo,
                fullName: event.fullName,
                dateStart: dateFormatter.string(from: dateStart),
                dateEnd: dateFormatter.string(from: dateEnd)
            )
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



