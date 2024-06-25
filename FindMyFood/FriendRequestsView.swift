import SwiftUI

struct FriendRequestsView: View {
    @Binding var user: User

    var body: some View {
        VStack {
            Text("Friend Requests")
                .font(.largeTitle)
                .padding()

            List {
                ForEach(user.friendRequests, id: \.self) { request in
                    HStack {
                        if let profileImage = request.profilePicture {
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
                        Text(request.name)
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            acceptFriendRequest(request)
                        }) {
                            Text("Accept")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        Button(action: {
                            rejectFriendRequest(request)
                        }) {
                            Text("Reject")
                                .foregroundColor(.red)
                        }
                        .padding()
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding()
    }

    private func acceptFriendRequest(_ request: User) {
        user.acceptFriendRequest(request)
    }

    private func rejectFriendRequest(_ request: User) {
        user.rejectFriendRequest(request)
    }
}

struct FriendRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendRequestsView(user: .constant(User(name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"), friendRequests: [
            User(name: "John Doe", profilePicture: UIImage(named: "profile_picture"))
        ])))
    }
}
