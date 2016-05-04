//
//  ViewController.swift
//  trial3-MapKitAPI
//
//  Created by DavisLeong on 2016/4/18.
//  Copyright © 2016年 DavisLeong. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var addLocationLatitude : String = " "
    var addLocationLongitude : String = " "
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var getLocation: UIButton!
    
    @IBOutlet var getPressLocation: UILongPressGestureRecognizer!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location=locations.last
        let CurrentlocationValue=CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: CurrentlocationValue, span: MKCoordinateSpanMake(1, 1) )
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
    }

    @IBAction func getPressLocation(sender: AnyObject) {
        if (sender.state == .Began){
            let pressPoint = getPressLocation.locationInView(self.mapView)
            let pressLocation:CLLocationCoordinate2D = mapView.convertPoint(pressPoint, toCoordinateFromView: self.mapView)
            let newAnnotation = MKPointAnnotation()
            newAnnotation.coordinate = pressLocation
            newAnnotation.title = "New Location"
            newAnnotation.subtitle = (String)(pressLocation.latitude,pressLocation.longitude)
            self.addLocationLatitude = (String)(pressLocation.latitude)
            self.addLocationLongitude = (String)(pressLocation.longitude)
            
            let alertView = UIAlertController(title: "Do you want to add this location", message: newAnnotation.subtitle, preferredStyle: .Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
                action in self.mapView.addAnnotation(newAnnotation)
                self.performSegueWithIdentifier("InputChange", sender: self)
                
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        }
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController : InPutViewController = segue.destinationViewController as! InPutViewController
        DestViewController.newLatitude = (String)(self.addLocationLatitude)
        DestViewController.newLongitude = (String)(self.addLocationLongitude)
     
     }
    @IBAction func getCurrentLocation(sender: AnyObject) {
        
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(0.0075,0.0075) )
        self.mapView.setRegion(region, animated: true)
        //mapView.setCenterCoordinate(mapView.userLocation.coordinate, animated: true)
        
    }

}