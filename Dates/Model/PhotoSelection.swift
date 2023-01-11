import UIKit
import SwiftUI

enum PhotoSelection: Hashable, Equatable {
    case placeholder
    case selected(UIImage)

    var image: Image {
        switch self {
        case .placeholder:
            return Image("photoPlaceholder")
        case .selected(let uIImage):
            return Image(uiImage: uIImage)
        }
    }
}
