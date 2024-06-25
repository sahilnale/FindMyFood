import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var annotations: [Post]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        let mapAnnotations = annotations.map { post -> CustomAnnotation in
            return CustomAnnotation(coordinate: post.location, image: post.image)
        }
        uiView.addAnnotations(mapAnnotations)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }

            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)

            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            } else {
                annotationView?.annotation = annotation
            }

            if let customAnnotation = annotation as? CustomAnnotation {
                let bubbleView = SpeechBubbleView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
                bubbleView.image = customAnnotation.image

                annotationView?.addSubview(bubbleView)
                bubbleView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    bubbleView.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor),
                    bubbleView.bottomAnchor.constraint(equalTo: annotationView!.topAnchor, constant: 10) // Adjust to align correctly
                ])
            }

            return annotationView
        }
    }

    class CustomAnnotation: NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var image: UIImage?
        var title: String? = ""

        init(coordinate: CLLocationCoordinate2D, image: UIImage?) {
            self.coordinate = coordinate
            self.image = image
        }
    }
}
