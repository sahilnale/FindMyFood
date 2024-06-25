import SwiftUI

struct FriendListView: View {
    @Binding var user: User

    var body: some View {
        VStack {
            Text("Friends")
                .font(.largeTitle)
                .padding()

            List(user.friends, id: \.self) { friend in
                HStack {
                    if let profileImage = friend.profilePicture {
                        Image(uiImage: profileImage)
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 50, height: 50)
                            .padding(4)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .padding(4)
                    }
                    Text(friend.name)
                        .font(.headline)
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView(user: .constant(User(name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"), friends: [
            User(name: "Nikhil Kichili", profilePicture: UIImage(named: "profile_picture")),
            User(name: "Krishna Dua", profilePicture: UIImage(named: "profile_picture")),
            User(name: "Dhruv Patak", profilePicture: UIImage(named: "profile_picture"))
        ])))
    }
}
