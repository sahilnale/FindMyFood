import SwiftUI

struct FriendRequestsView: View {
    @ObservedObject var user: User
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
                Text("Friend Requests")
                    .font(.title2)
                    .padding()
                Spacer()
            }

            List {
                ForEach(user.friendRequests) { request in
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
                                .font(.subheadline)
                        }
                        .padding()
                        Button(action: {
                            rejectFriendRequest(request)
                        }) {
                            Text("Reject")
                                .foregroundColor(.red)
                                .font(.subheadline)
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
        FriendRequestsView(user: User(uid: "sasa", name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"), friendRequests: [
                                      User(uid: "sasad", name: "John Doe", profilePicture: UIImage(named: "profile_picture"))
        ]))
    }
}
