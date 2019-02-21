//
//  ViewController.swift
//  BubbleTeaLocation
//
//  Created by Spextrum on 14/2/2562 BE.
//  Copyright © 2562 Spextrum. All rights reserved.
//
import Alamofire
import GoogleMaps
import UIKit

class ViewController: UIViewController {
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }

    @IBAction func findAction(_ sender: Any) {
        Alamofire.request("https://api.foursquare.com/v2/venues/search?client_id=LGINLYGSHG21ES0LSHOXTCLQHQSKORXJLBNL0CQ2UJIOQ0EX&client_secret=LAFOJRQNOWIJHLA3UPVDXKVD3UXXVZWAQ0KKX0KOZV3HI5HE&v=20180323&limit=10&ll=\(locationManager.location?.coordinate.latitude ?? 0.0),\(locationManager.location?.coordinate.longitude ?? 0.0)&query=bubbletea").responseJSON(completionHandler: { res in
            guard let json = res.result.value as? [String: Any] else {
                return
            }
            guard let response = json["response"] as? [String: Any] else {
                return
            }
            guard let venues = response["venues"] as? [[String: Any]] else {
                return
            }
            
            venues.forEach { venue in
                let place = Place(venue: venue)
                let marker = GMSMarker(position: place.location)
                print(place.location)
                marker.map = self.mapView
                marker.title = place.name
                
            }
        })
        
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        print(location.coordinate.latitude)
        print(location.coordinate.longitude)
        mapView.camera = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 10)
    }
}

