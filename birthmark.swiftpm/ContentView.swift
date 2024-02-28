import SwiftUI

class EnvironmentViewModel:ObservableObject{
    @Published var image: UIImage?
    init() {
    }
}

var tmpImage: UIImage?

@available(iOS 17.0, *)
struct ContentView: View {
    @State private var viewType: ViewType = .tableOfCotents
    @State var image: UIImage?
    @EnvironmentObject var viewModel:EnvironmentViewModel
    var body: some View {
        ZStack {
            AppColors.bg0.ignoresSafeArea()
            Group {
                switch viewType {
                case .tableOfCotents:
                    TableOfContentsView {
                        viewType = .selectPhoto
                    }
                case .selectPhoto:
                    SelectPhotoView{
                        viewType = .appIcon
                    }
                case .appIcon:
                    DrawingView { image in
                        self.image = image
                        viewType = .ending
                    }
                case .ending:
                    EndingView(appIcon: image)
                }
            }
        }.environmentObject(EnvironmentViewModel())
    }
}
@available(iOS 17.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

enum ViewType {
    case tableOfCotents
    case selectPhoto
    case appIcon
    case ending
}
