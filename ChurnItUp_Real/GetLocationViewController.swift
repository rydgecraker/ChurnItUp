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

    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    //69 Miles per degree of Latitude, 1609m per mile results in this. (rounded)
    let oneMeterInLatitudeDegrees = 0.000009
    
    //Because longitude changes with latitude, the distance between longitude lines must be calculated on the spot. with cos(latitudeDegrees) * mileDistance at the equator (69.172 miles between each line)
    func getOneMeterInLongitudeDegrees(latitudeDegrees: CGFloat) -> CGFloat{
        let oneMileDegrees = cos(latitudeDegrees) * 69.172
        return oneMileDegrees / 1069.34
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
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        plopCow()
        
    }
    
    func plopCow(){
        print("CurrentLocation \(longitude) long and lat \(latitude)")
    }
    
    

}


//Info.plist notification is needed to get user's location along with the CLLocationDelgate.
extension GetLocationViewController: CLLocationManagerDelegate {
    
    //This fuction updates whenever the user's location updates and stores the lat and long values into the variables.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
}
