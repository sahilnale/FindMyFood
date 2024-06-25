import SwiftUI
import UIKit

class ProfileManager: ObservableObject {
    @Published var profileImage: UIImage? = UIImage(named: "profile_picture") // Default profile picture
}
