import SwiftUI
import CoreLocation
import MapKit

struct MainView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var isLoggedIn = false
    @State private var showCreatePost = false
    @State private var showProfile = false
    @State private var showFriends = false
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var uploadedImage: UIImage?
    @State private var user = User(name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"), friends: [
        User(name: "Nikhil Kichili", profilePicture: UIImage(named: "profile_picture")),
        User(name: "Krishna Dua", profilePicture: UIImage(named: "profile_picture")),
        User(name: "Dhruv Patak", profilePicture: UIImage(named: "profile_picture"))
    ])
    @State private var annotations = [Post]()
    @State private var forceRefresh = false

    var body: some View {
        ZStack {
            if isLoggedIn {
                MapView(region: $locationManager.region, posts: annotations, temporaryAnnotations: [])
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showProfile = true
                        }) {
                            if let profileImage = user.profilePicture {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60)
                                    .padding(4)
                                    .id(forceRefresh) // Force re-render
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(15)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                                    .id(forceRefresh) // Force re-render
                            }
                        }
                        .frame(width: 60, height: 60)
                        .padding([.trailing, .top], 10)
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 10) { // Reduced spacing between buttons
                            Button(action: {
                                showFriends = true
                            }) {
                                Image(systemName: "person.2.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(10)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
                            }
                            .frame(width: 50, height: 50)
                            Button(action: {
                                showCreatePost = true
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.blue)
                                    .padding(4)
                            }
                        }
                        .padding([.bottom, .trailing], 10) // Reduced padding to bring buttons closer to the edge
                    }
                }
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
        .onAppear {
            annotations = user.posts
        }
        .onChange(of: user.posts) { newPosts in
            annotations = newPosts
        }
        .sheet(isPresented: $showCreatePost) {
            CreatePostView(locationManager: locationManager, selectedLocation: $selectedLocation, uploadedImage: $uploadedImage, user: $user) {
                annotations = user.posts // Update the annotations explicitly
            }
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(user: $user, isLoggedIn: $isLoggedIn, onProfilePictureChanged: {
                forceRefresh.toggle() // Trigger re-render
            })
        }
        .sheet(isPresented: $showFriends) {
            FriendListView(user: user)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
