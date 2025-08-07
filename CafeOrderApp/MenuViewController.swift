//
//  MenuViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 22/07/25.
//


// checkpoint
// checkpoint

import UIKit



class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {

    @IBOutlet var menuCollectionView: UICollectionView!
    
    @IBOutlet var viewAllButton: UIButton!
    
    var menuData: Menu?
    
    var searchController: UISearchController?
    
    var searchResultVC: SearchResultViewController!
    
    var menuImages = [String]()
    
    var customCartButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Order"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.backButtonTitle = "Categories"
        
        fetchMenu()
        
        menuImages += ["coldBeverage", "hotBeverage", "food", "dessert"]
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
     
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "arrow.right.circle.fill")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseBackgroundColor = .red
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        customCartButton = UIButton(configuration: config)
        customCartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        
        let cartButton = UIBarButtonItem(customView: customCartButton)
        toolbarItems = [cartButton]
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if cartData.shared.allItems.count > 0 {
            navigationController?.isToolbarHidden = false
            customCartButton.setTitle("\(cartData.shared.totalQuantity) item(s) added", for: .normal)
        } else {
            navigationController?.isToolbarHidden = true
        }
    }
    
    
    func fetchMenu() {
        Task {
            do {
                menuData = try await APIManager().fetchData()
                
                DispatchQueue.main.async {
                    self.menuCollectionView.reloadData()
                    self.setupSearchController()
                    self.viewAllButton.isHidden = false
                }
                
            } catch {
                print("Could not load menu data")
                let ac = UIAlertController(title: "Menu Could Not Be Loaded", message: "Please check your internet connection", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    
    
    func setupSearchController() {
        searchResultVC = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
        
        searchController = UISearchController(searchResultsController: searchResultVC)
        searchController?.searchResultsUpdater = self
        searchController?.delegate = self
        searchController?.searchBar.placeholder = "Search in Menu"
        searchController?.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    @IBAction func viewAllTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        vc.hidesBottomBarWhenPushed = true
        vc.menuData = menuData
        vc.filteredMenuData = menuData
        vc.title = "Full Menu"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuData?.menu.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.layer.cornerRadius = 15
        cell.subMenuImage.layer.cornerRadius = 15
        cell.subMenuImage.image = UIImage(named: menuImages[indexPath.row])
        cell.subMenuLabel.text = menuData?.menu[indexPath.row].type
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController {
            vc.hidesBottomBarWhenPushed = true
            vc.menuData = menuData
            
            let filtered = Menu(menu: [menuData!.menu[indexPath.row]])
            vc.filteredMenuData = filtered
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        tabBarController?.isTabBarHidden = true
        
        let searchText = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if searchText.isEmpty {
            searchResultVC.filteredMenuData = menuData
        } else {
            var filteredMenuData = menuData!
            
            for i in 0..<menuData!.menu.count {
                let filteredItems = menuData!.menu[i].items.filter { item in
                    item.name.lowercased().contains(searchText)
                }
                
                filteredMenuData.menu[i].items = filteredItems
            }
            
            searchResultVC.filteredMenuData = filteredMenuData
        }
        
        searchResultVC.searchResultTableView.reloadData()
        searchResultVC.presentingVC = self
    }
    
    
    func didDismissSearchController(_ searchController: UISearchController) {
        tabBarController?.isTabBarHidden = false
    }
    
    
    @objc func cartTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CartTableViewController") as? CartTableViewController {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
