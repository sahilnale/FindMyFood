import SwiftUI

struct ProfileView: View {
    @Binding var user: User
    @Binding var isLoggedIn: Bool
    @State private var showImagePicker = false
    @State private var newProfileImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                if let profilePicture = user.profilePicture {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            showImagePicker = true
                        }
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .onTapGesture {
                            showImagePicker = true
                        }
                }
                
                // Edit icon overlay
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color.white)
                    .clipShape(Circle())
                    .offset(x: -10, y: -10)
                    .onTapGesture {
                        showImagePicker = true
                    }
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
        .sheet(isPresented: $showImagePicker, onDismiss: updateProfilePicture) {
            ImagePicker(image: $newProfileImage)
        }
    }

    private func updateProfilePicture() {
        if let newProfileImage = newProfileImage {
            user.profilePicture = newProfileImage
        }
    }

    private func logout() {
        isLoggedIn = false
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: .constant(User(name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"))), isLoggedIn: .constant(true))
    }
}
