//
//  Ext.Protocols.swift
//  HyLi
//
//  Created by Kadell on 1/17/18.
//  Copyright © 2018 HyLi. All rights reserved.
//

import Foundation

extension SelectionVC: StrainsViewDelegate, CrowdViewDelegate, MoodViewDelegate, LocationViewDelegate {
    
    func tagNumber(_ vital: VitalPressed, _ tags: [Int]) {
        
        switch vital {
        case .strain:
            selectionTag["user_strain_selection"] = tags
        case .crowd:
            selectionTag["user_crowd_selection"] = tags
        case .location:
            print("car")
        case .mood:
            selectionTag["user_mood_selection"] = tags
        }
//        selectionTag
    }
   
    
    func strainList(_ finalStrainSelection: [String]) {
        strainList = finalStrainSelection
        var finalStr = ""
        
        for strain in finalStrainSelection {
            finalStr  += "\(strain)"
        }
        
        if finalStr.isEmpty {
//            WhatAreYouSmokingButton.setTitle("WHAT YOU SMOKIN?", for: .normal)
            selectionsDict["user_strain_selection"] = ""
        } else {
            
            let valueString = self.valueTransformation(valueArray: finalStrainSelection)
//            let shortString = valueString

            selectionsDict["user_strain_selection"] = valueString
        
//            WhatAreYouSmokingButton.setTitle(shortString, for: .normal)
        }
    }
    
    func crowdList(_ finalCrowdSelection: [String]) {
        crowdList = finalCrowdSelection
        
        let finalStr = Helper.finalString(finalCrowdSelection)
        
        if finalStr.isEmpty {
//            WhoAreYouWithButton.setTitle("WHO YOU WITH?", for: .normal)
            selectionsDict["user_crowd_selection"] = ""
        } else {
            let valueString = self.valueTransformation(valueArray: finalCrowdSelection)
            
            selectionsDict["user_crowd_selection"] = valueString
//            WhoAreYouWithButton.setTitle(valueString, for: .normal)
        }
    }
    
    func locationList(_ finalLocationSelection: [String], _ latLong: [String]) {
        locationList = finalLocationSelection
        
        let finalStr = Helper.finalString(finalLocationSelection)
        
        if finalStr.isEmpty {
            
            selectionsDict["user_latitude"] = ""
            selectionsDict["user_longitude"] = ""
        } else {
            selectionsDict["user_latitude"] = latLong[0]
            selectionsDict["user_longitude"] = latLong[1]
            
        }
    }
    
    func moodList(_ finalMoodSelection: [String]) {
        moodList = finalMoodSelection
        var finalStr = ""
        
        for crowd in finalMoodSelection {
            finalStr  += "\(crowd)"
        }
        
        if finalStr.isEmpty {
//            WhatsYourMoodButton.setTitle("WHAT'S YOUR MOOD?", for: .normal)
            selectionsDict["user_mood_selection"] = ""
        } else {
            let valueString = self.valueTransformation(valueArray: finalMoodSelection)
            selectionsDict["user_mood_selection"] = valueString
//            WhatsYourMoodButton.setTitle(valueString, for: .normal)
            
        }
        
    }
}
