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


class MapViewController: UIViewController {

    
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeAddress: UILabel!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placePhone: UILabel!
    
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var currentLocation : GMSPlace? = nil
    var effect:UIVisualEffect!
    var currentLocationImage : UIImage?
    var finalPhoneNumber = ""
    
    
    private let locationManager = CLLocationManager()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        setupGoogleSearch()
        

        
        infoView.layer.cornerRadius = 5

        addressView.isHidden = true
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longPressFunction))
        placePhone.isUserInteractionEnabled = true
        placePhone.addGestureRecognizer(longPress)
        
    }
    func callNumber(){
        
        if let number = URL(string: "tel://" + finalPhoneNumber){
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
        
        
    }
    
    @objc func longPressFunction(sender:UITapGestureRecognizer) {
        
        if placePhone.text != nil {
            var trimmedPhoneNumber = placePhone.text
            
            trimmedPhoneNumber = trimmedPhoneNumber!.components(separatedBy: .whitespaces).joined()
          
            if let phoneNumber = trimmedPhoneNumber {
                
                finalPhoneNumber = phoneNumber
                callNumber()
                
            }else { return }
          
              
            
            
        }
        
        
       
    }
    
   
    
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        
        placeImage.image = currentLocationImage
        placeName.text = currentLocation?.name
        placeAddress.text = currentLocation?.formattedAddress
        
        if let placePhoneNumber = currentLocation?.phoneNumber {
            placePhone.text = placePhoneNumber
            
        }else {
            placePhone.text = "No Phone Available"
        }
        
        
         self.view.addSubview(infoView)
        infoView.center = self.view.center
        
        
        
        
    }
    @IBAction func dismissPressed(_ sender: UIButton) {
        self.infoView.removeFromSuperview()
        
    }
    
    

    
    
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
    

    
}





// MARK: - GMSAutocompleteResultsViewControllerDelegate

    extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didAutocompleteWith place: GMSPlace) {
            self.infoView.removeFromSuperview()
            
            searchController?.isActive = false
            
            currentLocation = place
            loadFirstPhotoForPlace(placeID: (currentLocation?.placeID)!)
            
            mapView.clear()

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
            let locationLabelHeight = locationLabel.intrinsicContentSize.height + 45
            mapView.padding = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0,
                                                bottom: locationLabelHeight, right: 0)
            
            
            
          
        }
        
        func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                               didFailAutocompleteWithError error: Error){
            // TODO: handle the error.
            print("Error: ", error.localizedDescription)
        }
        
        // Turn the network activity indicator on and off again.
        func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
