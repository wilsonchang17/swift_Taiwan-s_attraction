//
//  Restaurant.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/8.
//

import Foundation
import CoreData
import UIKit


// The Restaurant class is required for modeling core data objects

public class Restaurant: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restaurant> {
        return NSFetchRequest<Restaurant>(entityName: "Restaurant")
    }
    
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var location: String
    @NSManaged public var phone: String
    @NSManaged public var summary: String
    @NSManaged public var image: Data
    @NSManaged public var rating: String?
    @NSManaged public var isFavorite: Bool
    
    
    // implement one customized managed object constructor
    convenience init(name: String, type: String, location: String, phone: String, summary: String, image: String) {
        
        let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
        // call the original constructor to create one managed object
        self.init(context: appDelegate!.persistentContainer.viewContext)
        // fill the data fields from the passing parameters
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.summary = summary
        self.image = UIImage(named: image)!.pngData()!
    }
    
}


// This structure becomes useless in core data
// The Hashable protocol is needed for Diffable Data Source

//struct RestaurantTM: Hashable {
//    var name: String = ""
//    var type: String = ""
//    var location: String = ""
//    var phone: String = ""
//    var summary: String = ""
//    var image: String = ""
//    var isFavorite: Bool = false
//    var rating: String?
//}


//extend the definition of an existing structure or class
/*
 extension Restaurant {
 
 static func generateData( ) {  //no parameters
 let sourceArray = [
 Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location: "G/F, 72 Po Hing Fong, Sheung Wan, Hong Kong", phone: "232-923423", summary: "Searching for great breakfast eateries and coffee? This place is for you. We open at 6:30 every morning, and close at 9 PM. We offer espresso and espresso based drink, such as capuccino, cafe latte, piccolo and many more. Come over and enjoy a great meal.", image: "teakha.jpg"),
 Restaurant(name: "Homei", type: "Cafe", location: "Shop B, G/F, 22-24A Tai Ping San Street SOHO, Sheung Wan, Hong Kong", phone: "348-233423", summary: "A little gem hidden at the corner of the street is nothing but fantastic! This place is warm and cozy. We open at 7 every morning except Sunday, and close at 9 PM. We offer a variety of coffee drinks and specialties including lattes, cappuccinos, teas, and more. We serve breakfast, lunch, and dinner in an airy open setting. Come over, have a coffee and enjoy a chit-chat with our baristas.", image: "homei.jpg"),
 Restaurant(name: "Teakha", type: "Tea House", location: "Shop B, 18 Tai Ping Shan Road SOHO, Sheung Wan, Hong Kong", phone: "354-243523", summary: "Take a moment to stop and smell tealeaves! We are about the community, our environment, and all things created by the warmth of our hands. We open at 11 AM, and close at 7 PM. At teakha, we sell only the best single-origin teas sourced by our sister company Plantation directly from small tea plantations. The teas are then either cooked to perfection with milk in a pot or brewed.", image: "teakha.jpg"),
 ]
 
 //write initial data to the database
 
 var restaurant: Restaurant!
 if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
 for i in 0..<sourceArray.count {
 restaurant = Restaurant(context:appDelegate.persistentContainer.viewContext)
 restaurant.name = sourceArray[i].name
 restaurant.type = sourceArray[i].type
 restaurant.location = sourceArray[i].location
 restaurant.phone = sourceArray[i].phone
 restaurant.summary = sourceArray[i].summary
 restaurant.isFavorite = false
 //restaurant.image = UIImage(named:sourceArray[i].image)!.pngData()!
 }
 appDelegate.saveContext() //write once for all new restauranrs
 }
 
 
 
 }
 }
 */

extension Restaurant {
    
    static func generateData() {
        
        // create some managed objects for testing
        _ = [
            Restaurant(name: "Taipei 101", type: "Taipei", location: "Taipei 101", phone: "Click on the map below to see more detail", summary: "The Taipei 101 (台北101) is a supertall skyscraper designed by C.Y. Lee and C.P. Wang in Xinyi, Taipei, Taiwan. This building was officially classified as the world's tallest from its opening in 2004 until the 2010 completion of the Burj Khalifa in Dubai, UAE.", image: "photo0_0.jpg"),
             Restaurant(name: "Taroko National Park", type: "Hualien", location: "Taroko National Park, Hualien, Taiwan", phone: "Click on the map below to see more detail", summary: "Taroko National Park (太魯閣國家公園) is one of the nine national parks in Taiwan and was named after the Taroko Gorge, the landmark gorge of the park carved by the Liwu River. The park spans Taichung Municipality, Nantou County, and Hualien County and is located at Xiulin Township, Hualien County, Taiwan.", image: "photo1_0.jpg"),
             Restaurant(name: "Kenting National Park", type: "Pingtung", location: "Kenting National Park, Taiwan", phone: "Click on the map below to see more detail", summary: "Kenting National Park (墾丁國家公園) is a national park located on the Hengchun Peninsula of Pingtung County, Taiwan, covering Hengchun, Checheng, and Manzhou Townships. Established on 1 January 1984, it is Taiwan's oldest and the southernmost national park on the main island, covering the southernmost area of the Taiwan island along Bashi Channel.", image: "photo2_0.jpg"),
            
        ]
        
        //write all managed objects into the database
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        appDelegate.saveContext()
        
        
   
    }
    
}


