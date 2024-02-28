import SwiftUI

enum Status {
    case editor
    case canvas
    case canvasEditing
}

protocol BlockView: View {
    var status: Status { get set }
}
