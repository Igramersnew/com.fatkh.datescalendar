import SwiftUI

struct Person: Codable, Hashable, Identifiable {
    let id: UUID
    let photoPreviewUrl: String?
    let name: String
    let age: Int
    let phone: String
    let photoUrls: [String]
    let meetingDate: Date
    let notes: String

    let instagramLink: String?
    let twitterLink: String?
    let facebookLink: String?

    var isLiked: Bool = false

    var isRemind: Bool = false

    var photoPreview: PhotoSelection {
        return photoPreviewUrl.flatMap { url in ImageStorage.read(from: url).map { .selected($0) } } ?? .placeholder
    }

    var photos: [PhotoSelection] {
        return photoUrls.map { url in ImageStorage.read(from: url).map { .selected($0) } ?? .placeholder }
    }

    var yearsOld: String {
        return "12" // TODO: calculate age
    }
}
