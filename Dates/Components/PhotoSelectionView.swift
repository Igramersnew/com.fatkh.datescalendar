import SwiftUI
import UIKit
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var images: [PhotoSelection]
    @Binding var isPresented: Bool

    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(images: $images, isPresented: $isPresented)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}

final class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {

    @Binding var images: [PhotoSelection]
    @Binding var isPresented: Bool

    init(images: Binding<[PhotoSelection]>, isPresented: Binding<Bool>) {
        self._images = images
        self._isPresented = isPresented
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        guard !results.isEmpty else {
            self.isPresented = false
            return
        }

        let isFinishedCompletion = {
            if self.images.count == results.count {
                self.isPresented = false
            }
        }
        images = []
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self]  image, error in
                if let image = image as? UIImage {
                    self?.images.append(.selected(image))
                } else {
                    self?.images.append(.placeholder)
                }

                isFinishedCompletion()
            }
        }
    }

}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        Color.blue
            .ignoresSafeArea()
            .overlay(
                ImagePickerView(images: .constant([]), isPresented: .constant(true))
            )
    }
}
