//
//  ShopCollectionViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 15/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

class ShopViewController: UIViewController, UICollectionViewDataSource {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    @IBOutlet weak var collectionView: UICollectionView!

    let layout = UICollectionViewFlowLayout()
    var estimateWidth = 160.0
    var cellMarginSize = 20.0
    
    var searching = false
    var searchGame = [Products]()
    let searchController = UISearchController(searchResultsController: nil)

    // MARK: - COLLETCION VIEW DATA
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchGame.count
        }
        
        else {
            return allProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
        
        if searching {
            cell.setup(game: searchGame[indexPath.row])
        }
        
        else {
            cell.setup(game: allProducts[indexPath.row])
        }
        
        return cell
    }
    
    


    // MARK: - PREPARE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductDetailViewController, let index = collectionView.indexPathsForSelectedItems?.first {
            if searching {
                vc.title = searchGame[index.row].title
                vc.bg1 = searchGame[index.row].bg1
                vc.poster = searchGame[index.row].poster
                vc.gameTitle = searchGame[index.row].title
                vc.platform = searchGame[index.row].platform
                vc.price = searchGame[index.row].price
                vc.bg2 = searchGame[index.row].bg2
                vc.gameDescription = searchGame[index.row].description
                vc.publisher = searchGame[index.row].publisher
                vc.developer = searchGame[index.row].developer
                vc.releaseDate = searchGame[index.row].releaseDate
            }
            
            else {
                vc.title = allProducts[index.row].title
                vc.bg1 = allProducts[index.row].bg1
                vc.poster = allProducts[index.row].poster
                vc.gameTitle = allProducts[index.row].title
                vc.platform = allProducts[index.row].platform
                vc.price = allProducts[index.row].price
                vc.bg2 = allProducts[index.row].bg2
                vc.gameDescription = allProducts[index.row].description
                vc.publisher = allProducts[index.row].publisher
                vc.developer = allProducts[index.row].developer
                vc.releaseDate = allProducts[index.row].releaseDate
            }
        }
    }
    


    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

        
        viewContext = app.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest <Cart> = Cart.fetchRequest()
        let predicate = NSPredicate(format: "username like '" + username + "'")
        fetchRequest.predicate = predicate
        
        do {
            let allGames = try viewContext.fetch(fetchRequest)
            var counter = 0
            for _ in allGames {
                counter += 1
            }
            
            let tabItems = tabBarController?.tabBar.items
            let tabItem = tabItems![2]

            
            if (counter == 0) {
                tabItem.badgeValue = nil
            }
            
            else {
                tabItem.badgeValue = String(counter)
            }
        }
        
        catch {
            print(error)
        }
    }
    


// MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        self.setupGridView()
        
        configureSearchController()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search game..."
    }
    
    
    
    
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
}

// MARK: - CHANGE SIZE OF CELL
extension ShopViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width * 1.5)
    }
    
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))

        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        
        let screenSize = view.frame.size.width
        // return CGFloat(((view.frame.size.width) / intCellCount) - 30)

        return width
    }
}




// MARK: - SEARCH
extension ShopViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
        
        let searchText = searchController.searchBar.text!
        
        if (searchText.isEmpty) {
            searching = false
            searchGame.removeAll()
            searchGame = allProducts
        }
        
        else {
            searching = true
            searchGame.removeAll()
            
            for game in allProducts {
                if game.title.lowercased().contains(searchText.lowercased()) {
                    searchGame.append(game)
                }
            }
        }
        
        collectionView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchGame.removeAll()
        collectionView.reloadData()
    }
}
