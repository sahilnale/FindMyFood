import SwiftUI

struct FriendListView: View {
    @Binding var user: User
    @State private var showFriendRequests = false
    @State private var friends: [User]

    init(user: Binding<User>) {
        self._user = user
        self._friends = State(initialValue: user.wrappedValue.friends)
    }

    var body: some View {
        VStack {
            HStack {
                Text("Friends")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Button(action: {
                    showFriendRequests = true
                }) {
                    Image(systemName: "person.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                }
            }

            List {
                ForEach(friends, id: \.self) { friend in
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
                        Spacer()
                        Button(action: {
                            removeFriend(friend)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .padding()
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
        .sheet(isPresented: $showFriendRequests) {
            FriendRequestsView(user: $user)
        }
    }

    private func removeFriend(_ friend: User) {
        user.removeFriend(friend)
        friends = user.friends // Update the local state to trigger a rerender
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
