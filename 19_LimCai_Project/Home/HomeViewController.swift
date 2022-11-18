//
//  HomeViewController.swift
//  19_LimCai_Project
//
//  Created by CCIAD3 on 18/2/22.
//  Copyright © 2022 ITE. All rights reserved.
//

import UIKit
import CoreData

var categoryArray = [[Any]]()



class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var popularityTable: UITableView!
    @IBOutlet weak var sliderPageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    var sliderArray = [[Any]]()
    var timer: Timer?
    var currentCellIndex = 0
    var tagSelected = 0
    var categoryTagName = ""
    
    let layout = UICollectionViewFlowLayout()
    var estimateWidth = 414
    var cellMarginSize = 0.0
    
    
    var popularitySelectedIndex: Int!
    var popularGameArray = [[String]]()
    

    	

    
    
    // MARK: - SLIDER PAGE CONTROL
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextIndex() {
        if (currentCellIndex < sliderArray.count - 1) {
            currentCellIndex += 1
        }
        
        else {
            currentCellIndex = 0
        }
        collectionView.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        sliderPageControl.currentPage = currentCellIndex
    }
    
        
    
    // MARK: - RESPONSIVE LAYOUT
    func setupGridView() {
        let flow = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }    
    
    
    
    // MARK: - COLLECTION VIEW DATA
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sliderArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCell", for: indexPath) as! HomeCollectionViewCell
        cell.gameLogo.image = UIImage(named: sliderArray[indexPath.row][8] as! String)
        cell.gamePoster.image = UIImage(named: sliderArray[indexPath.row][12] as! String)
        cell.gameShortDesc.text = sliderArray[indexPath.row][9] as? String

        cell.backgroundColor = .clear

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        sliderPageControl.currentPage = indexPath.row
    }
    
    
    
    // MARK: - CATEGORY GAME FUNCTION
    func categoryGameArray() {
        categoryArray.removeAll()
        
        for i in 0..<allProducts.count {
            for tag in allProducts[i].tags {
                if (tag == categoryTagName) {
                    let gamePoster = allProducts[i].poster
                    let gameTitle = allProducts[i].title
                    let gameDesc = allProducts[i].description
                    let gameBg1 = allProducts[i].bg1
                    let gameBg2 = String(allProducts[i].bg2)
                    let gamePrice = allProducts[i].price
                    let gamePlatform = allProducts[i].platform
                    let gamePublisher = allProducts[i].publisher
                    let gameLogoTitle = allProducts[i].logo
                    let gameShortDesc = String(allProducts[i].shortD)
                    let gameDeveloper = String(allProducts[i].developer)
                    let gameRelease = String(allProducts[i].releaseDate)
                    let gameBg3 = allProducts[i].bg3

                    categoryArray.append([gamePoster, gameTitle, gameDesc, gameBg1, gameBg2, gamePrice, gamePlatform, gamePublisher, gameLogoTitle, gameShortDesc, gameDeveloper, gameRelease, gameBg3])
                }
            }
        }
    }
    





    // MARK: - CATEGORY BUTTON
    @IBAction func categoryBtn(_ sender: UIButton) {
        if (sender.tag == 1) {
            tagSelected = 1
            categoryTagName = "xbox"
            performSegue(withIdentifier: "toCategory", sender: nil)
        }
        
        if (sender.tag == 2) {
            tagSelected = 2
            categoryTagName = "playstation"
            performSegue(withIdentifier: "toCategory", sender: nil)
        }
        
        if (sender.tag == 3) {
            tagSelected = 3
            categoryTagName = "new"
            performSegue(withIdentifier: "toCategory", sender: nil)
        }
        
        if (sender.tag == 4) {
            tagSelected = 4
            categoryTagName = "multiplayer"
            performSegue(withIdentifier: "toCategory", sender: nil)
        }
        
        categoryGameArray()
    }
    
    
    
    @IBAction func seeAllGamesAZBtn(_ sender: Any) {
        tabBarController?.selectedIndex = 1
    }
    
    // MARK: - POPULARITY TABLE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = popularityTable.dequeueReusableCell(withIdentifier: "popularityCell", for: indexPath) as! PopularityTableViewCell
        cell.bg1.image = UIImage(named: popularGameArray[indexPath.row][3])
        cell.logo.image = UIImage(named: popularGameArray[indexPath.row][2])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popularitySelectedIndex = indexPath.row
        performSegue(withIdentifier: "fromHomePopularityToDetail", sender: nil)
    }
    
    
    


    // MARK: - PREPARE SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "fromHomeToDetail") {
            if let vc = segue.destination as? ProductDetailViewController, let index = collectionView.indexPathsForSelectedItems?.first {

                vc.poster = sliderArray[index.row][0] as? String
                vc.gameTitle = sliderArray[index.row][1] as! String
                vc.gameDescription = sliderArray[index.row][2] as! String
                vc.bg1 = sliderArray[index.row][3] as? String
                vc.bg2 = sliderArray[index.row][4] as? String
                vc.price = sliderArray[index.row][5] as? Double
                vc.platform = sliderArray[index.row][6] as! Array
                vc.publisher = sliderArray[index.row][7] as! String
                vc.releaseDate = sliderArray[index.row][11] as! String
                vc.developer = sliderArray[index.row][10] as! String
            }
        }
        
        
        if (segue.identifier == "fromHomePopularityToDetail") {
            let vc = segue.destination as! ProductDetailViewController
            
            for game in allProducts {
                if (game.title == popularGameArray[popularitySelectedIndex][0]) {
                    vc.poster = game.poster
                    vc.gameTitle = game.title
                    vc.gameDescription = game.description
                    vc.bg1 = game.bg1
                    vc.bg2 = game.bg2
                    vc.price = game.price
                    vc.platform = game.platform
                    vc.publisher = game.publisher
                    vc.releaseDate = game.releaseDate
                    vc.developer = game.developer
                }
            }
        }
        
        
        if (segue.identifier == "toCategory") {
            let vc = segue.destination as! CategoryViewController
            if (tagSelected == 1) {
                vc.title = "Xbox"
            }
            
            if (tagSelected == 2) {
                vc.title = "PlayStation"
            }
            
            if (tagSelected == 3) {
                vc.title = "New"
            }
            
            if (tagSelected == 4) {
                vc.title = "Multiplayer"
            }
        }
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    


    // MARK: - VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.largeTitleDisplayMode = .never
        scrollView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInsetAdjustmentBehavior = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        popularityTable.isScrollEnabled = false
        
        let username = (UserDefaults.standard.dictionary(forKey: "logonUser")?["username"] as! String)

        // update cart badge
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
        
        
        
        
        // get game popularity ranking
        popularGameArray.removeAll()
        
        let fetchRequest2: NSFetchRequest <Popularity> = Popularity.fetchRequest()
        let sort = NSSortDescriptor(key: "quantity", ascending: false)
        fetchRequest2.sortDescriptors = [sort]
        
        do {
            let allGameRank = try viewContext.fetch(fetchRequest2)
            
            if (allGameRank.isEmpty) {
                for game in allProducts {
                    let insertGame = NSEntityDescription.insertNewObject(forEntityName: "Popularity", into: viewContext) as! Popularity
                    insertGame.title = game.title
                    insertGame.quantity = 0
                    insertGame.logo = game.logo
                    insertGame.bg3 = game.bg3

                    app.saveContext()
                }
                    
                popularGameArray.removeAll()
                let fetchRequest3: NSFetchRequest <Popularity> = Popularity.fetchRequest()
                let sort = NSSortDescriptor(key: "quantity", ascending: false)
                fetchRequest3.sortDescriptors = [sort]
                
                do {
                    let allGameRank2 = try viewContext.fetch(fetchRequest3)
                    
                    for game in allGameRank2 {
                        let gameTitle = game.title
                        let gameQuantity = String(game.quantity)
                        let gameLogo = game.logo
                        let gameBg3 = game.bg3
                        
                        popularGameArray.append([gameTitle!, gameQuantity, gameLogo!, gameBg3!])
                    }
                }
            }
            
            else {
                for game in allGameRank {
                    let gameTitle = game.title
                    let gameQuantity = String(game.quantity)
                    let gameLogo = game.logo
                    let gameBg3 = game.bg3
                    popularGameArray.append([gameTitle!, gameQuantity, gameLogo!, gameBg3!])
                }
            }
        }
        
        catch {
            print(error)
        }
        
        popularityTable.reloadData()
    }
    
    
    // MARK: - VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        viewContext = app.persistentContainer.viewContext

        popularityTable.delegate = self
        popularityTable.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never

        // slider data
        sliderArray.removeAll()
        for i in 0..<allProducts.count {
            for tag in allProducts[i].tags {
                if (tag == "slider") {
                    let gamePoster = allProducts[i].poster
                    let gameTitle = allProducts[i].title
                    let gameDesc = allProducts[i].description
                    let gameBg1 = allProducts[i].bg1
                    let gameBg2 = String(allProducts[i].bg2)
                    let gamePrice = allProducts[i].price
                    let gamePlatform = allProducts[i].platform
                    let gamePublisher = allProducts[i].publisher
                    let gameLogoTitle = allProducts[i].logo
                    let gameShortDesc = String(allProducts[i].shortD)
                    let gameDeveloper = String(allProducts[i].developer)
                    let gameRelease = String(allProducts[i].releaseDate)
                    let gameBg3 = allProducts[i].bg3

                    sliderArray.append([gamePoster, gameTitle, gameDesc, gameBg1, gameBg2, gamePrice, gamePlatform, gamePublisher, gameLogoTitle, gameShortDesc, gameDeveloper, gameRelease, gameBg3])
                }
            }
        }
        
        
        startTimer()

        sliderPageControl.numberOfPages = sliderArray.count
    }
}




