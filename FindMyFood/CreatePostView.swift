import SwiftUI
import MapKit

struct CreatePostView: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var uploadedImage: UIImage?
    @Binding var user: User
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var searchResults = [MKMapItem]()
    @State private var nearbyRestaurants = [MKMapItem]()
    @State private var selectedRestaurant: MKMapItem?
    @State private var showImagePicker = false
    @State private var center = false
    @State private var temporaryAnnotations = [MKPointAnnotation]()

    var onPostAdded: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    // Dismiss the create post view
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
            }

            // MapView showing temporary annotations for selected restaurant
            MapView(region: $locationManager.region, posts: [], temporaryAnnotations: temporaryAnnotations,shouldRecenter: $center)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 300) // Adjust the height as needed

            TextField("Search for restaurants", text: $searchText, onCommit: searchNearby)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: searchText, perform: { value in
                    if value.isEmpty {
                        fetchNearbyRestaurants()
                    }
                })

            ScrollView {
                VStack(spacing: 10) {
                    ForEach(searchText.isEmpty ? sortedRestaurants() : searchResults, id: \.self) { item in
                        Button(action: {
                            selectRestaurant(item)
                        }) {
                            VStack(alignment: .leading) {
                                Text(item.name ?? "Unknown")
                                    .font(.headline)
                                    .foregroundColor(item == selectedRestaurant ? .blue : .primary)
                                Text(item.placemark.title ?? "")
                                    .font(.subheadline)
                                if let distance = calculateDistance(from: item) {
                                    Text(String(format: "%.2f feet away", distance))
                                        .font(.footnote)
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 70)
                            .padding()
                            .background(item == selectedRestaurant ? Color.blue.opacity(0.2) : Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 1)
                            .padding([.leading, .trailing], 5)
                        }
                    }
                }
                .padding([.leading, .trailing, .top], 10)
            }
            .background(Color(.systemGroupedBackground))
            .cornerRadius(10)
            .padding([.leading, .trailing, .top], 10)

            Button(action: {
                showImagePicker = true
            }) {
                Text("Upload Picture")
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.clear)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                PostImagePicker(image: $uploadedImage)
                    .onDisappear {
                        if let selectedRestaurant = selectedRestaurant, let uploadedImage = uploadedImage {
                            user.addPost(image: uploadedImage, location: selectedRestaurant.placemark.coordinate)
                            selectedLocation = selectedRestaurant.placemark.coordinate
                            // Notify MainView about the new post
                            onPostAdded()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            }
        }
        .padding()
        .onAppear(perform: fetchNearbyRestaurants)
    }

    private func fetchNearbyRestaurants() {
        guard let userLocation = locationManager.userLocation else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "restaurant"
        request.region = locationManager.region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Search error: \(String(describing: error?.localizedDescription))")
                return
            }

            let filteredItems = response.mapItems.filter { item in
                let distance = item.placemark.location?.distance(from: userLocation) ?? 0
                return distance <= 304.8 // 1000 feet in meters
            }
            nearbyRestaurants = filteredItems
        }
    }

    private func searchNearby() {
        guard let userLocation = locationManager.userLocation else { return }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = locationManager.region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Search error: \(String(describing: error?.localizedDescription))")
                return
            }

            let filteredItems = response.mapItems.filter { item in
                let distance = item.placemark.location?.distance(from: userLocation) ?? 0
                return distance <= 304.8 // 1000 feet in meters
            }
            searchResults = filteredItems
        }
    }

    private func selectRestaurant(_ restaurant: MKMapItem) {
        selectedRestaurant = restaurant
        dropPin(for: restaurant)
    }

    private func dropPin(for item: MKMapItem) {
        locationManager.region.center = item.placemark.coordinate
        locationManager.region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

        temporaryAnnotations.removeAll()
        let annotation = MKPointAnnotation()
        annotation.coordinate = item.placemark.coordinate
        annotation.title = item.name
        temporaryAnnotations.append(annotation)
    }

    private func calculateDistance(from item: MKMapItem) -> Double? {
        guard let userLocation = locationManager.userLocation else { return nil }
        let distance = item.placemark.location?.distance(from: userLocation) ?? 0
        return distance * 3.28084 // convert meters to feet
    }

    private func sortedRestaurants() -> [MKMapItem] {
        nearbyRestaurants.sorted { (item1, item2) -> Bool in
            guard let distance1 = calculateDistance(from: item1),
                  let distance2 = calculateDistance(from: item2) else {
                return false
            }
            return distance1 < distance2
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView(locationManager: LocationManager(), selectedLocation: .constant(nil), uploadedImage: .constant(nil), user: .constant(User(uid: "fdfd", name: "Sahil Nale", profilePicture: UIImage(named: "profile_picture"))), onPostAdded: {})
    }
}
