import Foundation
import UIKit

final class ImageStorage {
    private static let fileManager = FileManager.default

    static func store(image: UIImage) -> String? {
        guard let data = image.pngData(),
              var url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let uuid = UUID().uuidString

        url.appendPathComponent(uuid)
        do {
            try data.write(to: url)
            return uuid
        } catch {
            return nil
        }
    }

    static func read(from path: String) -> UIImage? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = try? Data(contentsOf: url.appendingPathComponent(path)) else { return nil }

        return .init(data: data)
    }
}
