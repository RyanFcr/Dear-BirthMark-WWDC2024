import SwiftUI

struct TableOfContentsView: View {
    let end: () -> Void
    var body: some View {
        ZStack{
            Image("Background")
                .resizable()
                .frame(width: .infinity)
                .background(Color.red)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Image("TitleText")
                Spacer()
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding()
                Button(action: {
                    end()
                    
                }){
                    Image("titleButton")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                

                Spacer()
                
            }
        }
        
    }
}
