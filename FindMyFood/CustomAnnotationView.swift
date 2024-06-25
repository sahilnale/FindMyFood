import UIKit
import MapKit

class CustomAnnotationView: MKAnnotationView {
    static let identifier = "CustomAnnotationView"

    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? MapView.CustomAnnotation else { return }

            canShowCallout = false

            let bubbleView = SpeechBubbleView(frame: CGRect(x: 0, y: 0, width: 100, height: 120))
            bubbleView.image = customAnnotation.image

            addSubview(bubbleView)
            bubbleView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                bubbleView.centerXAnchor.constraint(equalTo: centerXAnchor),
                bubbleView.bottomAnchor.constraint(equalTo: topAnchor, constant: 10) // Adjust to align correctly
            ])
        }
    }
}

class SpeechBubbleView: UIView {
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    private let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 80, height: 80))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true

        super.init(frame: frame)

        backgroundColor = .clear
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let bubbleRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height - 20)
        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: 10)

        // Draw the pointer
        let pointerPath = UIBezierPath()
        let pointerSize: CGFloat = 10
        pointerPath.move(to: CGPoint(x: bubbleRect.midX - pointerSize, y: bubbleRect.maxY))
        pointerPath.addLine(to: CGPoint(x: bubbleRect.midX, y: bubbleRect.maxY + pointerSize))
        pointerPath.addLine(to: CGPoint(x: bubbleRect.midX + pointerSize, y: bubbleRect.maxY))
        pointerPath.close()

        UIColor.white.setFill()
        path.fill()
        pointerPath.fill()
    }
}
