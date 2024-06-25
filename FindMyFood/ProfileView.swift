import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileManager: ProfileManager
    @Environment(\.presentationMode) var presentationMode
    @Binding var isLoggedIn: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Dismiss the profile view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            }

            ZStack {
                if let profileImage = profileManager.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                        .padding()
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()
                }

                Button(action: {
                    self.showingImagePicker = true
                }) {
                    Text("Edit")
                        .font(.caption)
                        .padding(5)
                        .background(Color.black.opacity(0.75))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .offset(x: 50, y: 50)
            }

            Text("Sahil Nale")
                .font(.largeTitle)
                .padding()

            Spacer()

            Button(action: {
                // Log out action
                isLoggedIn = false
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Log Out")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(selectedImage: self.$inputImage)
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileManager.profileImage = inputImage
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileManager: ProfileManager(), isLoggedIn: .constant(true))
    }
}
