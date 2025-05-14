import UIKit
import CoreLocation

//MARK: - Location Manager Delegate
protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation()
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    //MARK: - Properties
    weak var delegate: LocationManagerDelegate?
    private var locationManager: CLLocationManager?
    var latitude: Double = 55.751244
    var longitude: Double = 37.618423
    
    //MARK: - Init
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    //MARK: - Check Location Authorization Status
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

    //MARK: - Did Update Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        delegate?.didUpdateLocation()
    }

    //MARK: - Did Change Authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorizationStatus()
    }
}
