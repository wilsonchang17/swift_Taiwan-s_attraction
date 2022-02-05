//
//  TableViewController.swift
//  FoodPin
//
//  Created by NDHU_CSIE on 2021/11/1.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    /*
    //use for deleting the core data in the swift app
    func deleteData() {
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restaurant")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for managedObject in results {
                if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                    context.delete(managedObjectData)
                    appDel.saveContext()
                }
            }
        } catch let error as NSError {
            print("Deleted all my data in myEntity error : \(error) \(error.userInfo)")
        }
    }*/
    var scenes = [
        Scene( photoCount: 2, image1: "photo0_0", image2: "photo0_1", image3: nil),
        Scene(  photoCount: 3, image1: "photo1_0", image2: "photo1_1", image3: "photo1_2"),
        Scene(photoCount: 2, image1: "photo2_0", image2: "photo2_1", image3: nil)
        ]
    
    var fetchResultController: NSFetchedResultsController<Restaurant>!
    var appDelegate: AppDelegate!
    var managedContext: NSManagedObjectContext!

    var restaurants:[Restaurant] = []
        
    lazy var dataSource = configureDataSource()
    
    var searchController: UISearchController!

    @IBOutlet weak var like: UILabel!
    var li = [] as [String]
    // MARK: - UITableView Life's Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // write initial data entries into the database if empty
        //self.deleteData()
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let count = try? managedContext.count(for: fetchRequest)
        if count == 0 { Restaurant.generateData() }
        // set the data source to the tableview
        tableView.dataSource = dataSource
                
        //Create the snapshot for the table view
//        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
//        snapshot.appendSections([.all])
//        snapshot.appendItems(restaurants, toSection: .all)
//        dataSource.apply(snapshot, animatingDifferences: false)
        
        //configure the navigation title
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure the Search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        //not change the color of the search contents
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search attraction..."
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(named: "NavigationBarTitle")

        like.text = "Likes"
       self.navigationItem.searchController = searchController
       //tableView.tableHeaderView = searchController.searchBar
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath)
        return cell
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let des = segue.destination as! DetailViewController
            let selectedRow = tableView.indexPathForSelectedRow!.row
            des.scene = scenes[selectedRow]
        }
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // fetch data from the data store
        fetchRestaurantData()   //will refresh the table view
        
        //display the walkthrough screen only for the first time
        //if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
        //return
        //}

        //let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        /*if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {

        present(walkthroughViewController, animated: true, completion: nil)
        }*/

    }


  
    // MARK: - UITableView Diffable Data Source

    func configureDataSource() -> DiffableDataSource {
        let cellIdentifier = "datacell"
        
        let dataSource = DiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, restaurant in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
                
                //configure the cell's data
                cell.nameLabel.text = restaurant.name
                cell.thumbnailImageView.image = UIImage(data: restaurant.image)
                cell.locationLabel.text = restaurant.location
                cell.typeLabel.text = restaurant.type
                cell.accessoryType = restaurant.isFavorite ? .checkmark : .none
                
                return cell
            }
        )
        
        return dataSource
    }
    
// handle the table cell selection
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) //return the currently slected cell
//        cell?.accessoryType = .checkmark
//        restaurants[indexPath.row].isFavorite = true
//        
//        tableView.deselectRow(at: indexPath, animated: false)  //de-selection
//    }
    
    
    // MARK: - UITableView Swipe Actions
    
    //swipe-to-right
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as favorite action
        let actionTitle = restaurants[indexPath.row].isFavorite ? "uncheck" : "check"
        let favoriteAction = UIContextualAction(style: .destructive, title: actionTitle) { (action, sourceView, completionHandler) in
            
            let cell = tableView.cellForRow(at: indexPath) as! TableViewCell
            //update source array
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false : true
            
            //save the data change when mark or unmark the favorites
            self.appDelegate.saveContext()
            if (self.restaurants[indexPath.row].isFavorite == true){
                self.li.append(self.restaurants[indexPath.row].name)
                let stringg = self.li.joined(separator: ", ")
                self.like.text = "I love: " + stringg
            }
            if (self.restaurants[indexPath.row].isFavorite == false){
                if let index = self.li.firstIndex(of: self.restaurants[indexPath.row].name){
                    self.li.remove(at: index)
                }
                let stringg = self.li.joined(separator: ", ")
                self.like.text = "I love: " + stringg
            }
            //update the cell's accessoryType
            cell.accessoryType = self.restaurants[indexPath.row].isFavorite ? .checkmark : .none
            
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // change the background color of the action button
        favoriteAction.backgroundColor = UIColor.systemYellow
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        
        return swipeConfiguration
    }
    
    //swipe-to-left
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Get the selected restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //disable the swiping action during the searching
        if searchController.isActive { return UISwipeActionsConfiguration() }

        
        //Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            // Delete the data from the data store
            self.managedContext.delete(restaurant)
            self.appDelegate.saveContext()

            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Change the button's color
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")

        
        // Configure the action as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeConfiguration

    }
    
    // MARK: - For Segue's function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //get the destination's view controller
                let destinationController = segue.destination as! DetailViewController
                //pass the data from the source side to the destination side
                destinationController.restaurant = restaurants[indexPath.row]
            }
        }
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Core Data
    
    func fetchRestaurantData(searchText:String = "") {
        
        // Get the NSFetchRequest object and set the sorting criteria (at least once)
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
    
        // Set the searching criteria
        if !searchText.isEmpty {
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@", searchText)
        // fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        }

        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Use the NSFetchedResultController to fetch and monitor the managed objects
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        //Start fetching data (run once and be monitored during the lifetime of the app)
        do {
            try fetchResultController.performFetch()
            updateSnapshot()  //create the snapshot for the table view
        } catch {
            print(error)
        }
    }
    
    func updateSnapshot() {
        // redirect the newly fetched objects to the restaurants array
        if let fetchedObjects = fetchResultController.fetchedObjects {
            restaurants = fetchedObjects
        }
        
        // Create a snapshot and refresh the tableview
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

}


extension TableViewController: NSFetchedResultsControllerDelegate {
    
    // this method will be called when the FetchedResultsController detects any data changes on fetched objects
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateSnapshot()
    }
    
}

extension TableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        fetchRestaurantData(searchText: searchText)
    }
    
}

