import SwiftUI

struct AddFriendsView: View {
    @ObservedObject var user: User
    @State private var searchText = ""
    @State private var searchResults = [User]()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .padding()
                }
                Spacer()
                Text("Add Friends")
                    .font(.title2)
                    .padding()
                Spacer()
            }

            TextField("Search for friends", text: $searchText, onCommit: searchFriends)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List {
                ForEach(searchResults) { result in
                    HStack {
                        if let profileImage = result.profilePicture {
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
                        Text(result.name)
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            sendFriendRequest(result)
                        }) {
                            Text("Add")
                                .foregroundColor(.blue)
                        }
                        .padding()
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }

    private func searchFriends() {
        // Simulate searching for friends
        searchResults = [
            User(uid: "saas",name: "John Smith", profilePicture: UIImage(named: "profile_picture")),
            User(uid: "sdaas",name: "Jane Doe", profilePicture: UIImage(named: "profile_picture"))
        ].filter { $0.name.contains(searchText) }
    }

    private func sendFriendRequest(_ user: User) {
        // Simulate sending a friend request
        print("Friend request sent to \(user.name)")
    }
}

struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView(user: User(uid: "saafs",name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture")))
    }
}
