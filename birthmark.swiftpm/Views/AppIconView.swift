import SwiftUI
import PencilKit

public extension UIImage {
    func mergeWith(topImage: UIImage) -> UIImage {
        let bottomImage = self

        UIGraphicsBeginImageContext(size)


        let areaSize = CGRect(x: 0, y: 0, width: bottomImage.size.width, height: bottomImage.size.height)
        bottomImage.draw(in: areaSize)

        topImage.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        let mergedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergedImage
    }
}

struct DrawingView: View {
    @State private var drawing = PKDrawing()
    @State private var toolPickerIsActive: Bool = true
    @EnvironmentObject var viewModel: EnvironmentViewModel

    let action: (UIImage?) -> Void

    var body: some View {
        VStack() {
            Text("Draw your BirthMark")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top,-135)
                .padding(.bottom,0)

            ZStack {
                if let image = tmpImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350, height: 350)
                        .cornerRadius(20)
                        .mask(RoundedRectangle(cornerRadius: 20))
                        .padding(.top,-40)
                        .padding(.bottom,60)
                }
                
                IconDrawingView(drawing: $drawing, toolPickerIsActive: $toolPickerIsActive)
                    .frame(width: 350, height: 350)
                    .cornerRadius(20)
                    .mask(RoundedRectangle(cornerRadius: 20))
                    .padding(.top,-40)
                    .padding(.bottom,60)
            }
      
            Button(action: {
                self.toolPickerIsActive = false
                action(drawing.image(from: CGRect(x: 0, y: 0, width: 350, height: 350), scale: UIScreen.main.scale))
            }) {
                Text("Done")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 72)
                    .padding(.vertical, 20)
                    .background(
                        Color.blue.opacity(0.1)
                            .cornerRadius(20)
                    )
            }
        }
        .padding(.all, 32)
    }
}

struct IconDrawingView: UIViewRepresentable {
    @Binding var drawing: PKDrawing
    @Binding var toolPickerIsActive: Bool
    @EnvironmentObject var viewModel: EnvironmentViewModel
    private let toolPicker = PKToolPicker()

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawing = drawing
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = UIColor.white

        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()

        canvasView.backgroundColor = UIColor.clear
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.drawing = drawing
        toolPicker.setVisible(toolPickerIsActive, forFirstResponder: uiView)
    }

    class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: IconDrawingView

        init(_ parent: IconDrawingView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawing = canvasView.drawing
        }
    }
}
