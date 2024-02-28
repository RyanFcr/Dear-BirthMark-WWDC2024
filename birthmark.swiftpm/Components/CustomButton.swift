import SwiftUI

struct CustomButton: View {
    let text: String
    let action: () -> Void

    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 72)
                .padding(.vertical, 20)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.1)))
                .background(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.2), lineWidth: 1))
                .foregroundColor(.white)
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(text: "테스트") {

        }
    }
}
