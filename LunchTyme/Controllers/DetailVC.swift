//
//  ViewController.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit
import MapKit

let nameFont: UIFont = UIFont.init(name: "AvenirNext-DemiBold", size: 16)!
let categoryFont: UIFont = UIFont.init(name: "AvenirNext-Regular", size: 12)!
let regularFont: UIFont = UIFont.init(name: "AvenirNext-Regular", size: 16)!
let regularColor: UIColor = UIColor(red: 42, green: 42, blue: 42)

class DetailVC: UIViewController, CLLocationManagerDelegate {
    
    var restaurants = Array<Restaurant>()
    
    var location: CLLocationCoordinate2D? {
        willSet(newValue) {
            if let newCenter = newValue, let restaurant = restaurants.first {
                let center = CLLocationCoordinate2D(latitude: (newCenter.latitude + restaurant.location.lat)/2, longitude: (newCenter.longitude + restaurant.location.lng)/2)
                let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                let myRegion = MKCoordinateRegion(center: center, span: span)
                mapView.setRegion(myRegion, animated: true)
            }

        }
    }
    
//    var name = ""
//    var category = ""
//    var lat: Double = 0.0 {
//        willSet {
//            print(newValue)
//        }
//    }
//    var lng: Double = 0.0 {
//        willSet {
//            print(newValue)
//        }
//    }
//    var address = ""
    
    
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    let titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 52, green: 179, blue: 121)
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = nameFont
        return view
    }()
    
    let categoryLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = categoryFont
        return view
    }()
    
    let detailContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let address1Label: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let address2Label: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let phoneLabel: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let twitterLabel: UILabel = {
        let view = UILabel()
        view.textColor = regularColor
        view.font = regularFont
        return view
    }()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    

    // MARK: setup views

    
    func setupViews() {
        
        self.title = "Lunch Tyme"
        let mapButton = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .plain, target: self, action: #selector(pressMapButton))
        self.navigationItem.setRightBarButton(mapButton, animated: true)
        // Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // loading info to the map
        var annotations = Array<MKAnnotation>()
        for restaurant in restaurants {
            let lat = restaurant.location.lat
            let lng = restaurant.location.lng
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            let annotation = MKPointAnnotation()
            annotation.subtitle = restaurant.name
            annotation.coordinate = coordinate
            annotations.append(annotation)
            print(restaurant.name)
        }
        mapView.addAnnotations(annotations)
//        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: 50000, longitudinalMeters: 50000)
//        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.showAnnotations(annotations, animated: true)
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
//        mapConstrainForFull()
    }
    //Mark: map button method
    @objc func pressMapButton() {
        if restaurants.count <= 1 {
            let mapVC = DetailVC()
            mapVC.restaurants = restaurants
            mapVC.mapConstrainForFull()
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
    //MARK: if data pass from mapButton then constraint for full map

    func mapConstrainForFull() {
        let myConstraints = [
            NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)]
        view.addConstraints(myConstraints)
    }
    
    //MARK: if data pass from listVC cell than adjust layout for loading individual restaurant info
    func updateLayout() {
        view.addSubview(titleContainerView)
        titleContainerView.addSubview(nameLabel)
        titleContainerView.addSubview(categoryLabel)
        view.addSubview(detailContainerView)
        detailContainerView.addSubview(address1Label)
        detailContainerView.addSubview(address2Label)
        detailContainerView.addSubview(phoneLabel)
        detailContainerView.addSubview(twitterLabel)
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        detailContainerView.translatesAutoresizingMaskIntoConstraints = false
        address1Label.translatesAutoresizingMaskIntoConstraints = false
        address2Label.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        twitterLabel.translatesAutoresizingMaskIntoConstraints = false

        
        let myConstraints = [
            //set mapView constraints
            NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: mapView, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1.0, constant: 180 + 64),
            
            //set container constraints
            NSLayoutConstraint(item: titleContainerView, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: titleContainerView, attribute: .bottom, relatedBy: .equal, toItem: titleContainerView, attribute: .top, multiplier: 1.0, constant: 60),

            //set nameLabel
            NSLayoutConstraint(item: nameLabel, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: titleContainerView, attribute: .top, multiplier: 1.0, constant: 6),
            NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: titleContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: categoryLabel, attribute: .top, multiplier: 1.0, constant: -6),

            //set categoryLabel
            NSLayoutConstraint(item: categoryLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1.0, constant: 0),


            //set detailContainerView
            NSLayoutConstraint(item: detailContainerView, attribute: .top, relatedBy: .equal, toItem: titleContainerView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: detailContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0),

            //set address
            NSLayoutConstraint(item: address1Label, attribute: .top, relatedBy: .equal, toItem: detailContainerView, attribute: .top, multiplier: 1.0, constant: 16),
            NSLayoutConstraint(item: address1Label, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: address1Label, attribute: .trailing, relatedBy: .equal, toItem: detailContainerView, attribute: .trailing, multiplier: 1.0, constant: -12),
            
            NSLayoutConstraint(item: address2Label, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: address1Label, attribute: .bottom, multiplier: 1.0, constant: 2),
            NSLayoutConstraint(item: address2Label, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: address2Label, attribute: .trailing, relatedBy: .equal, toItem: address1Label, attribute: .trailing, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: address2Label, attribute: .bottom, relatedBy: .equal, toItem: phoneLabel, attribute: .top, multiplier: 1.0, constant: -26),

            //set phoneLabel twitterlabel
            NSLayoutConstraint(item: phoneLabel, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: twitterLabel, attribute: .leading, relatedBy: .equal, toItem: detailContainerView, attribute: .leading, multiplier: 1.0, constant: 12),
            NSLayoutConstraint(item: twitterLabel, attribute: .trailing, relatedBy: .equal, toItem: detailContainerView, attribute: .trailing, multiplier: 1.0, constant: -12),

            NSLayoutConstraint(item: twitterLabel, attribute: .top, relatedBy: .equal, toItem: phoneLabel, attribute: .bottom, multiplier: 1.0, constant: 26)



        ]
        view.addConstraints(myConstraints)
        view.updateConstraints()
        
    }

    //didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let cllocation = locations[locations.count - 1]
        if cllocation.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            location = CLLocationCoordinate2D(latitude: cllocation.coordinate.latitude, longitude: cllocation.coordinate.longitude)
//            lat = location.coordinate.latitude
//            lng = location.coordinate.longitude
        }
    }
    
    //MARK: remove the back button text
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    deinit {
        print ("There is no memory leak from mapView controller")
    }

}


