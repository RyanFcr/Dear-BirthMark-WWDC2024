import SwiftUI

struct StickerStore {
    static let stickers: [UIImage] = loadStickers()

        private static func loadStickers() -> [UIImage] {
            var stickers: [UIImage] = []
            let numberOfStickers = 30 // 假设你有10个贴纸，根据实际数量调整

            for i in 7...numberOfStickers {
                let stickerName = "sticker\(i)"
                if let stickerImage = UIImage(named: stickerName) {
                    stickers.append(stickerImage)
                }
            }

            return stickers
        }
    
}
struct StickerView: View {
    var stickerImage: UIImage
    @Binding var currentPosition: CGPoint
    @GestureState private var dragState = CGSize.zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    

    var body: some View {
            Image(uiImage: stickerImage)
                .resizable()
                .scaledToFit()
                .frame(width: 85 * scale, height: 85 * scale) // 应用缩放比例
                .rotationEffect(rotation) // 应用旋转角度
                .offset(x: currentPosition.x + dragState.width, y: currentPosition.y + dragState.height)
                .gesture(
                    DragGesture()
                        .updating($dragState, body: { (value, state, transaction) in
                            state = value.translation
                        })
                        .onEnded { value in
                            self.currentPosition.x += value.translation.width
                            self.currentPosition.y += value.translation.height
                        }
                )
                .overlay(
                    Rectangle() // 这是选中时的边框
                        .stroke(Color.blue, lineWidth: scale > 1 ? 3 : 0) // 当缩放时显示边框
                )
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            self.scale = value
                        }
                        .onEnded { _ in
                            // 这里你可以选择保留缩放，或者重置
                        }
                )
                .gesture(
                    RotationGesture()
                        .onChanged { angle in
                            self.rotation = angle
                        }
                        .onEnded { _ in
                            // 这里你可以选择保留旋转，或者重置
                        }
                )
                .simultaneousGesture(DragGesture(), including: .subviews) // 这允许同时拖动
        }
}

struct EndingView: View {
    let appIcon: UIImage?
    let lightGray = Color(red: 0.95, green: 0.95, blue: 0.95)


    @State private var selectedStickers: [(image: UIImage, position: CGPoint)] = []
    @State private var isDragging = false
    
    var body: some View {
            NavigationStack {
                ZStack {
//                    AppColors.lightBg.ignoresSafeArea()

                    ScrollView {
                        VStack() {
                            Text("My Mark")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .padding(.top,-30)
                                .padding(.bottom,70)
                                

                            ZStack {
                                if let icon = appIcon {
                                    Image(uiImage: icon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 350, height: 350)
                                        .background(Color.white)
                                        .cornerRadius(20)
                                        .padding(.bottom, 10)

                                    ForEach(Array(zip(selectedStickers.indices, selectedStickers)), id: \.0) { index, sticker in
                                                                    StickerView(stickerImage: sticker.image, currentPosition: $selectedStickers[index].position)
                                                                
                                    }
                                } else {
                                    Rectangle()
                                        .frame(width: 350, height: 350)
                                        .cornerRadius(20)
                                        .opacity(0.1)
                                        .padding(.bottom, 10)
                                }
                            }
                            .frame(width: 350, height: 350)
                            .cornerRadius(20)

                            Divider().background(Color.white)

                           Text("Stickers")
                               .font(.headline)
                               .foregroundColor(.black)
                               .frame(maxWidth: .infinity, alignment: .leading)
                               .padding(.leading)
                               .background(Color.white) // 文本背景为白色

                           LazyVGrid(columns: [GridItem(.fixed(60), spacing: 20), GridItem(.fixed(100), spacing: 0), GridItem(.fixed(100), spacing: 10)], spacing: 10) {
                               ForEach(StickerStore.stickers, id: \.self) { sticker in
                                   Image(uiImage: sticker)
                                       .resizable()
                                       .frame(width: 80, height: 80)
                                       .background(lightGray)
                                       .cornerRadius(8)
                                       .onTapGesture {
                                           self.selectedStickers.append((sticker, CGPoint(x: 0, y: -30))) // Adjust position as needed
                                       }
                               }
                           }
                           .padding(.horizontal)
                           .background(Color.white) // 设置贴續背景为白色
                        }
                        .padding(.all, 40)
                        .background(Color.white) // 设置贴續背景为白色
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
}

struct EndingView_Previews: PreviewProvider {
    static var previews: some View {
        EndingView(appIcon: nil)
    }
}
