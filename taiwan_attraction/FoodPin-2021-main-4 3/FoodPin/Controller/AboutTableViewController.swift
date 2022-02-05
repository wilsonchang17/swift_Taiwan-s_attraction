//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by 羅壽之 on 2021/12/19.
//
/*

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    enum Section: CaseIterable {
        case feedback
        case followus
    }

    struct LinkItem: Hashable {
        var text: String
        var link: String
        var image: String
    }

    var sectionContent =
        [ [LinkItem(text: "Rate us on App Store", link: "https://www.apple.com/ios/app-store/", image: "store"),
           LinkItem(text: "Tell us your feedback", link: "http://www.appcoda.com/contact", image: "chat")],
          [LinkItem(text: "Twitter", link: "https://twitter.com/appcodamobile", image: "twitter"),
           LinkItem(text: "Facebook", link: "https://facebook.com/appcodamobile", image: "facebook"),
           LinkItem(text: "Instagram", link: "https://www.instagram.com/appcodadotcom", image: "instagram")]
        ]
    
    lazy var dataSource = configureDataSource()



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use large title for the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = true

        // Load table data
        tableView.dataSource = dataSource
        updateSnapshot()


    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionLabel = UILabel()
        sectionLabel.backgroundColor = .systemGray2
        sectionLabel.text = "\(Section.allCases[section])"
        return sectionLabel
    }

    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, LinkItem> {
        
        let cellIdentifier = "aboutcell"
        
        let dataSource = UITableViewDiffableDataSource<Section, LinkItem>(tableView: tableView) { (tableView, indexPath, linkItem) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = linkItem.text
            cell.imageView?.image = UIImage(named: linkItem.image)
            
            return cell
        }
        
        return dataSource
    }
    
    func updateSnapshot() {
        
        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, LinkItem>()
        snapshot.appendSections([.feedback, .followus])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .followus)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        openWithSafariViewController(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func openWithSafariViewController(indexPath: IndexPath) {
        guard let linkItem = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        if let url = URL(string: linkItem.link) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }



    

   

}
*/
