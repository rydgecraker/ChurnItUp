//
//  GetLocationViewController.swift
//  ChurnItUp_Real
//
//  Created by Craker, Rydge on 2/13/18.
//  Copyright © 2018 Craker, Rydge. All rights reserved.
//
// This screen is the "Beard Arrow" screen that leads the player to the cow.

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
    var distance: Double = 6.0
    var compass: SKSpriteNode!
    var distanceToNumber: SKLabelNode!
    var distanceToText: SKLabelNode!
    
    var findCowScene: FindCowsScene!
    //Whenver the latitude and lognitude change, call update location.
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
    
    var facingAngleRadians: Double = 0.0 //Facing angle. 0.0 is north. pi is south. Etc.
    
    var cowLat: Double = 0.0 //Cow latitude position
    var cowLon: Double = 0.0 //Cow longitude positon
    
    var distanceXtoCow: Double = 0.0 //Longitude to cow in degrees
    var distanceYtoCow: Double = 0.0 //Latitude to cow in degrees
    
    //69 Miles per degree of Latitude, 1609m per mile results in this. (rounded)
    let oneMeterInLatitudeDegrees = 0.000009
    
    //Because longitude changes with latitude, the distance between longitude lines must be calculated on the spot. with cos(latitudeDegrees) * mileDistance at the equator (69.172 miles between each line)
    func getOneMeterInLongitudeDegrees(latitudeDegrees: Double) -> Double{
        let oneMileDegrees = cos((latitudeDegrees * .pi ) / 180) * 69.172
        return oneMileDegrees / 1069.34
    }
    
    //Whenever the player's locaiton changes, this method is called.
    func locationUpdated() {
        //If a cow hasn't been ploped yet, create a new cow and plop it somewhere.
        if dontKnowLocationYet {
            dontKnowLocationYet = false
            plopCow()
        }
        
        calculateCowDistance()
        
        //Figure out the diagonal distnace in meters from the player to the cow and show it on screen.
        compass.zRotation = CGFloat(atan2(distanceYtoCow, distanceXtoCow) + facingAngleRadians)
        let distXMeters = distanceXtoCow / getOneMeterInLongitudeDegrees(latitudeDegrees: latitude)
        let distYMeters = distanceYtoCow / oneMeterInLatitudeDegrees
        
        distance = ((distYMeters * distYMeters) + (distXMeters * distXMeters)).squareRoot()
        
        //TODO: Update distance number in meters.
        
        findCowScene.updateDistance(distance)
        
        //If the cow is within 5 meters of the player, show the cow and get rid of this screen.
        if(distance < 5 && !performingSegue){
            goToCowScreen()
        }
        
    }
    
    //perform the segue to the cow screen and ensure that it'll only be called once.
    func goToCowScreen(){
        performingSegue = true
        performSegue(withIdentifier: "CowCapture", sender: self)
    }
    
    //Calculate the distance in degrees between the player and the plopped cow.
    func calculateCowDistance() {
        distanceYtoCow = cowLat - latitude
        distanceXtoCow = cowLon - longitude
    }
    
    // Create a new instance of CLLocationManager to keep track of location and compass rotation.
    let locationManager = CLLocationManager()
    
    //This funciton should be removed in the final product. It skips this screen entirely and jumps right to the cow screen. The reason it's here is because we're testing on devices without locaiton services so we can't get accurate data to find the cow.
    override func viewDidAppear(_ bool: Bool) {
        super.viewDidAppear(bool)
        goToCowScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create a spriteKit screen and overlay it to show the beardArrow and the distance
        let skView = self.view as! SKView
        
        findCowScene = FindCowsScene(size: skView.bounds.size)
        
        findCowScene.scaleMode = .aspectFill
        
        findCowScene.backgroundColor = SKColor.white
        
        skView.presentScene(findCowScene)
        compass = findCowScene.children[0] as! SKSpriteNode
        
        dontKnowLocationYet = true
        // Ask if it's okay to Always track user location and compass rotation, not just while the app is active.
        self.locationManager.requestAlwaysAuthorization()
        
        // Ask if it's okay to use the user's location and compass rotation only in the foreground.
        self.locationManager.requestWhenInUseAuthorization()
        
        //If we can use the user's locaiton and compass rotation, set up and start watching those values.
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    //Create a cow between 30 and 60 meters away in both X and Y directions. the range can be negative or positive... For exapme... The cow, in the X direction could be (-60 to -30) or (30 to 60) but never inbetween. Doing this ensures that the user will never be within 5 meters of the cow to start out.
    func plopCow(){
        let cowLatChangeInMeters = Double(arc4random_uniform(30) + 30) * getNegOneOrOne()
        cowLat = getCowLatitude(cowLatChangeInMeters: cowLatChangeInMeters)
        let cowLonChangeInMeters = Double(arc4random_uniform(30) + 30) * getNegOneOrOne()
        cowLon = getCowLongitude(cowLonChangeInMeters: cowLonChangeInMeters, cowLat: cowLat)
    }
    
    //Returns the current plopped cow's latitude
    func getCowLatitude(cowLatChangeInMeters: Double) -> Double {
        let cowLatChangeInDegrees = oneMeterInLatitudeDegrees * cowLatChangeInMeters
        return latitude + cowLatChangeInDegrees
    }
    
    //Returns the current plopped cow's longitude based on it's latitude. (Because the length of a longitude degrees varies based on latitude)
    func getCowLongitude(cowLonChangeInMeters: Double, cowLat: Double) -> Double {
        let cowLonChangeInDegrees = getOneMeterInLongitudeDegrees(latitudeDegrees: cowLat) * cowLonChangeInMeters
        return longitude + cowLonChangeInDegrees
    }

}
 //This function is just a nifty little random generator that returns either positive or negative 1. Useful in the cow plop method.
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
        longitude = locValue.longitude
        lonChanged = true
        latitude = locValue.latitude
        latChanged = true
    }
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    //Whenever the users updates their compass data (i.e. whenever the device is rotated, this method is called. Update the beardArrow accordingly)
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        facingAngleRadians = toRadians(newHeading.trueHeading)
        //The direction to face can be found by rotating the compass by the arcTangent of the x and y vector facing towards the cow, and then adding the offset that the user is facing towards based on it's compass rotation towards north.
        compass.zRotation = CGFloat(atan2(distanceYtoCow, distanceXtoCow) + facingAngleRadians)
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
    
    //Converts degrees to radians
    func toRadians(_ degrees: Double) -> Double {
        return (degrees * .pi) / 180
    }
    
    //Converts radians to degrees
    func toDegrees(_ radians: Double) -> Double {
        return radians * (180 / .pi)
    }
    
}
