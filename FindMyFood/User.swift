import UIKit
import CoreLocation
import FirebaseFirestore

class User: Hashable, Equatable, ObservableObject, Identifiable {
    var uid: String
    var name: String
    var profilePicture: UIImage?
    var posts: [Post]
    var friends: [User]
    var friendRequests: [User]

    init(uid: String, name: String, profilePicture: UIImage? = nil, friends: [User] = [], friendRequests: [User] = []) {
        self.uid = uid
        self.name = name
        self.profilePicture = profilePicture
        self.posts = []
        self.friends = friends
        self.friendRequests = friendRequests
    }

    func addPost(image: UIImage, location: CLLocationCoordinate2D) {
        let post = Post(image: image, location: location)
        posts.append(post)
    }

    func addFriend(_ friend: User) {
        friends.append(friend)
    }

    func removeFriend(_ friend: User) {
        friends.removeAll { $0 == friend }
    }

    func addFriendRequest(_ user: User) {
        friendRequests.append(user)
    }

    func acceptFriendRequest(_ user: User) {
        friendRequests.removeAll { $0 == user }
        addFriend(user)
    }

    func rejectFriendRequest(_ user: User) {
        friendRequests.removeAll { $0 == user }
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.uid == rhs.uid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }

    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "profilePicture": profilePicture?.pngData()?.base64EncodedString() ?? "",
            "posts": posts.map { $0.toDictionary() },
            "friends": friends.map { $0.uid },
            "friendRequests": friendRequests.map { $0.uid }
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> User? {
        guard let uid = dict["uid"] as? String,
              let name = dict["name"] as? String else { return nil }
        
        let profilePictureData = Data(base64Encoded: dict["profilePicture"] as? String ?? "")
        let profilePicture = profilePictureData != nil ? UIImage(data: profilePictureData!) : nil

        let postsData = dict["posts"] as? [[String: Any]] ?? []
        let posts = postsData.compactMap { Post.fromDictionary($0) }

        // Friends and friendRequests are just UID lists, which should be resolved after fetching user data
        let friendsUIDs = dict["friends"] as? [String] ?? []
        let friendRequestsUIDs = dict["friendRequests"] as? [String] ?? []

        let user = User(uid: uid, name: name, profilePicture: profilePicture)
        user.posts = posts
        // Friends and friend requests should be resolved with actual User instances
        user.friends = friendsUIDs.map { User(uid: $0, name: "", profilePicture: nil) }
        user.friendRequests = friendRequestsUIDs.map { User(uid: $0, name: "", profilePicture: nil) }

        return user
    }
}

class Post: Equatable, Hashable {
    var image: UIImage
    var location: CLLocationCoordinate2D

    init(image: UIImage, location: CLLocationCoordinate2D) {
        self.image = image
        self.location = location
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.image == rhs.image && lhs.location.latitude == rhs.location.latitude && lhs.location.longitude == rhs.location.longitude
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(location.latitude)
        hasher.combine(location.longitude)
    }

    func toDictionary() -> [String: Any] {
        return [
            "image": image.pngData()?.base64EncodedString() ?? "",
            "latitude": location.latitude,
            "longitude": location.longitude
        ]
    }

    static func fromDictionary(_ dict: [String: Any]) -> Post? {
        guard let imageDataString = dict["image"] as? String,
              let imageData = Data(base64Encoded: imageDataString),
              let image = UIImage(data: imageData),
              let latitude = dict["latitude"] as? CLLocationDegrees,
              let longitude = dict["longitude"] as? CLLocationDegrees else { return nil }

        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return Post(image: image, location: location)
    }
}
