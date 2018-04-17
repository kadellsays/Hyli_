//
//  DetailsViewController.swift
//  HyLi
//
//  Created by Kadell on 11/21/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit
import Foundation
import MapKit
import GoogleMaps
import SDWebImage

class DetailsViewController: UIViewController {
    
    var suggestion = Suggestions()
    
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var typeLocationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDetailPage()
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
       setupView()
    }
    
    func setUpDetailPage() {
        let fillerImage = UIImage(named: "hyliFiller")
        let urlString = suggestion.photo
        self.navigationItem.title = suggestion.venue_name
        
        typeLocationLabel.text = "\(suggestion.type), \(suggestion.locality)"
        descriptionLabel.text = suggestion.description
        timeLabel.text = handleParsingSchedule()
        
        locationLabel.text = "\(suggestion.street) \n \(suggestion.city), \(suggestion.state) \(suggestion.zip)"
        
        phoneLabel.text = "\(suggestion.phone)"
        image.sd_setImage(with: URL(string: urlString), placeholderImage: fillerImage, options: [.continueInBackground,.highPriority], completed: nil)

    }
    func handleParsingSchedule() -> String {
        guard let mondayHours  = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        guard let tuesdayHours = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        guard let wednesdayHours = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        guard let thursdayHours = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        guard let fridayHours = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        guard let saturdayHours = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        guard let sundayHours = suggestion.hours_operation["monday"] as? [String: String] else {return "We could not find the hours."}
        
        let monday = "Mon:  \(mondayHours["to"]!) - \(mondayHours["from"]!) \n"
        let tuesday = "Tue:   \(tuesdayHours["to"]!) - \(tuesdayHours["from"]!)\n"
        let wednesday = "Wed:  \(wednesdayHours["to"]!) - \(wednesdayHours["from"]!)\n"
        let thursday = "Thu:   \(thursdayHours["to"]!) - \(thursdayHours["from"]!)\n"
        let friday = "Fri:     \(fridayHours["to"]!) - \(fridayHours["from"]!)\n"
        let saturday = "Sat:    \(saturdayHours["to"]!) - \(saturdayHours["from"]!)\n"
        let sunday = "Sun:   \(sundayHours["to"]!) - \(sundayHours["from"]!)\n"
        
        let finalString = monday + tuesday + wednesday + thursday + friday + saturday + sunday
        

        
        return finalString
    }
    
    func setupView() {
    
    guard let latitude = Double(suggestion.latitude) else {return}
    guard let longitude = Double(suggestion.longitude) else {return}
    
    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 12.0)
    let mapView = GMSMapView.map(withFrame: self.mapView.bounds , camera: camera)
    self.mapView.addSubview(mapView)
    mapView.delegate = self
    
    let marker = GMSMarker()
    marker.icon = UIImage(named: "buttonMapSelectActivated")
    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    marker.map = mapView
    
    }
    

    //MARK: Functions
    func mapClicked() {
        guard let longitude = Double(suggestion.longitude), let latitude = Double(suggestion.latitude) else {return}
        let hyliLatLong = CLLocationCoordinate2DMake(latitude, longitude)
    
        
        let actionSheet = UIAlertController(title: "Open in Maps", message: nil, preferredStyle: .actionSheet)
        let appleMaps = UIAlertAction(title: "Apple Maps", style: .default) { (action) in
            self.openApple(location: hyliLatLong)
        }
        let googleMaps = UIAlertAction(title: "Google Maps", style: .default) { (action) in
            self.openGoogle(location: hyliLatLong)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("Check me!")
        }
            actionSheet.addAction(appleMaps)
            actionSheet.addAction(googleMaps)
            actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
 
    func openApple(location: CLLocationCoordinate2D) {
        
        let placeMark = MKPlacemark(coordinate: location)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = suggestion.venue_name
        mapItem.openInMaps(launchOptions: nil)
    }
    
    func openGoogle(location: CLLocationCoordinate2D ) {
        
        guard let url = URL(string: "comgooglemaps://?q=\(location.latitude),\(location.longitude)&center=\(location.latitude),\(location.longitude)") else {return}
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let iTunesLink = "itms-apps://itunes.apple.com/us/app/google-maps-real-time-navigation/id585027354?mt=8"
            guard let url = URL(string: iTunesLink) else {return}
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}

extension DetailsViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.mapClicked()
    }
    
}
