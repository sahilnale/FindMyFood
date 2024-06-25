import UIKit
import CoreLocation

class User: Hashable, Equatable {
    var name: String
    var profilePicture: UIImage?
    var posts: [Post]
    var friends: [User]

    init(name: String, profilePicture: UIImage? = nil, friends: [User] = []) {
        self.name = name
        self.profilePicture = profilePicture
        self.posts = []
        self.friends = friends
    }

    func addPost(image: UIImage, location: CLLocationCoordinate2D) {
        let post = Post(image: image, location: location)
        posts.append(post)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.name == rhs.name && lhs.profilePicture == rhs.profilePicture
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(profilePicture)
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
}
