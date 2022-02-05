//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/12/6.
//

import UIKit
import Foundation


class ReviewViewController: UIViewController {
    struct WeatherData: Codable {
        var name: String
        var main: Main
        var weather: [Weather]
        
    }
    
    struct Main: Codable {
        var temp: Double
        var humidity: Int
        var temp_min: Double
        var temp_max: Double
    }
    
    struct Weather: Codable {
        var description: String
        var icon: String        //icon file name
    }
    
    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var hum: UILabel!
    @IBOutlet weak var tempu: UILabel!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    var ttemp = ""
    @IBOutlet weak var city: UILabel!
    var restaurant: Restaurant!
    let api = "https://api.openweathermap.org/data/2.5/weather?"
    let key = "b9b0ce07b303a01c3ab30140bfb5491c"
    private let icon = "https://openweathermap.org/img/wn/"
    
    func getForcast(location: String){
        print(restaurant.type)
        guard let accessURL = URL(string: api + "q=\(location)&units=metric&lang=zh_tw&appid=\(key)") else {
            return
        }
        
        
        
        
        let request = URLRequest(url: accessURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            //parse data
            if let data = data {
                let decoder = JSONDecoder()
                if let weatherData = try? decoder.decode(WeatherData.self, from: data) {
                    //download weahter icon
                    self.getImage(weatherCode: weatherData.weather[0].icon)
                    //print(weatherData)
                    
                    
                    OperationQueue.main.addOperation {
                        self.tempu.text = "Temperature: " + String(weatherData.main.temp)
                        self.hum.text = "Humidity: " + String(weatherData.main.humidity)
                        //print(weatherData.weather[0].description)
                        self.cloud.text = "天氣狀況: " + String(weatherData.weather[0].description)
                     
                        
                    }
                }
                
            }
        })
        
        task.resume()
    }
    
    
    func getImage(weatherCode: String) {
        
        guard let accessURL = URL(string: icon + "\(weatherCode)@2x.png") else {
            return
        }
        
        let request = URLRequest(url: accessURL)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            //parse data
            if let data = data, let image = UIImage(data: data) {
                OperationQueue.main.addOperation {
                    self.pic.image  = image

                }
            }
        })
        
        task.resume()
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getForcast(location: restaurant.type)
        backgroundImageView.image = UIImage(data: restaurant.image)
        // Applying the blur effect
        let blurEffect = UIBlurEffect(style: .dark)   //.light or .extraLight
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        city.text = restaurant.type
        
        //let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        
        // Make the button invisible and off the screen
        /*for rateButton in rateButtons {
         rateButton.transform = moveRightTransform
         rateButton.alpha = 0
         }*/
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
     //Animate the rating buttons
     for index in 0...4 {
     UIView.animate(withDuration: 0.4, delay: 0.1+0.05*Double(index), options: [], animations: {
     self.rateButtons[index].alpha = 1.0
     self.rateButtons[index].transform = .identity
     }, completion: nil)
     }
     }
     */
    
}
