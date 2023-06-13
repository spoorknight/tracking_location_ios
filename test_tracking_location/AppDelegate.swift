//
//  AppDelegate.swift
//  test_tracking_location
//
//  Created by Phạm Văn Hỷ on 30/05/2023.
//

import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var locationManager: CLLocationManager? = CLLocationManager()
    var myLocation: CLLocation?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if launchOptions?[UIApplication.LaunchOptionsKey.location] != nil {
            if locationManager == nil {
                locationManager = CLLocationManager()
            } else {
                locationManager = nil
                locationManager = CLLocationManager()
            }
            locationManager?.delegate = self
            locationManager?.distanceFilter = 50
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.startMonitoringSignificantLocationChanges()
        } else {
            locationManager?.delegate = self
            locationManager?.distanceFilter = 50
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.allowsBackgroundLocationUpdates = true
            if CLLocationManager.authorizationStatus() == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
            }
            else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                locationManager?.requestAlwaysAuthorization()
            }
            else if CLLocationManager.authorizationStatus() == .authorizedAlways {
                locationManager?.startMonitoringSignificantLocationChanges()
            }
        }
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        self.createRegion(location: myLocation)
        NSLog("app tracking_test long applicationDidEnterBackground")
    }
}

import CoreLocation
extension AppDelegate: CLLocationManagerDelegate {
    
  
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            NSLog("app tracking_test long didChangeAuthorization: \(locationManager?.location?.coordinate.longitude ?? 0.0) -- lat: \( locationManager?.location?.coordinate.latitude ?? 0.0)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if (location?.horizontalAccuracy)! <= Double(65.0) {
            myLocation = location
            if !(UIApplication.shared.applicationState == .active) {
                self.createRegion(location: location)
            }
        } else {
            manager.stopMonitoringSignificantLocationChanges()
            manager.startMonitoringSignificantLocationChanges()
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager?.requestAlwaysAuthorization()
        }
         let dateOld = UserDefaults.standard.string(forKey: "dateOld")
            let lat = UserDefaults.standard.double(forKey: "lat")
            let long = UserDefaults.standard.double(forKey: "long")
            if(dateOld != nil){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
                let oldDate = dateFormatter.date(from: dateOld!)!
                if minutesBetweenDates(oldDate, Date()) >= 3 { // >= 3 minutes
                    if(lat != 0.0 || long != 0.0){
                        let coordinate₀ = CLLocation(latitude: lat, longitude: long)
                        let coordinate₁ = CLLocation(latitude: self.locationManager?.location?.coordinate.latitude ?? 0.0, longitude: self.locationManager?.location?.coordinate.longitude ?? 0.0)
                        let distanceInMeters = coordinate₀.distance(from: coordinate₁)
                        if(distanceInMeters >= 100){ // >=100m
                            //Do something
                            
                            NSLog("app tracking didUpdateLocations: \(self.locationManager?.location?.coordinate.longitude ?? 0.0) -- lat: \( self.locationManager?.location?.coordinate.latitude ?? 0.0)")
                        
                            UserDefaults.standard.set(self.locationManager?.location?.coordinate.latitude ?? 0.0, forKey: "lat")
                            UserDefaults.standard.set(self.locationManager?.location?.coordinate.longitude ?? 0.0, forKey: "long")
                        }
                    }
                    }
            }else{
                UserDefaults.standard.set(self.locationManager?.location?.coordinate.latitude ?? 0.0, forKey: "lat")
                        UserDefaults.standard.set(self.locationManager?.location?.coordinate.longitude ?? 0.0, forKey: "long")
                        UserDefaults.standard.set("\(Date())", forKey: "dateOld")
            }
    }
    
    func minutesBetweenDates(_ oldDate: Date, _ newDate: Date) -> CGFloat {

        //get both times sinces refrenced date and divide by 60 to get minutes
        let newDateMinutes = newDate.timeIntervalSinceReferenceDate/60
        let oldDateMinutes = oldDate.timeIntervalSinceReferenceDate/60

        //then return the difference
        return CGFloat(newDateMinutes - oldDateMinutes)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        NSLog("didEnterRegion")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopMonitoring(for: region)
        NSLog("didExitRegion")
        manager.startMonitoringSignificantLocationChanges()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        locationManager?.requestAlwaysAuthorization()
    }

    func createRegion(location:CLLocation?) {
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            let coordinate = CLLocationCoordinate2DMake((location?.coordinate.latitude)!, (location?.coordinate.longitude)!)
            let regionRadius = 100.0
            let coords = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let region = CLCircularRegion(center: coords, radius: regionRadius, identifier: "aabb")
            region.notifyOnEntry = true
            region.notifyOnExit  = true
            self.locationManager?.stopMonitoringSignificantLocationChanges()
            self.locationManager?.startMonitoring(for: region)
        }
    }
    

    
}
