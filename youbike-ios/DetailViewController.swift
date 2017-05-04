//
//  detailViewController.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/26.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class DetailViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var road: UILabel!
    @IBOutlet weak var numberOfBikesRemaining: UILabel!
    var stationName: String = "WRONG!!!!"
    var latitudeString: String = "latitude"
    var longitudeString: String = "longitude"
    var roadName: String = " "
    var numberleft: String = " "
    let locationManager: CLLocationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stationName
        self.name.text = stationName
        self.road.text = roadName
        self.numberOfBikesRemaining.text = numberleft

        detailMapView.delegate = self
        self.locationManager.delegate = self
        self.detailMapView.mapType = MKMapType.standard
//        let latDelta = 0.01
//        let longDelta = 0.01
//        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        let latitude = Double(latitudeString)!
        let longitude = Double(longitudeString)!
        let center: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
//        let currentRegion: MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,span: currentLocationSpan)
//        self.detailMapView.setRegion(currentRegion, animated: true)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = CLLocation(latitude: latitude, longitude: longitude).coordinate
        self.detailMapView.addAnnotation(objectAnnotation)
        detailMapView.view(for: objectAnnotation)
        showRoute()
        self.detailMapView.showsUserLocation = true

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations.last!
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        detailMapView.setRegion(region, animated: true)
    }
    func determineCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }

    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            self.detailMapView.mapType = MKMapType.standard
        case 1:
            self.detailMapView.mapType = MKMapType.satellite
        case 2:
            self.detailMapView.mapType = MKMapType.hybrid
        default:
            break
        }
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // swiftlint:disable:next force_cast
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        // swiftlint:disable:previous force_cast
        renderer.strokeColor = UIColor(red: 201/255, green: 28/255, blue: 187/255, alpha: 1)
        renderer.lineWidth = 4.0
        return renderer
    }
    func showRoute() {
        let latitude = Double(latitudeString)!
        let longitude = Double(longitudeString)!
        let currentLocation = locationManager.location
        let currentLatitude = currentLocation?.coordinate.latitude
        let currentLongitude = currentLocation?.coordinate.longitude
        let sourceLocation = CLLocationCoordinate2D(latitude: currentLatitude!, longitude: currentLongitude!)
        let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "User Location"
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Destination"
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        self.detailMapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) -> Void in
            guard let response = response else {
                if let error = error {
                    print("Error is here: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.detailMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)

        }
    }
}
