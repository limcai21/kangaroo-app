//
//  WeatherViewController.swift
//  19_LimCai_Project
//
//  Created by xc50c2 on 2022-02-23.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
        
    struct weatherData: Codable {
        let area_metadata: [area_metadataAray]
        let items: [itemsArray]
        
        
        struct area_metadataAray: Codable {
            let name: String
            let label_location: label_locationArray
        }

        struct label_locationArray: Codable {
            let latitude: Double
            let longitude: Double
        }

        struct itemsArray: Codable {
            let forecasts : [forcastsArray]?
            enum CodingKeys: String, CodingKey {
                case forecasts = "forecasts"
            }
        }

        struct forcastsArray : Codable {
            let area : String?
            let forecast : String?

            enum CodingKeys: String, CodingKey {

                case area = "area"
                case forecast = "forecast"
            }
        }
    }
    
    
    
    var annotationLocation = [[String: Any]]()
        
    
    
    func loadData() {
        // output
        for location in annotationLocation {
            let ann = MKPointAnnotation()
            
            ann.title = location["name"] as! String?
            ann.subtitle = location["condition"] as! String?
            ann.coordinate = CLLocationCoordinate2DMake(location["lat"] as! CLLocationDegrees, location["long"] as! CLLocationDegrees)
            self.mapView.addAnnotation(ann)
        }
    }
    
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get weather locations
        guard let url = URL(string: "https://api.data.gov.sg/v1/environment/2-hour-weather-forecast")
        else { return }

        let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }

            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(weatherData.self, from: dataResponse)
                //  print(model)
                let locationCount = model.area_metadata.count
                for i in 0..<locationCount {
                    let lat = model.area_metadata[i].label_location.latitude
                    let long = model.area_metadata[i].label_location.longitude
                    let placeName = model.area_metadata[i].name
                    let weatherDetail = model.items[0].forecasts![i].forecast
                    print(lat)
                    self.annotationLocation.append(["name": placeName, "lat": lat, "long": long, "condition": weatherDetail])
                }
            }

            catch let parsingError {
                print("Error", parsingError)
            }
        }

        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let alert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
        self.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.loadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
