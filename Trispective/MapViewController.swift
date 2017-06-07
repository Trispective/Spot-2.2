//
//  MapViewController.swift
//  Trispective
//
//  Created by USER on 2017/5/15.
//  Copyright © 2017年 Trispective. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var restaurant=Restaurant()
    var latitude:CLLocationDegrees=0
    var longitude:CLLocationDegrees=0
    
    @IBAction func openMap(_ sender: UIButton) {
        latitude=restaurant.getLatitude()
        longitude=restaurant.getLongitude()
        let span=MKCoordinateSpanMake(0.01, 0.01)
        let myLocation=CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMake(myLocation, span)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: myLocation, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name=restaurant.getName()
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        latitude=restaurant.getLatitude()
        longitude=restaurant.getLongitude()
        let span=MKCoordinateSpanMake(0.01, 0.01)
        let myLocation=CLLocationCoordinate2DMake(latitude, longitude)
        let region=MKCoordinateRegionMake(myLocation, span)
        let annotation=MKPointAnnotation()
        annotation.coordinate=myLocation
        annotation.title=restaurant.getName()
        annotation.subtitle=restaurant.getLocation()
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation=true
        mapView.addAnnotation(annotation)
    }


}
