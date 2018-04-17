//
//  SelectionTableViewController.swift
//  HyLi
//
//  Created by Kadell on 9/19/17.
//  Copyright © 2017 HyLi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

enum VitalPressed {
    case strain, mood, location, crowd
}

protocol tagDelegate: class {
    func tagNumber(_ vital: VitalPressed, _ tags: [Int])
}

protocol StrainsViewDelegate: class, tagDelegate {
    func strainList(_ finalStrainSelection: [String])
}

protocol CrowdViewDelegate: class, tagDelegate {
    func crowdList(_ finalCrowdSelection: [String])
}

protocol LocationViewDelegate: class, tagDelegate {
    func locationList(_ finalLocationSelection: [String], _ latLong: [String])
}

protocol MoodViewDelegate: class, tagDelegate {
    func moodList(_ finalMoodSelection: [String])
}


class SelectionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    private class Constants {
        static let strainReuseIdentifer = "strainType"
    }
    
    var selection: VitalPressed!
    var currentRow = 0
    let showChecked = false
    let locationManager = CLLocationManager()
    
    weak var strainDelegate: StrainsViewDelegate!
    weak var crowdDelegate: CrowdViewDelegate!
    weak var locationDelegate: LocationViewDelegate!
    weak var moodDelegate: MoodViewDelegate!
    
    var tag: [Int] = [Int]()
    private var finalSelection = [String]()
    private var locationTag: Int = Int.min
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vitalsLabel: UILabel!
    
    
    let  allStrainSelection = ["INDICA", "HYBRID", "SATIVA"]
    
    let allCrowdSelection = ["COWORKERS", "DATE", "DEALER", "FRIENDS", "LARGE GROUP", "MYSELF", "SIGNIFICANT OTHER / PARTNER", "SMALL GROUP"];
    
    let allLocationSelection = [
        "MY LOCATION","ALPHABET CITY", "ANNADALE","ARDEN HEIGHTS","ARLINGTON","ASTORIA", "BATTERY PARK CITY","BAY RIDGE","BAYCHESTER","BAYSIDE","BAYSWATER", "BED-STUY", "BEDFORD PARK","BELLEROSE","BELMONT","BENSONHURST","BOROUGH PARK", "BOWERY ", "BREEZY POINT","BROAD CHANNEL ","BRONX","BRONXDALE", "BROOKLYN","BROOKLYN HEIGHTS","BROWNSVILLE","BUSHWICK","CANARSIE",
        "CARROLL GARDENS","CASTLE HILL","CHELSEA","CHINATOWN","CITY ISLAND",
        "CLIFTON","CLINTON HILL","CO-OP CITY","COBBLE HILL","COLLEGE POINT",
        "CONEY ISLAND","CORONA","COUNTRY CLUB","CROWN HEIGHTS","DOUGLASTON",
        "DOWNTOWN","DUMBO","DYKER HEIGHTS","EAST NEW YORK","EAST VILLAGE",
        "EAST WILLIAMSBURG","EASTCHESTER","EDGEMERE","ELM PARK","ELMHURST",
        "EMERSON HILL","FAR ROCKAWAY","FI DI","FLATBUSH","FLATIRON", "FLATLANDS","FLUSHING","FORDHAM","FOREST HILLS","FORT GREENE",
        "FORT TOTTEN","FRESH MEADOWS","GLEN OAKS","GLENDALE","GOVERNORS ISLAND","GOWANUS","GRAMERCY PARK","GRANITEVILLE","GRANT CITY ","GREAT KILLS","GREENPOINT","GREENWICH VILLAGE","HARLEM", "HELL'S KITCHEN", "HOLLIS", "HOWARD BEACH", "HUDSON YARDS", "HUNTS POINT",
            "INWOOD",
        "JAMAICA",
        "JAMAICA ESTATES",
        "KEW GARDENS",
        "KINGSBRIDGE",
        "KIPS BAY",
        "KOREATOWN",
        "LAURELTON",
        "LENOX HILL",
        "LITTLE ITALY",
        "LITTLE NECK",
        "LONG ISLAND CITY",
        "LONGWOOD",
        "LOWER EAST SIDE",
        "MANHATTAN",
        "MANOR HEIGHTS",
        "MARBLE HILL",
        "MARINE PARK",
        "MASPETH",
        "MEAT PACKING",
        "MELROSE",
        "MIDDLE VILLAGE",
        "MIDTOWN",
        "MIDWOOD",
        "MILL BASIN",
        "MORNINGSIDE HEIGHTS",
        "MORRIS HEIGHTS",
        "MORRIS PARK",
        "MOTT HAVEN",
        "MURRAY HILL",
        "NOHO",
        "NOLITA",
        "NORWOOD",
        "OCEAN BREEZE",
        "OZONE PARK",
        "PARK SLOPE",
        "PARKCHESTER",
        "PELHAM BAY",
        "PELHAM GARDENS",
        "PELHAM PARKWAY",
        "PORT RICHMOND",
        "PROSPECT HEIGHTS",
        "QUEENS",
        "QUEENS VILLAGE",
        "RANDALLS ISLAND",
        "RED HOOK",
        "REGO PARK",
        "RICHMOND HILL",
        "RICHMOND VALLEY",
        "RICHMONDTOWN",
        "RIDGEWOOD",
        "RIVERDALE",
        "ROCKAWAYS",
        "ROSEDALE",
        "SAINT ALBANS",
        "SEAPORT",
        "SEASIDE",
        "SHORE ACRES",
        "SILVER LAKE",
        "SOHO",
        "SOUNDVIEW",
        "SPANISH HARLEM",
        "STATEN ISLAND",
        "SUNNYSIDE",
        "SUNSET PARK",
        "THE HUB",
        "TIMES SQUARE",
        "TOTTENVILLE",
        "TREMONT",
        "TRIBECA",
        "TURTLE BAY",
        "UNION SQUARE",
        "UNIVERSITY HEIGHTS",
        "UPPER EAST",
        "UPPER WEST",
        "VINEGAR HILL",
        "WAKEFIELD",
        "WASHINGTON HEIGHTS",
        "WEST FARMS",
        "WEST VILLAGE",
        "WESTERLEIGH",
        "WHITESTONE",
        "WILLIAMSBURG",
        "WILLOWBROOK",
        "WOODHAVEN",
        "WOODLAWN",
        "WOODSIDE",
        "YANKEE'S STADIUM"]
    
    let allMoodSelection = ["BORED", "CREATIVE", "DANCE-Y", "DEPRESSED", "DRUNK", "ECCENTRIC", "ENERGETIC", "HAPPY", "HIGH", "HUNGRY", "IN PAIN", "INSPIRED", "IRRITATED", "LAZY", "LONELY", "RELAXED", "SAD", "UPLIFTED"]
    
    var allLocationLatLong = [
    "BROOKLYN":"40.6782,-73.9442",
    "BROOKLYN HEIGHTS":"40.696,-73.9933",
    "CLINTON HILL":"40.6894,-73.9639",
    "DOWNTOWN":"40.696,-73.9845",
    "DUMBO":"40.7033,-73.9881",
    "FORT GREENE":"40.6921,-73.9742",
    "PROSPECT HEIGHTS":"40.6773,-73.9668",
    "VINEGAR HILL":"40.7037,-73.9823",
    "CARROLL GARDENS":"40.6795,-73.9992",
    "COBBLE HILL":"40.6865,-73.9962",
    "GOWANUS":"40.6733,-73.9903",
    "PARK SLOPE":"40.6681,-73.9806",
    "RED HOOK":"40.6773,-74.0094",
    "BED-STUY":"40.6872,-73.9418",
    "CROWN HEIGHTS":"40.6681,-73.9448",
    "FLATBUSH":"40.6409,-73.9624",
    "MIDWOOD":"40.6191,-73.9654",
    "BAY RIDGE":"40.6262,-74.0329",
    "BENSONHURST":"40.6113,-73.9977",
    "BOROUGH PARK":"40.6323,-73.9889",
    "DYKER HEIGHTS":"40.6215,-74.0096",
    "SUNSET PARK":"40.6455,-74.0124",
    "CONEY ISLAND":"40.5755,-73.9707",
    "FLATLANDS":"40.6268,-73.933",
    "MARINE PARK":"40.612,-73.933",
    "MILL BASIN":"40.6101,-73.911",
    "BROWNSVILLE":"40.6631,-73.9095",
    "CANARSIE":"40.6402,-73.9061",
    "EAST NEW YORK":"40.6568,-73.8831",
    "BUSHWICK":"40.6944,-73.9213",
    "EAST WILLIAMSBURG":"40.7159,-73.933",
    "GREENPOINT":"40.7245,-73.9419",
    "WILLIAMSBURG":"40.7081,-73.9571",
    "MANHATTAN":"40.7831,-73.9712",
    "INWOOD":"40.8677,-73.9212",
    "WASHINGTON HEIGHTS":"40.8417,-73.9394",
    "HARLEM":"40.8116,-73.9465",
    "MORNINGSIDE HEIGHTS":"40.809,-73.9624",
    "SPANISH HARLEM":"40.7957,-73.9389",
    "UPPER EAST":"40.7736,-73.9566",
    "LENOX HILL":"40.7662,-73.9602",
    "UPPER WEST":"40.787,-73.9754",
    "MIDTOWN":"40.7549,-73.984",
    "HELL'S KITCHEN":"40.7638,-73.9918",
    "TIMES SQUARE":"40.7589,-73.9851",
    "KOREATOWN":"40.7477,-73.9869",
    "MURRAY HILL":"40.7479,-73.9757",
    "TURTLE BAY":"40.754,-73.9668",
    "HUDSON YARDS":"40.7527,-74.0066",
    "KIPS BAY":"40.7423,-73.9801",
    "CHELSEA":"40.7465,-74.0014",
    "FLATIRON":"40.7401,-73.9903",
    "GRAMERCY PARK":"40.7368,-73.9845",
    "UNION SQUARE":"40.7359,-73.9911",
    "MEAT PACKING":"40.741,-74.0076",
    "ALPHABET CITY":"40.7261,-73.9786",
    "EAST VILLAGE":"40.7265,-73.9815",
    "GREENWICH VILLAGE":"40.7336,-74.0027",
    "NOHO":"40.7287,-73.9926",
    "BOWERY ":"40.7253,-73.9903",
    "WEST VILLAGE":"40.7358,-74.0036",
    "LOWER EAST SIDE":"40.715,-73.9843",
    "SOHO":"40.7233,-74.003",
    "NOLITA":"40.7229,-73.9955",
    "LITTLE ITALY":"40.7191,-73.9973",
    "CHINATOWN":"40.7158,-73.997",
    "FI DI":"40.7075,-74.0113",
    "TRIBECA":"40.7163,-74.0086",
    "SEAPORT":"40.7071,-74.0035",
    "BATTERY PARK CITY":"40.7122,-74.0161",
    "GOVERNORS ISLAND":"40.6895,-74.0168",
    "RANDALLS ISLAND":"40.7932,-73.9213",
    "QUEENS":"40.7282,-73.7949",
    "ASTORIA":"40.7644,-73.9235",
    "LONG ISLAND CITY":"40.7447,-73.9485",
    "SUNNYSIDE":"40.7433,-73.9196",
    "BAYSIDE":"40.7586,-73.7654",
    "BELLEROSE":"40.732,-73.7184",
    "COLLEGE POINT":"40.7864,-73.839",
    "DOUGLASTON":"40.7687,-73.7471",
    "FLUSHING":"40.7675,-73.8331",
    "FRESH MEADOWS":"40.7335,-73.7801",
    "FORT TOTTEN":"40.793,-73.7767",
    "GLEN OAKS":"40.7472,-73.7118",
    "KEW GARDENS":"40.7057,-73.8272",
    "LITTLE NECK":"40.7613,-73.7331",
    "WHITESTONE":"40.792,-73.8096",
    "CORONA":"40.745,-73.8643",
    "ELMHURST":"40.738,-73.8801",
    "FOREST HILLS":"40.7181,-73.8448",
    "GLENDALE":"40.699,-73.8804",
    "MASPETH":"40.7294,-73.9066",
    "MIDDLE VILLAGE":"40.7174,-73.8743",
    "REGO PARK":"40.7256,-73.8625",
    "RIDGEWOOD":"40.7044,-73.9018",
    "WOODSIDE":"40.7512,-73.9036",
    "HOLLIS":"40.7112,-73.7625",
    "JAMAICA":"40.7027,-73.789",
    "JAMAICA ESTATES":"40.7179,-73.7743",
    "LAURELTON":"40.6741,-73.7448",
    "QUEENS VILLAGE":"40.7157,-73.7419",
    "ROSEDALE":"40.6584,-73.739",
    "SAINT ALBANS":"40.6894,-73.7654",
    "HOWARD BEACH":"40.6571,-73.843",
    "OZONE PARK":"40.6794,-73.8507",
    "ROCKAWAYS":"40.5927,-73.7978",
    "RICHMOND HILL":"40.6958,-73.8272",
    "WOODHAVEN":"40.6901,-73.8566",
    "BAYSWATER":"40.6068,-73.7669",
    "BREEZY POINT":"40.5565,-73.9262",
    "BROAD CHANNEL ":"40.6158,-73.8213",
    "FAR ROCKAWAY":"40.5999,-73.7448",
    "SEASIDE":"40.5832,-73.8282",
    "EDGEMERE":"40.5942,-73.7743",
    "BRONX":"40.8448,-73.8648",
    "BEDFORD PARK":"40.8701,-73.8857",
    "BELMONT":"40.8523,-73.886",
    "FORDHAM":"40.8593,-73.8985",
    "KINGSBRIDGE":"40.8834,-73.9051",
    "MARBLE HILL":"40.8761,-73.9103",
    "NORWOOD":"40.8771,-73.8787",
    "RIVERDALE":"40.8941,-73.911",
    "UNIVERSITY HEIGHTS":"40.8596,-73.911",
    "WOODLAWN":"40.8976,-73.8669",
    "HUNTS POINT":"40.812,-73.8801",
    "LONGWOOD":"40.8248,-73.8916",
    "MELROSE":"40.8245,-73.9104",
    "MORRIS HEIGHTS":"40.8516,-73.9154",
    "MOTT HAVEN":"40.8091,-73.9229",
    "THE HUB":"40.8159,-73.918",
    "TREMONT":"40.8447,-73.8934",
    "WEST FARMS":"40.8431,-73.8816",
    "BAYCHESTER":"40.8694,-73.8331",
    "BRONXDALE":"40.8507,-73.8665",
    "CITY ISLAND":"40.8468,-73.7875",
    "CO-OP CITY":"40.8739,-73.8294",
    "EASTCHESTER":"40.8833,-73.8272",
    "MORRIS PARK":"40.8522,-73.8507",
    "PELHAM GARDENS":"40.8612,-73.8448",
    "PELHAM PARKWAY":"40.8553,-73.864",
    "WAKEFIELD":"40.8965,-73.8507",
    "YANKEE'S STADIUM":"40.8296,-73.9262",
    "CASTLE HILL":"40.8177,-73.8507",
    "COUNTRY CLUB":"40.8431,-73.8213",
    "PELHAM BAY":"40.8497,-73.8331",
    "SOUNDVIEW":"40.8251,-73.8684",
    "PARKCHESTER":"40.8383,-73.8566",
    "STATEN ISLAND":"40.5795,-74.1502",
    "ANNADALE":"40.5445,-74.1765",
    "ARDEN HEIGHTS":"40.5568,-74.1739",
    "ARLINGTON":"40.6323,-74.1651",
    "CLIFTON":"40.619,-74.0785",
    "ELM PARK":"40.6312,-74.1387",
    "EMERSON HILL":"40.6073,-74.0961",
    "GRANITEVILLE":"40.6188,-74.1563",
    "GRANT CITY ":"40.582,-74.1049",
    "GREAT KILLS":"40.5543,-74.1563",
    "MANOR HEIGHTS":"40.6047,-74.1269",
    "PORT RICHMOND":"40.6355,-74.1255",
    "OCEAN BREEZE":"40.5829,-74.0739",
    "RICHMOND VALLEY":"40.5201,-74.2293",
    "RICHMONDTOWN":"40.5674,-74.1343",
    "SHORE ACRES":"40.6099,-74.0667",
    "SILVER LAKE":"40.6245,-74.0917",
    "TOTTENVILLE":"40.5083,-74.2355",
    "WESTERLEIGH":"40.6163,-74.1387",
    "WILLOWBROOK":"40.6032,-74.1385"
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        backBtn.tintColor = UIColor.black
        setTitle(selection)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 33/255, green: 33.0/255, blue: 33.0/255, alpha: 1.0)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
    }
    
    func moveToVitalVC() {
        
    switch selection {
        case .strain:
            for num in tag {
                finalSelection.append(allStrainSelection[num])
            }
            strainDelegate.tagNumber(.strain, tag)
            strainDelegate.strainList(finalSelection)
        case .crowd:
            for num in tag {
                finalSelection.append(allCrowdSelection[num])
            }
            crowdDelegate.tagNumber(.crowd, tag)
            crowdDelegate.crowdList(finalSelection)
            
        case .location:
            var selection: String = ""
            var latLong = [String]()
            
            for num in tag {
                selection = allLocationSelection[num]
                finalSelection.append(allLocationSelection[num])
            }
            
            guard let latlong = allLocationLatLong[selection] else {return}
            let arrayOfLatLong = latlong.components(separatedBy: ",")
            let latitude = arrayOfLatLong[0]
            let longtitude = arrayOfLatLong[1]
            latLong.append(latitude)
            latLong.append(longtitude)
            
            
            locationDelegate.locationList(finalSelection, latLong)
        case .mood:
            for num in tag {
                finalSelection.append(allMoodSelection[num])
            }
            moodDelegate.tagNumber( .mood, tag)
            moodDelegate.moodList(finalSelection)
        case .none:
            print("none")
        case .some(_):
            print("wrapped")
        }
    }
    
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    switch selection {
        case .strain:
            return allStrainSelection.count
        case .crowd:
            return allCrowdSelection.count
        case .location:
            return allLocationSelection.count
        case .mood:
            return allMoodSelection.count
        case .none:
        return allStrainSelection.count
        case .some(_):
        return allStrainSelection.count

        }
        
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.strainReuseIdentifer , for: indexPath) as! SelectionTableViewCell
    
        cell.selectionStyle = .none
        cell.checkedImage.tag = indexPath.row
        cell.checkedImage.isHidden = tag.contains(cell.checkedImage.tag) ? false : true
        
        switch selection {
        case .strain:
            cell.selectionName.text = allStrainSelection[indexPath.row]
        case .crowd:
            cell.selectionName.text = allCrowdSelection[indexPath.row]
        case .location:
            cell.selectionName.text = allLocationSelection[indexPath.row]
        case .mood:
            cell.selectionName.text = allMoodSelection[indexPath.row]
        case .none:
            cell.selectionName.text = allMoodSelection[indexPath.row]

        case .some(_):
            cell.selectionName.text = allMoodSelection[indexPath.row]

        }
        
        return cell
    }
    
    
    func setTitle(_ selected: VitalPressed){
        
        switch selected {
        case .strain:
            self.vitalsLabel.text = "WHAT YOU SMOKIN?"
            self.navigationItem.title = "Strain Selection"
        case .crowd:
            self.vitalsLabel.text = "WHO YOU WITH?"
            self.navigationItem.title = "Crowd Selection"
        case .location:
            self.vitalsLabel.text = "WHERE ARE YOU?"
            self.navigationItem.title = "Location Selection"
        case .mood:
            self.vitalsLabel.text = "WHAT'S YOUR MOOD?"
            self.navigationItem.title = "Mood Selection"
        }
        
    }
    
    func currentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        if indexPath.row == 0 && selection == .location {
            currentLocation()
            tag = [indexPath.row]
            print("correct")
        } else if selection == .location {
            tag = [indexPath.row]
        } else {
            
            if tag.contains(indexPath.row) {
                let indexOf = tag.index(of: indexPath.row)
                tag.remove(at: indexOf!)
            } else {
                tag.append(indexPath.row)
            }
            
        }
        
            
            
            for row in 0..<numberOfRows {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section) ) as? SelectionTableViewCell {
                    
                    cell.checkedImage.isHidden = tag.contains(cell.checkedImage.tag) ? false : true

                }
            }

    }
    
    //MARK: -Actions
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        moveToVitalVC()
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension SelectionTableViewController: CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("we are here!")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        allLocationLatLong["MY LOCATION"] = "\(locValue.latitude), \(locValue.longitude)"
        lookUpCurrentLocation { (geoLoc) in
            print(geoLoc?.locality ?? "unkown Location")
        }
        
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
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
}
