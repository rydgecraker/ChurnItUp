//
//  GetLocationViewController.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/13/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GetLocationViewController: UIViewController {

    
    var findingCow: Bool = true
    var latChanged: Bool = false
    var lonChanged: Bool = false
    
    var latitude: Double = 0.0 {
        
        didSet {
            
            if latChanged && lonChanged {
                latChanged = false;
                lonChanged = false;
                locationUpdated();
            }
            
        }
        
    }
    
    var longitude: Double = 0.0
    
    var cowLat: Double = 0.0
    var cowLon: Double = 0.0
    
    var distanceXtoCow: Double = 0.0
    var distanceYtoCow: Double = 0.0
    
    //69 Miles per degree of Latitude, 1609m per mile results in this. (rounded)
    let oneMeterInLatitudeDegrees = 0.000009
    
    //Because longitude changes with latitude, the distance between longitude lines must be calculated on the spot. with cos(latitudeDegrees) * mileDistance at the equator (69.172 miles between each line)
    func getOneMeterInLongitudeDegrees(latitudeDegrees: Double) -> Double{
        let oneMileDegrees = cos(latitudeDegrees) * 69.172
        return oneMileDegrees / 1069.34
    }
    
    func locationUpdated() {
        calculateCowDistance()
        print("The cow is \(distanceXtoCow) degrees X away (longitude), the cow is \(distanceYtoCow) degrees Y away (latitude)")
    }
    
    func calculateCowDistance() {
        distanceYtoCow = cowLat - latitude
        distanceXtoCow = cowLon - longitude
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        plopCow()
        
    }
    
    func plopCow(){
        print("CurrentLocation: \(longitude) long and \(latitude) lat")
        let cowLatChangeInMeters = convert0to60toNeg30to30(Double (arc4random_uniform(60)) + 1.0)
        cowLat = getCowLatitude(cowLatChangeInMeters: cowLatChangeInMeters)
        let cowLonChangeInMeters = convert0to60toNeg30to30(Double (arc4random_uniform(60)) + 1.0)
        cowLon = getCowLongitude(cowLonChangeInMeters: cowLonChangeInMeters, cowLat: cowLat)
        print("Cow is going to be \(cowLonChangeInMeters) meters lat and \(cowLonChangeInMeters) meters lon")
        print("That means the cow will be \(cowLat) degrees lat and \(cowLon) degrees lon")
    }
    
    func getCowLatitude(cowLatChangeInMeters: Double) -> Double {
        let cowLatChangeInDegrees = oneMeterInLatitudeDegrees * cowLatChangeInMeters
        return latitude + cowLatChangeInDegrees
    }
    
    func getCowLongitude(cowLonChangeInMeters: Double, cowLat: Double) -> Double {
        let cowLonChangeInDegrees = getOneMeterInLongitudeDegrees(latitudeDegrees: cowLat) * cowLonChangeInMeters
        return longitude * cowLonChangeInDegrees
    }
    
    func convert0to60toNeg30to30(_ number: Double) -> Double {
        if(number > 30){
            return number - 61 //Will never return 0. Returns [-30, -1] and [1, 30]
        }
        return number
    }

}


//Info.plist notification is needed to get user's location along with the CLLocationDelgate.
extension GetLocationViewController: CLLocationManagerDelegate {
    
    //This fuction updates whenever the user's location updates and stores the lat and long values into the variables.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latChanged = true
        lonChanged = true
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled", message: "In order to help you find cows, we need your location!", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
