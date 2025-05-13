import UIKit
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    weak var delegate: LocationManagerDelegate?

    private var locationManager: CLLocationManager?
    var latitude: Double = 55.751244
    var longitude: Double = 37.618423
    
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
            delegate?.didUpdateLocation()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        delegate?.didUpdateLocation()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
}
