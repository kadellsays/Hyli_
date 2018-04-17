//
//  ContainerViewController.swift
//  HyLi
//
//  Created by Kadell on 3/1/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case collapsed
    case leftPanelExpanded
}

class ContainerViewController: UIViewController {
    
    var currentState: SlideOutState = .collapsed {
        didSet {
            let shouldShowShadow = currentState != .collapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: SideMenuViewController?
    var centerNavigationController: UINavigationController!
    var centerViewController:HomeViewController!
    let centerPanelExpandedOffset: CGFloat = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpCenterView()
    }
    
    func setUpCenterView() {
        //This function sets up the HomeViewController with a UINavigationbar
        centerViewController = UIStoryboard.homeViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
    }
    
}

extension ContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
        
    }
    
    func closeTogglePanel() {
        let expanded = currentState == .leftPanelExpanded
        if expanded {
           animateLeftPanel(shouldExpand: !expanded)
        }
    }
    
    func collapseSidePanels() {
        switch currentState {
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        guard leftViewController == nil else { return }
        
        if let vc = UIStoryboard.leftViewController() {
            vc.sideMenuLabels = SideMenuLabel.sideMenuAll()
            addChildSidePanelController(vc)
            leftViewController = vc
        }
    }
    
    
    func addChildSidePanelController(_ sideMenuController: SideMenuViewController) {
        sideMenuController.sidePanelDelegate = centerViewController
        view.insertSubview(sideMenuController.view, at: 0)
        
        addChildViewController(sideMenuController)
        sideMenuController.didMove(toParentViewController: self)
    }

    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .collapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, then completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}



private extension UIStoryboard {
    
    static func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func leftViewController() -> SideMenuViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftViewController") as? SideMenuViewController
    }
    
    static func homeViewController() -> HomeViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
}
