import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var posts: [Post]
    var temporaryAnnotations: [MKPointAnnotation]
    @Binding var shouldRecenter: Bool

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if shouldRecenter {
            uiView.setRegion(region, animated: true)
            DispatchQueue.main.async {
                shouldRecenter = false // Reset the flag after recentering
            }
        }

        uiView.removeAnnotations(uiView.annotations)
        
        let postAnnotations = posts.map { post -> CustomAnnotation in
            return CustomAnnotation(coordinate: post.location, image: post.image)
        }
        
        uiView.addAnnotations(postAnnotations)
        uiView.addAnnotations(temporaryAnnotations)
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

            if let customAnnotation = annotation as? CustomAnnotation {
                let identifier = "CustomAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }

                let bubbleView = SpeechBubbleView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
                bubbleView.image = customAnnotation.image

                annotationView?.addSubview(bubbleView)
                bubbleView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    bubbleView.centerXAnchor.constraint(equalTo: annotationView!.centerXAnchor),
                    bubbleView.bottomAnchor.constraint(equalTo: annotationView!.topAnchor, constant: 10) // Adjust to align correctly
                ])
                return annotationView
            } else if annotation is MKPointAnnotation {
                let identifier = "TemporaryAnnotation"
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                if annotationView == nil {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                return annotationView
            }
            return nil
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
