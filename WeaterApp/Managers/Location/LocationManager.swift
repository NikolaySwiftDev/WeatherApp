import UIKit
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(lat: Double, lon: Double)
}


class LocationManager: NSObject, CLLocationManagerDelegate {

    weak var delegate: LocationManagerDelegate?

    private var locationManager: CLLocationManager?
    var latitude: Double?
    var longitude: Double?
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    private func checkLocationAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            latitude = 55.751244
            longitude = 37.618423
            delegate?.didUpdateLocation(lat: latitude!, lon: longitude!)
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        delegate?.didUpdateLocation(lat: latitude!, lon: longitude!)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
        latitude = 55.751244
        longitude = 37.618423
//        delegate?.didUpdateLocation(lat: latitude!, lon: longitude!)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
}
