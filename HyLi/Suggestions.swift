//
//  Suggestions.swift
//  HyLi
//
//  Created by Kadell on 11/9/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import Foundation

class Suggestions {
    
    var city: String
    var description: String
    var distance: String
    var highnessQuotient: Int
    var hours_operation: [String:Any]
    var latitude: String
    var locality: String
    var longitude: String
    var phone: String
    var photo: String
    var price: String
    var score: String
    var state: String
    var street: String
    var type: String
    var venue_id: Int
    var venue_name: String
    var web_link: String
    var zip: Int
    
    init() {
         city = ""
         description = ""
        distance = ""
         highnessQuotient = 0
         hours_operation = [:]
         latitude = ""
         locality = ""
         longitude = ""
         phone = ""
         photo = ""
         price = ""
         score = ""
         state = ""
         street = ""
         type = ""
         venue_id = 0
        venue_name = ""
         web_link = ""
         zip = 0
    }
    
    init(city:String, description:String, distance:String, highnessQuotient: Int, hours_operation: [String:Any], latitude: String,locality: String,longitude: String,phone: String, photo: String,price: String,score: String, state: String, street: String,type: String,venue_id: Int, venue_name: String, web_link: String,zip: Int) {
        
        self.city = city
        self.description = description
        self.distance = distance
        self.highnessQuotient = highnessQuotient
        self.hours_operation = hours_operation
        self.latitude = latitude
        self.locality = locality
        self.longitude = longitude
        self.phone = phone
        self.photo = photo
        self.price = price
        self.score = score
        self.state = state
        self.street = street
        self.type = type
        self.venue_id = venue_id
        self.venue_name = venue_name
        self.web_link = web_link
        self.zip = zip
    }
    
    convenience init?(withDict dict: [String:Any]) {

        let city = dict["city"] as? String ?? ""
        let description = dict["description"] as? String ?? ""
        let distance = dict["distance"] as? String ?? "0.0"
        let highnessQuotient = dict["highness_quotient"] as? Int ?? 0
        let hours_operation = dict["hours_operation"] as? [String:Any] ?? [:]
        let latitude = dict["latitude"] as? String ?? ""
        let locality = dict["locality"] as? String ?? ""
        let longitude = dict["longitude"] as? String ?? ""
        let phone = dict["phone"] as? String ?? ""
        let photo = dict["photo"] as? String ?? ""
        let price = dict["price"] as? String ?? ""
        let score = dict["score"] as? String ?? ""
        let state = dict[" state"] as? String ?? ""
        let street = dict["street"] as? String ?? ""
        let type = dict["type"] as? String ?? ""
        let venue_id = dict["venue_id"] as? Int ?? 0
        let venue_name = dict["venue_name"] as? String ?? ""
        let web_link = dict["web_link"] as? String ?? ""
        let zip = dict["zip"] as? Int ?? 0
        
        
        self.init(city: city, description: description, distance: distance, highnessQuotient: highnessQuotient, hours_operation: hours_operation, latitude: latitude, locality: locality, longitude: longitude, phone: phone, photo: photo, price: price, score: score, state: state, street: street, type: type, venue_id: venue_id, venue_name: venue_name, web_link: web_link, zip: zip)
    }
    
    
    static func getSuggestions(from suggestionArray:[[String:Any]]) -> [Suggestions] {
        var suggestions = [Suggestions]()
        for suggestion in suggestionArray {
            if let currentSuggestion = Suggestions(withDict: suggestion)  {
                suggestions.append(currentSuggestion)
            }
        }
        
        return suggestions
    }
    
    static func getHoursOfOperations() {}
    
    
}
