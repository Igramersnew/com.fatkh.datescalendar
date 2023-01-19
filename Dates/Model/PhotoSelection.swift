import UIKit
import SwiftUI

enum PhotoSelection: Hashable, Equatable {
    case noPhoto
    case placeholder
    case selected(UIImage)

    var image: Image {
        switch self {
        case .noPhoto:
            return Image("noPhoto")
        case .placeholder:
            return Image("photoPlaceholder")
        case .selected(let uIImage):
            return Image(uiImage: uIImage)
        }
    }
}
