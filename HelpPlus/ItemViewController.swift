//
//  ItemViewController.swift
//  HelpPlus
//
//  Created by rayhan on 7/25/17.
//  Copyright © 2017 rayhan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class ItemViewController: UIViewController {
    var latArray:[String]?
    var lngArray:[String]?
    
    var itemName: String?
    var mapView : GMSMapView?
    var placesClient: GMSPlacesClient!
    var manager : CLLocationManager = CLLocationManager()
    var latitude = ""
    var longitude = ""
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var dirUrl :String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyCFbN_xQ0VajLGtwRY9DH6_XfAErUXFFRI")
        
        placesClient = GMSPlacesClient.shared()
        
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            latitude = String(currentLocation.coordinate.latitude)
            longitude = String(currentLocation.coordinate.longitude)
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)

       // print(itemName)
       
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 16)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
            getMap()
        }
    }
    
    
    
    @IBAction func ShortestDuration(_ sender: Any) {
       
        let ur = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=23.75249,90.378164&destinations=23.752806,90.381668&key=AIzaSyCamxNbvz_avsy0WW3KuycZPlBe_R0HJ-Y"
        let url = URL(string: ur)

        let downLoadTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                let jsonRoot = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                print(jsonRoot)
               
            }catch{
            
            }
            
            }
        
        
        downLoadTask.resume()

    }
    
    
    
    
    func getMap(){
        let apiServerKey = "AIzaSyDyxE9-sKMWV896gUmL2RoQAZvQAFW-VyM"
        
        guard var n = itemName else {
            return
        }
        print(n)
        //let na = nam
        //        var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiServerKey)&location=\(self.lat),\(self.lg)&radius=\(500)&rankby=prominence&sensor=true"
        //   urlString += "&name=\(name)"
        
        print(latitude, longitude)
        let url1 = "https://maps.googleapis.com/maps/api/place/radarsearch/json?location=\(latitude),\(longitude)&radius=500&keyword=\(n)&key=\(apiServerKey)"
       //"https://maps.googleapis.com/maps/api/place/radarsearch/json?location=23.75249,90.378164&radius=5000&keyword=hospital&key=AIzaSyAB01zg6sV_NWvfI9vp3USDqkKUAhg_FTs"
        let url = URL(string: url1)
        guard let ur = url else {
            return
        }
        let downLoadTask = URLSession.shared.dataTask(with: ur) { (data, response, error) in
            do{
                let jsonRoot = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                
                print(jsonRoot!)
                
                guard let posts = jsonRoot?["results"] as? NSArray else{
                    return
                }
                
                
                
                if posts != nil {
                    
                    for index in 0..<posts.count {
                        
                        if let returnedPlace = posts[index] as? NSDictionary {
                            
                            var placeName = ""
                            var latitude = 0.0
                            var longitude = 0.0
                            
                            if let name = returnedPlace["name"] as? NSString {
                                placeName = name as String
                                print(placeName)
                            }
                            
                            if let geometry = returnedPlace["geometry"] as? NSDictionary {
                                if let location = geometry["location"] as? NSDictionary {
                                    if let lat = location["lat"] as? Double {
                                        latitude = lat
                                        self.latArray?.append(String(latitude))
                                        print(latitude)
                                    }
                                    
                                    if let lng = location["lng"] as? Double {
                                        longitude = lng
                                         self.latArray?.append(String(longitude))
                                        print(longitude)
                                    }
                                }
                            }
                            if let id = returnedPlace["place_id"] as? String {
                                let placeID = id
                                self.placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
                                    if let error = error {
                                        print("lookup place id query error: \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    guard let place = place else {
                                        print("No place details for \(placeID)")
                                        return
                                    }
                                    let marker = GMSMarker()
                                    
                                    // let dropPin = MKPointAnnotation()
                                    if let address = place.formattedAddress?.components(separatedBy: ", ") {
                                      
                                        
                                        print(address)
                                        
                                    }
                                    guard let add = place.formattedAddress?.components(separatedBy: ", ") else{
                                    return
                                    }
                                    guard let phn = place.phoneNumber else{
                                    return
                                    }
                                    
                                    
                                    //self.mapView.addAnnotation(dropPin1)
                                    
                                    //   dropPin.title = "\(place.name) , \(place.formattedAddress?.components(separatedBy: ", "))"
                                    self.dirUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(latitude),\(longitude)&destination=\(String(latitude)),\(String(longitude))&mode=walking&key=AIzaSyCftI6fjxAfIP8kdGWjV9HnDxFy5E2aOl0"
                                    marker.position = CLLocationCoordinate2D(latitude: Double(latitude), longitude: Double(longitude))                                    
                                    marker.title = "\(place.name), \(phn) "
                                    marker.map = self.mapView
                                    })
                            }
                        }
                    }
                }
            }catch{
            }
        }
        
        downLoadTask.resume()
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
