//
//  ItemSearchTableViewController.swift
//  AppStoreAPI
//
//  Created by Jason Koceja on 9/24/20.
//

import UIKit

class ItemSearchTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var entitySearchBar: UISearchBar!
    @IBOutlet weak var entitySegmentedControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var musicItems: [MusicItem] = []
    var appItems: [AppItem] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entitySearchBar.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func entitySegmentedControlValueChanged(_ sender: Any) {
        search()
    }
    
    // MARK: - Helpers
    
    func search() {
        guard let searchTerm = entitySearchBar.text, !searchTerm.isEmpty else {return}
        
        if entitySegmentedControl.selectedSegmentIndex == 0 {
            //music
            AppStoreItemController.fetchMusicItems(searchTerm: searchTerm) { (result) in
                switch result {
                    case .success(let searchedMusicItems):
                        self.musicItems = searchedMusicItems
                        print("[\(#function):\(#line)] -- \(self.musicItems.count) music items")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
                }
            }
        } else {
            // apps
            AppStoreItemController.fetchAppItems(searchTerm: searchTerm) { (result) in
                switch result {
                    case .success(let searchedAppItems):
                        self.appItems = searchedAppItems
                        print("[\(#function):\(#line)] -- \(self.appItems.count) app items")
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    case .failure(let error):
                        print("Error [\(#function):\(#line)] -- \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch entitySegmentedControl.selectedSegmentIndex {
            case 0:
                return self.musicItems.count
            case 1:
                return self.appItems.count
            default:
                return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "entityCell", for: indexPath) as? EntityTableViewCell else {return UITableViewCell()}
        
        switch entitySegmentedControl.selectedSegmentIndex {
            case 0:
                let track = musicItems[indexPath.row]
                cell.musicItem = track
                cell.appItem = nil
            case 1:
                let app = appItems[indexPath.row]
                cell.appItem = app
                cell.musicItem = nil
            default:
                break
        }
        cell.updateViews()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ItemSearchTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        search()
    }
}
