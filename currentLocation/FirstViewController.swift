//
//  FirstViewController.swift
//  currentLocation
//
//  Created by Kateshiya Sunil on 9/25/17.
//  Copyright © 2017 Kateshiya Sunil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Location {
    case startLocation
    case destinationLocation
}

class FirstViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, GMSMapViewDelegate  {
    
    
    @IBOutlet weak var startLocation: UITextField!
    @IBOutlet weak var destinationLocation: UITextField!
    var LocationManager = CLLocationManager()
    var locationSelected = Location.startLocation
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocation.delegate = self
        destinationLocation.delegate = self
        startLocation.attributedPlaceholder = NSAttributedString(string: "Enter Your Start Location :", attributes: [NSForegroundColorAttributeName: UIColor.yellow])
        destinationLocation.attributedPlaceholder = NSAttributedString(string: "Enter Your Destination Location :", attributes: [NSForegroundColorAttributeName: UIColor.yellow])
        
    }
    
    
    @IBAction func openStartLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        
        locationSelected = .startLocation
        
        
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.LocationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    @IBAction func openDestinationLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        
        locationSelected = .destinationLocation
        
        UISearchBar.appearance().setTextColor(color: UIColor.black)
        self.LocationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func showDirection(_ sender: UIButton) {
        performSegue(withIdentifier: "Go", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let second = segue.destination as! HomeViewController
        
        
        second.startLatitude = locationStart.coordinate.latitude
        second.startLogitude = locationStart.coordinate.longitude
        second.endLatitude = locationEnd.coordinate.latitude
        second.endLongitude = locationEnd.coordinate.longitude
        second.drawPath(startLocation: locationStart, endLocation: locationEnd)
        
        
    }
}

extension FirstViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        if locationSelected == .startLocation {
            startLocation.text = "\(place.name)"
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        } else
        {
            destinationLocation.text = "\(place.name)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        }
        
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

public extension UISearchBar {
    
    public func setTextColor(color: UIColor) {
        let svs = subviews.flatMap { $0.subviews }
        guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return }
        tf.textColor = color
        
    }
    
}

