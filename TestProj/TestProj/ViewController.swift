//
//  ViewController.swift
//  TestProj
//
//  Created by Rey on 2018/8/13.
//  Copyright © 2018 Rey. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        self.setupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //1. status is not determined
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
            
            //2. authorization were dened
        else if CLLocationManager.authorizationStatus() == .denied {
            // show alter
        }
            
            //3. we do have authorization
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    fileprivate func openSettingApp() {
        //        该方法会直接打开setting  app ， 跳转到的页面也是当前 setting app 所在的页面
        let settingURL = NSURL(string: UIApplication.openSettingsURLString)!
        if UIApplication.shared.canOpenURL(settingURL as URL) {
            UIApplication.shared.open(settingURL as URL, options: [:], completionHandler: nil)
        }
    }
    
    func setupData() {
        //1. Check if system can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.classForCoder()) {
            let title = "Lorrenzillo' s"
            let coordinate = CLLocationCoordinate2DMake(37.7030, -121.75)
            let regionRadius = 300.0
            //            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,longitude: coordinate.longitude), radius: regionRadius, identifier: title)
            
            let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: regionRadius
                , identifier:title)
            
            //3. setup annotation
            
            let restaurantAnnotion = MKPointAnnotation()
            restaurantAnnotion.coordinate = coordinate
            restaurantAnnotion.title = "\(title)"
            self.mapView.addAnnotation(restaurantAnnotion)
            
            //setup circle
            let circle = MKCircle(center: coordinate, radius: regionRadius)
            self.mapView.addOverlay(circle)
            
        }else {
            print("System can't track regions.")
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let circleRender = MKCircleRenderer(overlay: overlay)
            circleRender.strokeColor = UIColor.red
            circleRender.lineWidth = 1.0
            print("Hello world")
            return circleRender
        }
    }


    
    @IBAction func settingPages(_ sender: Any) {
        
        openSettingApp()
    }
    
}

