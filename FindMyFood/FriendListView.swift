import SwiftUI

struct FriendListView: View {
    @ObservedObject var user: User
    @State private var showFriendRequests = false
    @State private var showAddFriends = false
    @State private var isDeleteMode = false
    @State private var forceRefresh = false
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
                        .frame(width: 25, height: 25) // Adjusted icon size
                        .padding(.horizontal, 10) // Reduced horizontal padding
                }
                Spacer()
                Text("Friends")
                    .font(.largeTitle) // Adjusted font size
                    .padding(.horizontal, 10) // Reduced horizontal padding
                Spacer()
                Button(action: {
                    showAddFriends = true
                }) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25) // Adjusted icon size
                        .padding(.horizontal, 10) // Reduced horizontal padding
                }
                Button(action: {
                    showFriendRequests = true
                }) {
                    Image(systemName: "envelope.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25) // Adjusted icon size
                        .padding(.horizontal, 10) // Reduced horizontal padding
                }
                Button(action: {
                    isDeleteMode.toggle()
                }) {
                    Image(systemName: "trash.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25) // Adjusted icon size
                        .padding(.horizontal, 10) // Reduced horizontal padding
                        .foregroundColor(isDeleteMode ? .red : .primary)
                }
            }

            List {
                ForEach(user.friends, id: \.self) { friend in
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
                            .padding(.trailing, 10) // Reduced trailing padding
                        Spacer()
                        if isDeleteMode {
                            Button(action: {
                                removeFriend(friend)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 5) // Reduced horizontal padding
                                    .padding(.vertical, 2) // Reduced vertical padding
                            }
                        }
                    }
                    .padding(.vertical, 5) // Reduced vertical padding for each row
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(10) // Reduced overall padding
        .sheet(isPresented: $showFriendRequests) {
            FriendRequestsView(user: user)
        }
        .sheet(isPresented: $showAddFriends) {
            AddFriendsView(user: user)
        }
        .onChange(of: forceRefresh) { _ in
            // This will trigger a re-render when forceRefresh changes
        }
    }

    private func removeFriend(_ friend: User) {
        // Update the user object directly, which is observed by the view
        if let index = user.friends.firstIndex(of: friend) {
            user.friends.remove(at: index)
            forceRefresh.toggle() // Trigger a re-render
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView(user: User(name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"), friends: [
            User(name: "Nikhil Kichili", profilePicture: UIImage(named: "profile_picture")),
            User(name: "Krishna Dua", profilePicture: UIImage(named: "profile_picture")),
            User(name: "Dhruv Patak", profilePicture: UIImage(named: "profile_picture"))
        ]))
    }
}
