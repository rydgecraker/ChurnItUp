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
    func getOneMeterInLongitudeDegrees(latitudeDegrees: Double) -> Double{
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
        print("CurrentLocation: \(longitude) long and \(latitude) lat")
        let cowLatChangeInMeters = convert0to60toNeg30to30(Double (arc4random_uniform(60)) + 1.0)
        let cowLat = getCowLatitude(cowLatChangeInMeters: cowLatChangeInMeters)
        let cowLonChangeInMeters = convert0to60toNeg30to30(Double (arc4random_uniform(60)) + 1.0)
        let cowLon = getCowLongitude(cowLonChangeInMeters: cowLonChangeInMeters, cowLat: cowLat)
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
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
    
}
