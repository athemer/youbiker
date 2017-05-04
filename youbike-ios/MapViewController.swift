//
//  mapViewController.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/25.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var stationName: String = "WRONG!!!!"
    var latitudeString: String = "latitude"
    var longitudeString: String = "longitude"
    let locationManager: CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stationName
        mapView.delegate = self
        self.locationManager.delegate = self
        self.mapView.mapType = MKMapType.standard
        let latDelta = 0.01
        let longDelta = 0.01
        let currentLocationSpan: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let latitude = Double(latitudeString)!
        let longitude = Double(longitudeString)!
        let center: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate, span: currentLocationSpan)
        self.mapView.setRegion(currentRegion, animated: true)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: latitude, longitude: longitude).coordinate
        self.mapView.addAnnotation(objectAnnotation)
        mapView.view(for: objectAnnotation)
    }
}
