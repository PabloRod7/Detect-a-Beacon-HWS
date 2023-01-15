//
//  ViewController.swift
//  Project22
//
//  Created by Pablo Rodrigues on 13/01/2023.
//
import CoreLocation
import UIKit

class ViewController: UIViewController, CLLocationManagerDelegate {
//    challenge 2
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var beaconLabel: UILabel!
   
    @IBOutlet weak var imageView: UIImageView!
   
    var locationManager : CLLocationManager?
    
    //    chellenge 1
    var beaconFound : Bool = true
    
    var beaconNameuuid : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        beaconLabel.text = "..."
        
        
        imageView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        
        
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable(){
                    startScaning()
                }
            }
        }
    }
    
    
    
    func startScaning(){
       
        addBeaconRegion(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5", major: 123, minor: 456, beaconName: "Apple AirLocate")
        
        addBeaconRegion(uuidString: "2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6", major: 123, minor: 456, beaconName: "Radius Networks")
        
        addBeaconRegion(uuidString: "92AB49BE-4127-42F4-B532-90fAF1E26491", major: 123, minor: 456, beaconName: "TwoCanoes")
        
        
    }
    
    func addBeaconRegion(uuidString: String, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, beaconName: String){
        
        let uuid = UUID(uuidString: uuidString)!
       
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: major, minor: minor, identifier: beaconName)
       
        let beaconRegionConstraints = CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor)
        
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: beaconRegionConstraints)
        
    }
    
    
    
    
    func update(distance: CLProximity, name: String){
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            self?.beaconLabel.text = "\(name)"
           
            switch distance {
            case .far :
                self?.view.backgroundColor = UIColor.blue
                self?.distanceReading.text = "FAR"
                self?.imageView.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                
            case .near :
                self?.view.backgroundColor = UIColor.orange
                self?.distanceReading.text = "NEAR"
                self?.imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                
                
            case .immediate:
                self?.view.backgroundColor = UIColor.red
                self?.distanceReading.text = "Founded"
                self?.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                
                
                
                
                
                
            default :
                self?.view.backgroundColor = UIColor.gray
                self?.distanceReading.text = "Searching"
                print("not found")
                
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if beaconNameuuid == nil { beaconNameuuid = region.uuid}
            guard beaconNameuuid == region.uuid else { return }
           
            update(distance: beacon.proximity, name: region.identifier)
           
            //            challenge 1
            beaconDetected()
            
        } else {
            guard beaconNameuuid == region.uuid else { return }
            beaconNameuuid = nil
            
            update(distance:.unknown, name: "Unknwon")
        }
    }
    //    challenge 1
    func beaconDetected() {
       
        if beaconFound {
            beaconFound = false
            
            let ac = UIAlertController(title: "We Found", message: "Beacon Detected!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac,animated: true)
            
            
        }
    }
    
    
    
}
