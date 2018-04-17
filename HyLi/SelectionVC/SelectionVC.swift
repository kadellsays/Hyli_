//
//  SelectionVC.swift
//  HyLi
//
//  Created by Kadell on 3/6/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit
import Alamofire

class SelectionVC: UIViewController {

    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var WhatAreYouSmokingButton: VitalButtons!
    @IBOutlet weak var WhoAreYouWithButton: VitalButtons!
    @IBOutlet weak var WhereAreYouButton: VitalButtons!
    @IBOutlet weak var WhatsYourMoodButton: VitalButtons!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    let transition = PopAnimator()
    
    var selectedButton: UIView?
    var strainList = [String]()
    var crowdList = [String]()
    var locationList = [String]()
    var moodList = [String]()
    var suggestions = [Suggestions]()
    
    var indicatorView: UIView! = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var selectionsDict = [String:String]()
    var selectionTag = [String: [Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        setupViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.title = "Vitals"
        self.navigationController?.navigationBar.barStyle = .blackOpaque
//        self.navigationController?.navigationBar.tintColor = UIColor(red: 181.0/255.0, green: 116.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
    }

    
    func setGradientBackground() {
        let colorTop = UIColor.black.cgColor
        let colorBottom = UIColor.white.cgColor

        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        
        gradientLayer.locations = [ 0.0, 3.0]
        gradientLayer.frame = self.view.bounds
        
    self.backgroundImage.layer.insertSublayer(gradientLayer, at: 0)

    }


    func setupViews() {
        
        transition.dismissCompletion = {
            self.selectedButton!.isHidden = false
        }
        
        recommendBtn.layer.cornerRadius = recommendBtn.bounds.size.width / 2
        recommendBtn.clipsToBounds = true
        
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

        WhatsYourMoodButton.tintColor = UIColor.white
      
    }
    
    func valueTransformation(valueArray: [String]) -> String {
        
        var valueString = ""
        for (index, _) in valueArray.enumerated() {
            valueString += valueArray[index]
            
            
            if index != valueArray.count - 1 {
                valueString += ","
            }
            
        }
        return valueString
        
    }
    
    private func stopLoading() {
        
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.removeFromSuperview()
            self?.activityIndicator.stopAnimating()
        }
    }
    
    //MARK: -Networking
    
    func submitFunction() {
        
        if !self.validateSelections("user_strain_selection") {
            WhatAreYouSmokingButton.shake(count: 3.0, for: 0.3, withTranslation: 10)
        }else if !self.validateSelections("user_crowd_selection") {
            WhoAreYouWithButton.shake(count: 3.0, for: 0.3, withTranslation: 10)
        } else if !self.validateSelections("user_latitude") && !self.validateSelections("user_longitude") {
            WhereAreYouButton.shake(count: 3.0, for: 0.3, withTranslation: 10)
        } else if !self.validateSelections("user_mood_selection") {
            WhatsYourMoodButton.shake(count: 3.0, for: 0.3, withTranslation: 10)
        } else {
            
            startLoading()
            
            var componentsArr = [String]()
            
            for (_, selection) in selectionsDict.enumerated() {
                let component = "\(selection.key)=\(selection.value)"
                componentsArr.append(component)
            }
            
            
            
            let postData = componentsArr.joined(separator: "&")
            //        self.serverCall(uri: apiBase, postData: postData)
            APIRequestManager.manager.getData(endPoint: "http://hyli-env.us-west-2.elasticbeanstalk.com:80/api/search/", postData: postData, callback: { (data) in
                
                guard let data = data else {return}
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as?  [String:AnyObject]
                    if let finalJson = json {
                        self.handleData(finalJson)
                    }
                }
                catch {
                    self.stopLoading()
                    let alert = UIAlertController(title: "Testing Networking Catch", message: "Their is an error", preferredStyle: UIAlertControllerStyle.alert)
                    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(confirmAction)
                }
            })
        }
    }
    
    func handleData(_ json: [String:Any]) {
        
        guard let dict = json["resultData"] as? [NSDictionary] else {
            let alert = UIAlertController(title: "Server Error", message: "Please try again!", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            self.stopLoading()
            return
        }
        guard let convertedDict = json["resultData"] as? [[String:Any]] else {return}
        
        self.suggestions = Suggestions.getSuggestions(from: convertedDict)
        let tabBar = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        
        let suggestionTableViewController = tabBar?.childViewControllers[0] as? SuggestionTableViewController
        suggestionTableViewController?.suggest = self.suggestions
        
        let mapViewController = tabBar?.childViewControllers[1] as? MapSuggestionViewController
        mapViewController?.suggest = self.suggestions
//        let suggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "suggestion") as! SuggestionViewController
//
//        suggestionVC.suggestions = dict
//        suggestionVC.suggest = self.suggestions
        
//        print(json["resultData"])
        
        DispatchQueue.main.async {[weak self] in
//            self?.navigationController?.pushViewController(suggestionVC, animated: true)
            self?.navigationController?.pushViewController(tabBar!, animated: true)
            
        }
        stopLoading()
    }
    
    func validateSelections(_ key: String) -> Bool {
        var valid = false
        
        if selectionsDict.index(forKey: key) != nil {
            valid = true
        }
        
        return valid
    }
    
    private func startLoading() {
        
        indicatorView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height) )
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activityIndicator.frame = indicatorView.frame
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.alpha = 0.6
        
        
        indicatorView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.view.addSubview(indicatorView)
        
    }
    
    
    @IBAction func recommendBtnTapped(_ sender: UIButton) {
        
        if (NetworkReachabilityManager()?.isReachable)! {
            if selectionsDict["user_highness_quotient"] == nil {
                selectionsDict["user_highness_quotient"] = "5"
            }
            self.submitFunction()
        } else {
            //Network isnt reachable
        }
    }
    
    @IBAction func vitalButtonPressed(_ sender: VitalButtons) {
        selectedButton = sender.viewWithTag(sender.tag)
        let selectionTableVC = storyboard!.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionTableViewController
        selectionTableVC.transitioningDelegate = self
        
        
        switch sender.tag {
        case 0:
            if selectionTag["user_strain_selection"] != nil {
                selectionTableVC.tag = selectionTag["user_strain_selection"]!
            }
            selectionTableVC.selection = .strain
            selectionTableVC.strainDelegate = self
        case 1:
            if selectionTag["user_mood_selection"] != nil {
                selectionTableVC.tag = selectionTag["user_mood_selection"]!
            }
            selectionTableVC.selection = .mood
            selectionTableVC.moodDelegate = self
        case 2:
            selectionTableVC.selection = .location
            selectionTableVC.locationDelegate = self
        case 3:
            if selectionTag["user_crowd_selection"] != nil {
               selectionTableVC.tag = selectionTag["user_crowd_selection"]!
            }
            selectionTableVC.selection = .crowd
            selectionTableVC.crowdDelegate = self
        default:
            return
        }
        
        present(selectionTableVC, animated: true, completion: nil)
    }
    
    
}


extension SelectionVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.originFrame =
            selectedButton!.superview!.convert(selectedButton!.frame, to: nil)
        
        transition.presenting = true
        selectedButton!.isHidden = true
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
