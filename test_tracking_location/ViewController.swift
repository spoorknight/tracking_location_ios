//
//  ViewController.swift
//  test_tracking_location
//
//  Created by Phạm Văn Hỷ on 30/05/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let status = CLLocationManager.authorizationStatus()
    let locationManager = CLLocationManager()

    @IBOutlet weak var btn: UIButton!

 
    
   
    @IBAction func action(_ sender: Any) {
        print("click")
//        switch status {
//        case .authorizedAlways:
//            print("authorizedAlways")
//            break
//            case .authorizedWhenInUse:
//            print("authorizedWhenInUse")
//            break
//            case .denied:
//            print("denied")
//            break
//            case .notDetermined:
//            print("notDetermined")
//            break
//            case .restricted:
//            print("restricted")
//            break
//        @unknown default:
//            fatalError()
//        }
//
//        print("long:", locationManager.location!.coordinate.longitude,"--", "lat:", locationManager.location!.coordinate.latitude)
//        scheduledTimerWithTimeInterval()
      
        
    }
    

  
    
    
    
    
    override func viewDidLoad()  {
        super.viewDidLoad()
    
        print("viewDidLoad")
    }
    
    
 
//
//    override func viewWillAppear(_ animated: Bool) {
//         print("viewWillAppear")
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        print("viewDidAppear")
//    }
//
//   
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        print("viewDidDisappear")
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        print("viewWillDisappear")
//    }
//    
//   
    
}

