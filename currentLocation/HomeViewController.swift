//
//  HomeViewController.swift
//  currentLocation
//
//  Created by Kateshiya Sunil on 9/26/17.
//  Copyright © 2017 Kateshiya Sunil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire
import SwiftyJSON



class HomeViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    @IBOutlet var googleMaps: GMSMapView!
    var startLatitude = 0.0
    var startLogitude = 0.0
    var endLatitude = 0.0
    var endLongitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var camrema : GMSCameraPosition = GMSCameraPosition()
        camrema = GMSCameraPosition.camera(withLatitude:  23.0225, longitude: 72.5714, zoom: 5)
        self.googleMaps.camera = camrema
        self.googleMaps.delegate = self
        self.googleMaps.isMyLocationEnabled = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        
    }
    
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        let origin = "\(startLatitude),\(startLogitude)"
        let destination = "\(endLatitude),\(endLongitude)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking"
        
        Alamofire.request(url).responseJSON { response in
            
            print(response.request as Any)
            print(response.response as Any)
            print(response.data as Any)
            print(response.result as Any)
            
            let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.isTappable = true
                polyline.strokeWidth = 4
                polyline.strokeColor = UIColor.red
                polyline.map = self.googleMaps
                let position = CLLocationCoordinate2D(latitude: self.startLatitude, longitude: self.startLogitude)
                let position2 = CLLocationCoordinate2D(latitude: self.endLatitude, longitude: self.endLongitude)
                let marker2 = GMSMarker(position: position2)
                let marker = GMSMarker(position: position)
                marker2.title = "My Location"
                marker.title = "Hello World"
                marker.map = self.googleMaps
                marker2.map = self.googleMaps
            }
        }
        
    }
}

  
