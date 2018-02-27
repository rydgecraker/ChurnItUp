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
import SpriteKit
import GameplayKit

class GetLocationViewController: UIViewController {

    
    var dontKnowLocationYet: Bool = true
    
    var findingCow: Bool = true
    var latChanged: Bool = false
    var lonChanged: Bool = false
    var performingSegue: Bool = false
    var compass: SKSpriteNode!
    
    var player: Player!
    
    var latitude: Double = 0.0 {
        
        didSet {
            
            if latChanged && lonChanged {
                latChanged = false
                lonChanged = false
                locationUpdated()
            }
            
        }
        
    }
    
    var longitude: Double = 0.0
    
    var facingAngleRadians: Double = 0.0
    
    var cowLat: Double = 0.0
    var cowLon: Double = 0.0
    
    var distanceXtoCow: Double = 0.0 //Longitude
    var distanceYtoCow: Double = 0.0 //Latitude
    
    //69 Miles per degree of Latitude, 1609m per mile results in this. (rounded)
    let oneMeterInLatitudeDegrees = 0.000009
    
    //Because longitude changes with latitude, the distance between longitude lines must be calculated on the spot. with cos(latitudeDegrees) * mileDistance at the equator (69.172 miles between each line)
    func getOneMeterInLongitudeDegrees(latitudeDegrees: Double) -> Double{
        let oneMileDegrees = cos((latitudeDegrees * .pi ) / 180) * 69.172
        return oneMileDegrees / 1069.34
    }
    
    func locationUpdated() {
        if dontKnowLocationYet {
            dontKnowLocationYet = false
            plopCow()
        }
        
        calculateCowDistance()
        compass.zRotation = CGFloat(atan2(distanceYtoCow, distanceXtoCow) + facingAngleRadians)
        let distXMeters = distanceXtoCow / getOneMeterInLongitudeDegrees(latitudeDegrees: latitude)
        let distYMeters = distanceYtoCow / oneMeterInLatitudeDegrees
        
        var distance = ((distYMeters * distYMeters) + (distXMeters * distXMeters)).squareRoot()
        
        //TODO: Remove this
        distance = 0
        
        if(distance < 5 && !performingSegue){
            performingSegue = true
            performSegue(withIdentifier: "CowCapture", sender: self)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is CaptureCows
        {
            let cc = segue.destination as? CaptureCows
            cc?.player = self.player
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func calculateCowDistance() {
        distanceYtoCow = cowLat - latitude
        distanceXtoCow = cowLon - longitude
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let findCowScene = FindCowsScene(size: skView.bounds.size)
        
        findCowScene.scaleMode = .aspectFill
        
        findCowScene.backgroundColor = SKColor.white
        
        skView.presentScene(findCowScene)
        compass = findCowScene.children[0] as! SKSpriteNode
        
        dontKnowLocationYet = true
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
        
    }
    
    func plopCow(){
        let cowLatChangeInMeters = Double(arc4random_uniform(30) + 30) * getNegOneOrOne()
        cowLat = getCowLatitude(cowLatChangeInMeters: cowLatChangeInMeters)
        let cowLonChangeInMeters = Double(arc4random_uniform(30) + 30) * getNegOneOrOne()
        cowLon = getCowLongitude(cowLonChangeInMeters: cowLonChangeInMeters, cowLat: cowLat)
    }
    
    func getCowLatitude(cowLatChangeInMeters: Double) -> Double {
        let cowLatChangeInDegrees = oneMeterInLatitudeDegrees * cowLatChangeInMeters
        return latitude + cowLatChangeInDegrees
    }
    
    func getCowLongitude(cowLonChangeInMeters: Double, cowLat: Double) -> Double {
        let cowLonChangeInDegrees = getOneMeterInLongitudeDegrees(latitudeDegrees: cowLat) * cowLonChangeInMeters
        return longitude + cowLonChangeInDegrees
    }

}

func getNegOneOrOne() -> Double {
    let num = arc4random_uniform(2)
    if num == 0 {
        return -1
    } else {
        return 1
    }
}


//Info.plist notification is needed to get user's location along with the CLLocationDelgate.
extension GetLocationViewController: CLLocationManagerDelegate {
    
    //This fuction updates whenever the user's location updates and stores the lat and long values into the variables.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = locValue.latitude
        longitude = locValue.longitude
        latChanged = true
        lonChanged = true
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        facingAngleRadians = toRadians(newHeading.trueHeading)
        compass.zRotation = CGFloat(atan2(distanceYtoCow, distanceXtoCow) + facingAngleRadians)
        //self.imageView.transform = CGAffineTransform(rotationAngle: angle) // rotate the picture
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
    
    func toRadians(_ degrees: Double) -> Double {
        return (degrees * .pi) / 180
    }
    
    func toDegrees(_ radians: Double) -> Double {
        return radians * (180 / .pi)
    }
    
}
