import SwiftUI
import PhotosUI


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
@available(iOS 17.0, *)
struct SelectPhotoView: View {
    
    
    let onboardingEnd: () -> Void
    @State private var selected: PhotosPickerItem?
    @EnvironmentObject var viewModel: EnvironmentViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Select a Photo of your Birthmark").font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                Image(uiImage: viewModel.image ?? UIImage(named: "Logo")!)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .padding()
                Spacer()
                HStack{
                    Spacer()
                    PhotosPicker(selection: $selected, matching: .images, photoLibrary: .shared()) {
                        Text("Select a photo")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .background(Color(hex:"03B6A2").opacity(0.5))
                            .cornerRadius( 10)
                    }
                    .onChange(of: selected, initial: false) { old, item in
                        Task(priority: .background) {
                            if let data = try? await item?.loadTransferable(type: Data.self) {
                                withAnimation(.spring){
                                    viewModel.image = UIImage(data: data)
                                    tmpImage = UIImage(data: data)
                                }
                                
                            }
                        }
                    }
                    Spacer()
                    if viewModel.image != nil{
                        Button(action:{
                            onboardingEnd()
                        }){
                            Text("Confirm!")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                                .background(Color(hex:"03B6A2").opacity(0.5))
                                .cornerRadius( 10)
                        }
                        Spacer()
                    }
                    
                }
            }
        }
    }
}
