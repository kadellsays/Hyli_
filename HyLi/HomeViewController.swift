//
//  ViewController.swift
//  HyLi
//
//  Created by Kadell on 9/7/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit
import CoreLocation


@objc protocol CenterViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func collapseSidePanels()
    @objc optional func closeTogglePanel()
}

class HomeViewController: UIViewController {
    
    private struct Constants {
        static let hamburgerButton = UIImage(named: "buttonHamburger")
        static let rightBarButton  = UIImage(named: "buttonCircle  ")
    }
    weak var delegate: CenterViewControllerDelegate?
    let locationManager = CLLocationManager()


    //MARK: Outlets
    @IBOutlet weak var RecommendButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestAlwaysAuthorization()
        lookUpCurrentLocation { (geoLoc) in
            print(geoLoc?.locality ?? "unkown Location")
            self.locationLabel.text = "\(String(describing: geoLoc?.locality)) Edition"
        }
        setUpActions()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()

//        presentLogIn()
    }
    
    func closeSideMenu() { delegate?.closeTogglePanel?() }
    
    func presentLogIn() {

        let logInController = self.storyboard?.instantiateViewController(withIdentifier: "LogIn") as! LogInController
        self.present(logInController
            , animated: true, completion: nil)
    }
    
    

    func setUpNavigationBar() {
        
        self.navigationController?.navigationBar.barStyle = .blackOpaque
        self.navigationController?.navigationBar.tintColor = .white
        
        let navBarBackground = #imageLiteral(resourceName: "bgHomeNavBar")
        
        self.navigationItem.title = "HYLi"
        
        self.navigationController?.navigationBar.setBackgroundImage(navBarBackground, for: .default)
    
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Constants.rightBarButton, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: Constants.hamburgerButton , style: .plain, target: self, action: #selector(leftBarButtonPressed))
    
        
    }
    
    func setUpActions() {
        RecommendButton.addTarget(self, action: #selector(recommendButtonPressed(sender:)), for: .touchUpInside)
        
        self.view.backgroundColor = .white
        
        
        //Set up Gesture Recognizer to close side menu when ever the HomeViewController is open
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeSideMenu))
        gesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(gesture)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        
    }
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation, completionHandler: { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    completionHandler(firstLocation)
                }
                else {
                    // An error occurred during geocoding.
                    completionHandler(nil)
                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    //MARK: -ACTIONS
    func recommendButtonPressed(sender: UIButton) {
        
                let vitalsViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "Selection") as! SelectionVC
                self.navigationController?.pushViewController(vitalsViewContoller, animated: true)
        
        
    }
    
    
    func leftBarButtonPressed() {
        delegate?.toggleLeftPanel?()
    }
    
    
    func rightBarButtonPressed() {
        
    }
}

extension HomeViewController: SidePanelViewControllerDelegate {
    
    func didSelect(_ label: SideMenuLabel) {
        

            delegate?.collapseSidePanels?()
        
        
    }
}



