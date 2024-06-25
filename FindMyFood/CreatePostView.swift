import SwiftUI
import MapKit

struct CreatePostView: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var searchResults = [MKMapItem]()
    @State private var nearbyRestaurants = [MKMapItem]()
    @State private var selectedRestaurant: MKMapItem?

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
            
            MapView(region: $locationManager.region, annotation: selectedRestaurant?.placemark.coordinate)
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
                            selectedRestaurant = item
                            dropPin(for: item)
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
                // Pass the selected restaurant's coordinates back to MainView
                if let selectedRestaurant = selectedRestaurant {
                    selectedLocation = selectedRestaurant.placemark.coordinate
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Select Restaurant")
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

    private func dropPin(for item: MKMapItem) {
        locationManager.region.center = item.placemark.coordinate
        locationManager.region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
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
        CreatePostView(locationManager: LocationManager(), selectedLocation: .constant(nil))
    }
}
