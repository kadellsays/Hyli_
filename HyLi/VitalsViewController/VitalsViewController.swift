//
//  VitalsViewController.swift
//  HyLi
//
//  Created by Kadell on 9/8/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit
import Alamofire

//AIzaSyB9_S2lwE2Sg88nlyVIgNUm7CAULvdwUF8

class VitalsViewController: UIViewController {
    
    
    var strainList = [String]()
    var crowdList = [String]()
    var locationList = [String]()
    var moodList = [String]()
    var selectionsDict = [String:String]()
    var suggestions = [Suggestions]()
    let apiBase = "api/search/"
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var indicatorView: UIView! = UIView()
    
    //MARK: OUTLETS
    @IBOutlet weak var WhatAreYouSmokingButton: UIButton!
    @IBOutlet weak var WhoAreYouWithButton: UIButton!
    @IBOutlet weak var WhereAreYouButton: UIButton!
    @IBOutlet weak var WhatsYourMoodButton: UIButton!
    
    @IBOutlet weak var hignessSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.setUpViewsActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
    }

    func setUpViewsActions() {
        
        let rightBarButton = #imageLiteral(resourceName: "buttonCircle")
        
        
        self.navigationItem.title = "Vitals"
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButton, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        
        setupButtons(buttons: [WhatAreYouSmokingButton, WhoAreYouWithButton, WhereAreYouButton, WhatsYourMoodButton])
        
    }
    
    func rightBarButtonPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    func setupButtons(buttons: [UIButton]) {
        
        for button in buttons {
            button.layer.cornerRadius = 0.45 * button.bounds.size.width
//                button.backgroundColor = UIColor(red: 255.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            
//            button.clipsToBounds = true
//            button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
//            button.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//            button.titleLabel?.textAlignment = NSTextAlignment.right
//            button.imageEdgeInsets = UIEdgeInsetsMake(0,imageLeftMarginSpacing, 0, 40)
//            button.titleEdgeInsets = UIEdgeInsetsMake(0,imageLeftMarginSpacing+imageTitleSpacing, 0, 0)
        }
    }
    
    
    //MARK: Custom Functions
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
    
    private func stopLoading() {
        
        DispatchQueue.main.async { [weak self] in
            self?.indicatorView.removeFromSuperview()
            self?.activityIndicator.stopAnimating()
        }
    }
   
    
    
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
    
//    func serverCall(uri: String, postData: String) {
//        let postString = postData
//       let requestString = "http://hyli-env.us-west-2.elasticbeanstalk.com:80/api/search/"
//        let url = URL(string: requestString)!
//        
//        var request = URLRequest(url: url)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//        request.httpBody = postString.data(using: .utf8)
//        
//        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
//            
//            guard let data = data, error == nil else {
//
//                
//                print("error=\(String(describing: error))")
//                return
//            }
//
//            if let httpStatus = response {
//        
//            }
//            
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as?  [String:AnyObject]
//                if let finalJson = json {
//                    self?.handleData(finalJson)
//                }
//            }
//            catch {
//                
//                let alert = UIAlertController(title: "Testing Networking Catch", message: "Their is an error", preferredStyle: UIAlertControllerStyle.alert)
//                let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.cancel, handler: nil)
//                alert.addAction(confirmAction)
//            }
//
//        }
//        task.resume()
//        
//    }
    
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
        let suggestionVC = self.storyboard?.instantiateViewController(withIdentifier: "suggestion") as! SuggestionViewController
    
        suggestionVC.suggestions = dict
        suggestionVC.suggest = self.suggestions

        print(json["resultData"])

        DispatchQueue.main.async {[weak self] in
            self?.navigationController?.pushViewController(suggestionVC, animated: true)
            
        }
        stopLoading()
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
    
    
    //MARK: ACTIONS
    @IBAction func smokinButtonClicked(_ sender: UIButton) {

        let strainViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionTableViewController
        strainViewContoller.selection = .strain
//        strainViewContoller.strainDelegate = self
        self.navigationController?.pushViewController(strainViewContoller, animated: true)
       
    }
    

    @IBAction func crowdButtonClicked(_ sender: UIButton) {
        let crowdViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionTableViewController
        crowdViewContoller.selection = .crowd
//        crowdViewContoller.crowdDelegate = self
        self.navigationController?.pushViewController(crowdViewContoller, animated: true)
    }
    
    @IBAction func LocationButtonClicked(_ sender: UIButton) {
        let locationViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionTableViewController
        locationViewContoller.selection = .location
//        locationViewContoller.locationDelegate = self
        self.navigationController?.pushViewController(locationViewContoller, animated: true)
    }
    
    
    @IBAction func MoodButtonClicked(_ sender: UIButton) {
        let moodViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionTableViewController
        moodViewContoller.selection = .mood
//        moodViewContoller.moodDelegate = self
        self.navigationController?.pushViewController(moodViewContoller, animated: true)
    }
    
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {
        if (NetworkReachabilityManager()?.isReachable)! {
            if selectionsDict["user_highness_quotient"] == nil {
                selectionsDict["user_highness_quotient"] = "5"
            }
            self.submitFunction()
        } else {
            //Network isnt reachable
        }
        
        
    }
    
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        let highness = Int(sender.value)
            selectionsDict["user_highness_quotient"] = "\(highness)"
    }
    
}
