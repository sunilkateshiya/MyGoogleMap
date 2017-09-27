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
    var locationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var locationStart =  CLLocation()
    var locationEnd = CLLocation()
    var startLatitude = 0.0
    var startLogitude = 0.0
    var endLatitude = 0.0
    var endLongitude = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
                      
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        var camrema : GMSCameraPosition = GMSCameraPosition()
        camrema = GMSCameraPosition.camera(withLatitude: 23.0225, longitude: 72.5714, zoom: 5.0)
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
            }
        }
        
    }



    
   

    
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let Mylocation = CLLocation(latitude: 37.784023631590777, longitude: -122.40486681461333)
        
        createMarker(titleMarker: "Sunil Kateshiya", iconMarker: #imageLiteral(resourceName: "pin") , latitude: Mylocation.coordinate.latitude, longitude: Mylocation.coordinate.longitude)
        
        createMarker(titleMarker: "Sunil Kateshiya", iconMarker: #imageLiteral(resourceName: "pin") , latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
          drawPath(startLocation: location!, endLocation: Mylocation)
        
        self.locationManager.stopUpdatingLocation()
        
    }


    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        googleMaps.isMyLocationEnabled = true
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        googleMaps.isMyLocationEnabled = true
        
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        googleMaps.isMyLocationEnabled = true
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        googleMaps.isMyLocationEnabled = true
        googleMaps.selectedMarker = nil
        return false
    }
  
 }


extension HomeViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16.0
        )
        
        
        if locationSelected == .startLocation {
         
            locationStart = CLLocation(latitude: startLatitude, longitude: startLogitude)
            createMarker(titleMarker: "Location Start", iconMarker: #imageLiteral(resourceName: "pin"), latitude: startLatitude, longitude: startLogitude)
        } else {
        
            locationEnd = CLLocation(latitude: endLatitude, longitude: endLongitude)
            createMarker(titleMarker: "Location End", iconMarker: #imageLiteral(resourceName: "pin"), latitude: endLatitude, longitude: endLongitude)
        }
        
        
        self.googleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    


}




