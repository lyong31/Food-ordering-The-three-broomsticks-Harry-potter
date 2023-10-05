//
//  ShopLocationVC.swift
//  FirebaseDemo
//
//  Created by student on 20/02/2022.
//

import MapKit
import UIKit

class ShopLocationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Pre-define the restaurant actual location based on latitude and longitude
        let restaurantLocation = CLLocation(latitude: 3.149661247, longitude: 101.712730256)
        //Set the map center to the restaurant's location
        mapView.centerToLocation(restaurantLocation)
        mapView.delegate = self
        //Add description to the pin
        let mapDesc = MapDesc(title: "Harry Potter's", locationName: "Hogsmeade Village", discipline: "Restaurant", coordinate: CLLocationCoordinate2D(latitude: 3.149661247, longitude: 101.712730256))
        mapView.addAnnotation(mapDesc)
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var mapView: MKMapView!
    
}

private extension MKMapView {
    //Add extra custom function to map view to set location to center according to the restaurant's coordinate
    //Function takes in the location of restaurant
    func centerToLocation(_ location : CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension ShopLocationVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapDesc else {
            return nil
        }
        let identifier = "MapDesc"
        var view:MKMarkerAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeueView.annotation = annotation
            view = dequeueView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}
