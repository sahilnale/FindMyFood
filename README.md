# FindMyFood

FindMyFood is a comprehensive social networking app that integrates location-based services to help users discover, share, and manage their favorite food spots. Built with a robust tech stack, it leverages AWS S3 for image storage and Firebase for user authentication and data management.

## Features

- **User Authentication**: Secure login and registration with Firebase Authentication.
- **Profile Management**: Users can update their profile picture and personal information.
- **Friend Management**: Add, remove, and manage friends. Handle friend requests.
- **Post Creation**: Share favorite food spots by creating posts with images and locations.
- **Map Integration**: View and explore posts on a map with dynamic annotations.
- **AWS S3**: Store and manage images using AWS S3.

## Tech Stack

- **Frontend**: SwiftUI
- **Backend**: Firebase Firestore, Firebase Authentication
- **Location Services**: CoreLocation, MapKit
- **Storage**: AWS S3
- **Image Handling**: UIImagePickerController, AWS S3
- **Networking**: Combine, URLSession

## Screenshots

![Login Screen](https://drive.google.com/uc?export=view&id=1yAZ3Pfe8BIjJfMwEBkEqmPp77UoFoMnL)
<a href="https://drive.google.com/uc?export=view&id=<FILEID>"><img src="https://drive.google.com/uc?export=view&id=<FILEID>" style="width: 650px; max-width: 100%; height: auto" title="Click to enlarge picture" />
![Profile Screen](https://drive.google.com/file/d/1vNyqp7eUM9AywcuwsW2YVyn2cKJm1nR2/preview)
![Map View](https://drive.google.com/file/d/1b12JIkcs0zdRIftNpWJRMO_rGzktsWgZ/preview)
![Create Post](https://drive.google.com/file/d/1khQ6ogsQLv-9DG35Dqx1Z8o7i-V1i9wB/preview)


## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/FindMyFood.git
    ```

2. Install dependencies using CocoaPods:
    ```sh
    cd FindMyFood
    pod install
    ```

3. Open the Xcode workspace:
    ```sh
    open FindMyFood.xcworkspace
    ```

4. Configure Firebase:
    - Download your `GoogleService-Info.plist` from the Firebase console.
    - Add the `GoogleService-Info.plist` file to your Xcode project.

5. Configure AWS S3:
    - Set up your AWS S3 bucket.
    - Update your AWS configuration in the app.

## Usage

1. Register or log in to your account.
2. Update your profile with a profile picture.
3. Add friends by searching for them and sending friend requests.
4. Accept or reject friend requests.
5. Create posts by selecting a location on the map and uploading an image.
6. View your friends' posts on the map.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [Firebase](https://firebase.google.com/)
- [AWS S3](https://aws.amazon.com/s3/)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [MapKit](https://developer.apple.com/documentation/mapkit/)
