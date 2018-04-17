//
//  SuggestionTableViewController.swift
//  HyLi
//
//  Created by Kadell on 11/8/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit

class SuggestionTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var suggestions = [NSDictionary]()
    var suggest = [Suggestions]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(suggestions)
        
        setUpNavigationBar()
                
    }
    
    func setUpNavigationBar() {
        self.navigationItem.title = "HYLi"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    

}

extension SuggestionTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return suggest.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath) as! SuggestionTableViewCell
        
        let currentSuggestion = suggest[indexPath.section]
        
        cell.configureCell(currentSuggestion: currentSuggestion, cell: cell)
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let detailViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
            
            detailViewContoller.suggestion = self.suggest[indexPath.section]
            self.navigationController?.pushViewController(detailViewContoller
                , animated: true)
            
        }
    }
    
}
