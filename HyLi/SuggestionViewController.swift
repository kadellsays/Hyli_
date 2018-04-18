//
//  SuggestionViewController.swift
//  HyLi
//
//  Created by Kadell on 11/22/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit
import GoogleMaps
import SDWebImage

class SuggestionViewController: UIViewController {
    
    private struct Constants {
        static let rightBarButton = #imageLiteral(resourceName: "buttonCircle")
    }

    fileprivate var suggestionTableView: SuggestionTableViewController?
    let fillerImage = UIImage(named: "hyliFiller")
    var suggestions = [NSDictionary]()
    var suggest: [Suggestions] = [Suggestions]()
    var previousMarker: GMSMarker!
    var allMarkers: [GMSMarker] = [GMSMarker]()
//    var mapView: GMSMapView!
    var firstLoad:Bool = false
    //cat
    //MARK: Outlets
    @IBOutlet weak var suggestionListButton: UIButton!
    @IBOutlet weak var mapSuggestionButton: UIButton!
    @IBOutlet weak var mapViewContainer: UIView!
//    @IBOutlet weak var viewForMap: UIView!
    
    @IBOutlet weak var viewForMap: GMSMapView!
    @IBOutlet weak var suggestionCell: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "HYLi"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 105.0/255.0, green: 65.0/255.0, blue: 142.0/255.0, alpha: 1)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.rightBarButton, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        
        self.loadMapView()
        self.mapViewContainer.isHidden = true
    
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
//            self.loadMapView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//         self.loadMapView()
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
        summaryLabel.text = currentSuggestion.description
        imageView.sd_setImage(with: URL(string: currentSuggestion.photo), placeholderImage: fillerImage, options: [.continueInBackground,.highPriority], completed: nil)

    }
    
    func rightBarButtonPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func loadMapView() {
        
        self.previousMarker = GMSMarker()
        allMarkers.removeAll()
        guard let firstSuggestionLatitude = Double(suggest[0].latitude) else {return}
        guard let firstSuggestionLongitude = Double(suggest[0].longitude) else {return}


        let camera = GMSCameraPosition.camera(withLatitude: firstSuggestionLatitude, longitude: firstSuggestionLongitude, zoom: 14.0)
        viewForMap.camera = camera
//        viewForMap = GMSMapView.map(withFrame: self.viewForMap.bounds , camera: camera)
        viewForMap.delegate = self
//        self.viewForMap.addSubview(mapView)
        
    
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
    
    //MARK: -ACTIONS
    
    @IBAction func suggestionListPressed(_ sender: UIButton) {
        mapSuggestionButton.setImage(UIImage(named: "buttonMapInactive"), for: .normal)
        suggestionListButton.setImage(UIImage(named: "buttonListActive"), for: .normal)
        
        self.mapViewContainer.isHidden = true
        self.suggestionCell.isHidden = true
    }
    
    @IBAction func mapListPressed(_ sender: UIButton) {
        mapSuggestionButton.setImage(UIImage(named: "buttonMapActive"), for: .normal)
        suggestionListButton.setImage(UIImage(named: "buttonListInactive"), for: .normal)
        
        self.mapViewContainer.isHidden = false
        self.suggestionCell.isHidden = false
        
        
//        allMarkers.removeAll()
//        self.previousMarker = GMSMarker()
//
//        guard let firstSuggestionLatitude = Double(suggest[0].latitude) else {return}
//        guard let firstSuggestionLongitude = Double(suggest[0].longitude) else {return}
//
//
//        let camera = GMSCameraPosition.camera(withLatitude: firstSuggestionLatitude, longitude: firstSuggestionLongitude, zoom: 14.0)
//        let mapView = GMSMapView.map(withFrame: self.viewForMap.bounds , camera: camera)
//        mapView.delegate = self
//        self.viewForMap.addSubview(mapView)
//
//        // Creates a marker in the center of the map.
//        for (index, suggestion) in suggest.enumerated() {
//            guard let currentLatitude = Double(suggestion.latitude) else {return}
//            guard let currentLongitude = Double(suggestion.longitude) else {return}
//
//            let marker = GMSMarker()
//
//            marker.icon = UIImage(named: "buttonMapSelectInactive")
//            marker.position = CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
//            marker.title = suggestion.venue_name
//            marker.map = mapView
//
//            allMarkers.append(marker)
//            if index == 0 {
//                self.setDataMapViewSuggestion(marker: marker)
//            }
//        }

    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let suggestionController = destination as? SuggestionTableViewController {
            
            suggestionTableView = suggestionController
            suggestionController.suggest = self.suggest
            
        }
        
        
    }
    
    
}

extension SuggestionViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.setDataMapViewSuggestion(marker: marker)
        
        return true
    }
    
}
