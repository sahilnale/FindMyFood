import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()

    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    private init() {
        self.userSession = Auth.auth().currentUser
        if self.userSession != nil {
            Task {
                await fetchUser()
            }
        } else {
            // No user session found, ensure everything is reset
            DispatchQueue.main.async {
                self.userSession = nil
                self.currentUser = nil
            }
        }
    }

    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            await fetchUser()
        } catch {
            print("Failed to sign in: \(error.localizedDescription)")
            throw error
        }
    }

    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            let data: [String: Any] = [
                "email": email,
                "fullname": fullname,
                "uid": result.user.uid,
                "profilePicture": "",
                "posts": [],
                "friends": [],
                "friendRequests": []
            ]
            Firestore.firestore().collection("users").document(result.user.uid).setData(data) { _ in
                Task {
                    await self.fetchUser()
                }
            }
        } catch {
            print("Failed to create user: \(error.localizedDescription)")
            throw error
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userSession = nil
                self.currentUser = nil
            }
        } catch {
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }

    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.userSession = nil
                self.currentUser = nil
            }
            return
        }

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, _ in
            guard let data = snapshot?.data() else {
                DispatchQueue.main.async {
                    self.userSession = nil
                    self.currentUser = nil
                }
                return
            }

            if let user = User.fromDictionary(data) {
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            } else {
                DispatchQueue.main.async {
                    self.userSession = nil
                    self.currentUser = nil
                }
            }
        }
    }

    func updateUserData(_ user: User) async {
        do {
            let data = user.toDictionary()
            try await Firestore.firestore().collection("users").document(user.uid).setData(data)
        } catch {
            print("Failed to update user: \(error.localizedDescription)")
        }
    }
}
