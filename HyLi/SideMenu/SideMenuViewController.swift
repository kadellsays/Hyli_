//
//  SideMenuViewController.swift
//  HyLi
//
//  Created by Kadell on 3/1/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate: NSObjectProtocol {
    func didSelect(_ label: SideMenuLabel)
}


class SideMenuViewController: UIViewController {

    @IBOutlet weak var SideTableView: UITableView!
    @IBOutlet weak var HyliImage: UIImageView!
    
    var sideMenuLabels: Array<SideMenuLabel>!
    
    weak var sidePanelDelegate: SidePanelViewControllerDelegate?
   
    
    fileprivate enum CellIdentifiers {
        static let SideMenuCell = "SideMenuCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        HyliImage.image = HyliImage.image!.withRenderingMode(.alwaysTemplate)
        HyliImage.tintColor = UIColor.black
        
        
        SideTableView.dataSource = self
        SideTableView.delegate = self
        SideTableView.isScrollEnabled = false
        SideTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        SideTableView.reloadData()
       
    }

}

extension SideMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return sideMenuLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.SideMenuCell, for: indexPath) as! SideMenuCell
        
        cell.configure(sideMenuLabels[indexPath.row])
        
        return cell
    }
    
    
}


extension SideMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = sideMenuLabels[indexPath.row]
        
        let moodViewContoller = self.storyboard?.instantiateViewController(withIdentifier: "SelectionVC") as! SelectionTableViewController
        moodViewContoller.selection = .mood
        

       present(moodViewContoller, animated: true, completion: nil)
        
        
        sidePanelDelegate?.didSelect(selection)
    }
    
}


