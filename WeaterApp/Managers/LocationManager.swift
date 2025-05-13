import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    
    private let manager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D) -> Void)?
    
    func getUserLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        self.completion = completion
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            completion?(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        // Координаты Москвы по умолчанию
        let moscowCoordinates = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)
        completion?(moscowCoordinates)
    }
}
