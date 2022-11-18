//
//  CategoryViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 25/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!

    let layout = UICollectionViewFlowLayout()
    var estimateWidth = 160.0
    var cellMarginSize = 20.0

    var searching = false
    var searchGame = [[Any]]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    
    
    func calculateWidth() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))

        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
    
    
    
    
    
    // MARK: - COLLECTION VIEW DATA
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchGame.count
        }
        
        else {
            return categoryArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        
        if searching {
            cell.posterImage.image = UIImage(named: searchGame[indexPath.row][0] as! String)
        }

        else {
            cell.posterImage.image = UIImage(named: categoryArray[indexPath.row][0] as! String)
        }

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWidth()
        return CGSize(width: width, height: width * 1.5)
    }
        
    
    
    // MARK: - PREPARE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductDetailViewController, let index = collectionView.indexPathsForSelectedItems?.first {
            if (searching) {
                vc.bg1 = (searchGame[index.row][3] as! String)
                vc.poster = (searchGame[index.row][0] as! String)
                vc.gameTitle = searchGame[index.row][1] as! String
                vc.platform = searchGame[index.row][6] as! [String]
                vc.price = (searchGame[index.row][5] as! Double)
                vc.bg2 = (searchGame[index.row][4] as! String)
                vc.gameDescription = searchGame[index.row][2] as! String
                vc.publisher = searchGame[index.row][7] as! String
                vc.developer = searchGame[index.row][10] as! String
                vc.releaseDate = searchGame[index.row][11] as! String
            }

            else {
                vc.bg1 = (categoryArray[index.row][3] as! String)
                vc.poster = (categoryArray[index.row][0] as! String)
                vc.gameTitle = categoryArray[index.row][1] as! String
                vc.platform = categoryArray[index.row][6] as! [String]
                vc.price = (categoryArray[index.row][5] as! Double)
                vc.bg2 = (categoryArray[index.row][4] as! String)
                vc.gameDescription = categoryArray[index.row][2] as! String
                vc.publisher = categoryArray[index.row][7] as! String
                vc.developer = categoryArray[index.row][10] as! String
                vc.releaseDate = categoryArray[index.row][11] as! String
            }
        }
    }
    
    
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.largeTitleDisplayMode = .always
        collectionView.delegate = self
        collectionView.dataSource = self

        configureSearchController()
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




    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}



// MARK: - SEARCH
extension CategoryViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        print(#function)
        
        let searchText = searchController.searchBar.text!
        
        if (searchText.isEmpty) {
            searching = false
            searchGame.removeAll()
            searchGame = categoryArray
        }
        
        else {
            searching = true
            searchGame.removeAll()
            
            for game in categoryArray {
                let gameTitle = game[1] as! String
                if gameTitle.lowercased().contains(searchText.lowercased()) {
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

