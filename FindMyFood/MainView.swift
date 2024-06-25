import SwiftUI
import CoreLocation

struct MainView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var profileManager = ProfileManager()
    @State private var isLoggedIn = false
    @State private var showCreatePost = false
    @State private var showProfile = false
    @State private var showFriends = false
    @State private var selectedLocation: CLLocationCoordinate2D?

    var body: some View {
        ZStack {
            if isLoggedIn {
                MapView(region: $locationManager.region, annotation: selectedLocation)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showProfile = true
                        }) {
                            if let profileImage = profileManager.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60) // Make the profile button the same size as the add post button
                                    .padding(4)
                            } else {
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .padding(15)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 2)
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
        .sheet(isPresented: $showCreatePost) {
            CreatePostView(locationManager: locationManager, selectedLocation: $selectedLocation)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(profileManager: profileManager, isLoggedIn: $isLoggedIn)
        }
        .sheet(isPresented: $showFriends) {
            FriendListView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
