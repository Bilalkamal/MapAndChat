//
//  MapViewController.swift
//  MapAndChat
//
//  Created by Bilal on 2018-04-08.
//  Copyright © 2018 Bilal. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker


class MapViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {

    
    // MARK:- Setting Up IBOutlets and Variables
    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placePhoneLabel: UILabel!
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var currentLocation : GMSPlace?
    var currentLocationImage : UIImage?
    var finalPhoneNumber : String? = ""
    
    
    private let locationManager = CLLocationManager()
    
   
    
    // MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        setupGoogleSearch()

        infoView.layer.cornerRadius = 5

        addressView.isHidden = true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPressFunction))
        placePhoneLabel.isUserInteractionEnabled = true
        placePhoneLabel.addGestureRecognizer(longPress)
        
    }
    
    
  
    
    
    
    
    // MARK:- Setting Up the Buttons and View
    
    func setupGoogleSearch(){
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        
        searchController?.searchBar.sizeToFit()
        navigationItem.titleView = searchController?.searchBar
        
        
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
    }

    
    
   
    
   
    
   
    // MARK:- Action Buttons
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        placeImageView.image = #imageLiteral(resourceName: "No image Available")
        
        if currentLocationImage != nil {
            placeImageView.image = currentLocationImage
        }
        else {
            placeImageView.image = #imageLiteral(resourceName: "No image Available")
        }
        
        
        placeNameLabel.text = currentLocation?.name
        placeAddressLabel.text = currentLocation?.formattedAddress

        if currentLocation?.phoneNumber != nil {
            if currentLocation!.phoneNumber!.count > 8 {
                placePhoneLabel.text = currentLocation?.phoneNumber
            }else {
                placePhoneLabel.text = "No Phone Available"
            }
            
        }else {
            placePhoneLabel.text = "No Phone Available"
        }
        
        
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center

    }
    
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.infoView.removeFromSuperview()
        
        
        
    }
    


    
  
    
    // MARK:- General Functions
    

    
    @objc func longPressFunction(sender:UITapGestureRecognizer) {
        
        if placePhoneLabel.text != "No Phone Available" {
            var trimmedPhoneNumber = placePhoneLabel.text
            
            trimmedPhoneNumber = trimmedPhoneNumber!.components(separatedBy: .whitespaces).joined()
            

            if let phoneNumber = trimmedPhoneNumber   {
                
                    
                    guard let number = URL(string: "tel://" + phoneNumber) else {return}
                    
                    let alert = UIAlertController(title: "Calling", message: "Are you Sure you want to Call \(trimmedPhoneNumber!)", preferredStyle: UIAlertControllerStyle.alert)
                    
                    
                    
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
                        
                        action in UIApplication.shared.open(number)
                    }))
                    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {
                        
                        action in print("No")
                        
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
            
            
        }
        
    }

   
    
    
    
    
    // MARK:- Loading Images Functions
    
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
                self.currentLocationImage = nil
                
            } else {
                self.currentLocationImage = photo;
                
            }
        })
    }
    
    
    
    
    // MARK:- Update View with New Place
    
    func updateViewToNewLocation(with place: GMSPlace){
        
        loadFirstPhotoForPlace(placeID: (place.placeID))
        
        mapView.clear()
        searchController?.isActive = false
       
        currentLocation = place
        
        
        CATransaction.begin()
        CATransaction.setValue(1, forKey: kCATransactionAnimationDuration)
 
        mapView.animate(to: GMSCameraPosition(target: place.coordinate, zoom: 16, bearing: 0, viewingAngle: 0))
        CATransaction.commit()
        
        
        let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        let marker = GMSMarker(position: position)
        marker.title = "\(place.name)"
        marker.map = mapView
        
        
        
        locationLabel.text = "\(currentLocation!.name) "
        locationLabel.backgroundColor = UIColor.white
        addressView.isHidden = false
        let locationLabelHeight = locationLabel.intrinsicContentSize.height + 35
        mapView.padding = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0,
                                       bottom: locationLabelHeight, right: 0)
        
    }

    
}


// MARK: - GMSAutocompleteResultsViewControllerDelegate

    extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {

            infoView.removeFromSuperview()
            updateViewToNewLocation(with: place)

            
          
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: Error){
            // TODO: handle the error.
            print("Error: ", error.localizedDescription)
            infoView.removeFromSuperview()
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            infoView.removeFromSuperview()
        }
        
        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            infoView.removeFromSuperview()
        }
        
      

    }


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        mapView.clear()

        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 18, bearing: 0, viewingAngle: 0)
        
     
        locationManager.stopUpdatingLocation()
    }
    
    
    
}
