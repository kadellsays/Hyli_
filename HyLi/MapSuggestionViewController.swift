//
//  MapSuggestionViewController.swift
//  HyLi
//
//  Created by Kadell on 3/22/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage

class MapSuggestionViewController: UIViewController {
    
    
    @IBOutlet weak var viewForMap: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    var previousMarker: GMSMarker!
    var allMarkers: [GMSMarker] = [GMSMarker]()
    var suggest: [Suggestions] = [Suggestions]()
//    var suggest = [Suggestions(city: "Cambria Heights", description: "Hey yo", distance: "3.45", highnessQuotient: 3, hours_operation: ["monday": 2], latitude: "34.5", locality: "-73.40", longitude: "-36.65", phone: "123-345-5678", photo: "https://car-images.bauersecure.com/pagefiles/76804/1040x585/audi-a8-swb-001.jpg", price: "$", score: "3", state: "New York", street: "11603", type: "cat", venue_id: 234, venue_name: "New", web_link: "www.nba.com", zip: 18291) ]
    let fillerImage = UIImage(named: "hyliFiller")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationItem.title = "HYLi"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 105.0/255.0, green: 65.0/255.0, blue: 142.0/255.0, alpha: 1)
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.rightBarButton, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        
        self.loadMapView()
        
    }
    
    func loadMapView() {
        
        self.previousMarker = GMSMarker()
        allMarkers.removeAll()
        guard let firstSuggestionLatitude = Double(suggest[0].latitude) else {return}
        guard let firstSuggestionLongitude = Double(suggest[0].longitude) else {return}
        
        
        let camera = GMSCameraPosition.camera(withLatitude: firstSuggestionLatitude, longitude: firstSuggestionLongitude, zoom: 14.0)
        viewForMap.camera = camera
      
        viewForMap.delegate = self
    
        
        
        // Creates a marker in the center of the map.
        for (index, suggestion) in suggest.enumerated() {
            guard let currentLatitude = Double(suggestion.latitude) else {return}
            guard let currentLongitude = Double(suggestion.longitude) else {return}
            
            let marker = GMSMarker()
            
            marker.icon = UIImage(named: "buttonMapSelectInactive")
            marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
            marker.title = suggestion.venue_name
            marker.map = viewForMap
            
            allMarkers.append(marker)
            if index == 0 {
                self.setDataMapViewSuggestion(marker: marker)
            }
        }
        
    }
    
    func setDataMapViewSuggestion(marker: GMSMarker) {
        //Set previous marker to inactive while setting current marker to active
        previousMarker.icon = UIImage(named: "buttonMapSelectInactive")
        marker.icon = UIImage(named: "buttonMapSelectActive")
        previousMarker = marker
        
        guard let index = allMarkers.index(of: marker) else {return}
        guard index < suggest.count else {return}
        
        let currentSuggestion = suggest[index]
        nameLabel.text = currentSuggestion.venue_name
        distanceLabel.text = currentSuggestion.distance + " miles"
        locationLabel.text = "\(currentSuggestion.type), \(currentSuggestion.price), \(currentSuggestion.city)"
//        summaryLabel.text = currentSuggestion.description
        imageView.sd_setImage(with: URL(string: currentSuggestion.photo), placeholderImage: fillerImage, options: [.continueInBackground,.highPriority], completed: nil)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapSuggestionViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.setDataMapViewSuggestion(marker: marker)
        
        return true
    }
}
