import SwiftUI

struct ModalView<Content: View>: View {

    @EnvironmentObject var viewModel: ViewModel
    @Binding var isShowing: Bool

    @State private var prevDragTranslation = CGSize.zero
    @State private var isDragging = false

    @ViewBuilder let content: () -> Content

    @State private var curentHeight: CGFloat
    private let maxHeight: CGFloat
    private var minHeight: CGFloat { return maxHeight / 2 }

    init(isShowing: Binding<Bool>, height: CGFloat, content: @escaping () -> Content) {
        maxHeight = height
        curentHeight = height
        self._isShowing = isShowing
        self.content = content
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .ignoresSafeArea()
                    .opacity(0.5)
                    .onTapGesture {
                        isShowing = false
                    }
                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(colors: [Color(hex: "#3D4272"),
                                                Color(hex: "#2A213C")],
                                       startPoint: .top,
                                       endPoint: .bottom)
                    )
                    .overlay(
                        VStack {
                            ZStack(alignment: .top) {
                                Capsule()
                                    .frame(width: 51, height: 5)
                            }
                            .frame(height: 40)
                            .frame(maxWidth: .infinity)
                            .background(Color.white.opacity(0.001))
                            .gesture(dragGesture)

                            content()
                        }
                        ,alignment: .top
                    )
                    .animation(isDragging ? nil : .easeInOut(duration: 0.45))
                    .onDisappear {
                        curentHeight = maxHeight
                        viewModel.update(update: .setTabBar(hidden: false))
                    }
                    .onAppear { viewModel.update(update: .setTabBar(hidden: true)) }
                    .frame(height: curentHeight)
                    .frame(maxWidth: .infinity)
                    .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(.easeInOut)
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            .onChanged { val in
                if !isDragging {
                    isDragging = true
                }
                let  dragAmount = val.translation.height - prevDragTranslation.height
                if curentHeight > maxHeight {
                    curentHeight -= dragAmount / 6
                } else {
                    curentHeight -= dragAmount
                }

                prevDragTranslation = val.translation
            }
            .onEnded { _ in
                prevDragTranslation = .zero
                isDragging = false
                if curentHeight < minHeight {
                    isShowing = false

                } else {
                    curentHeight = maxHeight
                }
                if curentHeight > maxHeight {
                    curentHeight = maxHeight
                }
            }
    }

}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(isShowing: .constant(true), height: 500) {
            ZStack { }
        }
        .environmentObject(ViewModel.shared)
    }
}
