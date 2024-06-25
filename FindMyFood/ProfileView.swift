import SwiftUI

struct ProfileView: View {
    @Binding var user: User
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack {
            if let profilePicture = user.profilePicture {
                Image(uiImage: profilePicture)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
            }
            Text(user.name)
                .font(.title)
                .padding()

            Button(action: logout) {
                Text("Log Out")
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: 1)
                    )
            }
            .padding()

            Spacer()
        }
        .padding()
    }

    func logout() {
        isLoggedIn = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: .constant(User(name: "Sahil Nale", profilePicture: UIImage(named: "profile"))), isLoggedIn: .constant(true))
    }
}
