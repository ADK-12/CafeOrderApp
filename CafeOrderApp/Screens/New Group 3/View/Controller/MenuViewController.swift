//
//  MenuViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 22/07/25.
//


// checkpoint
// checkpoint

import UIKit



class MenuViewController: UIViewController, UICollectionViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    
    private var viewModal = MenuViewModal()

    @IBOutlet var menuCollectionView: UICollectionView!
    
    @IBOutlet var viewAllButton: UIButton!
    
    var searchController: UISearchController?
    
    var searchResultVC: SearchResultViewController!
    
    var customCartButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configuration()
        
     
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
    
    
    func configuration() {
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
        
        observeEvent()
        fetchMenu()
    }
    
    
    func fetchMenu() {
        viewModal.fetchMenu()
    }
    
    
    func observeEvent() {
        viewModal.eventHandler = { [weak self] event in
            switch event {
            case .loading:
                print("Loading...")
            case .stopLoading:
                print("Stop Loading")
            case .dataLoaded:
                print("Data Loaded")
                DispatchQueue.main.async {
                    self?.menuCollectionView.reloadData()
                    self?.setupSearchController()
                    self?.viewAllButton.isHidden = false
                }
                
            case .error(let error) :
                let ac = UIAlertController(title: "Menu Could Not Be Loaded", message: "\(error)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self?.present(ac, animated: true)
                }
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
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
//        vc.hidesBottomBarWhenPushed = true
//        vc.menuData = menuData
//        vc.filteredMenuData = menuData
//        vc.title = "Full Menu"
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController {
//            vc.hidesBottomBarWhenPushed = true
//            vc.menuData = menuData
//            
//            let filtered = Menu(menu: [menuData!.menu[indexPath.row]])
//            vc.filteredMenuData = filtered
//            
//            navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        tabBarController?.isTabBarHidden = true
        
//        let searchText = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        
//        if searchText.isEmpty {
//            searchResultVC.filteredMenuData = menuData
//        } else {
//            var filteredMenuData = menuData!
//            
//            for i in 0..<menuData!.menu.count {
//                let filteredItems = menuData!.menu[i].items.filter { item in
//                    item.name.lowercased().contains(searchText)
//                }
//                
//                filteredMenuData.menu[i].items = filteredItems
//            }
//            
//            searchResultVC.filteredMenuData = filteredMenuData
//        }
//        
//        searchResultVC.searchResultTableView.reloadData()
//        searchResultVC.presentingVC = self
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

}



extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModal.menu.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as? MenuCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.menu = viewModal.menu[indexPath.row]
        return cell
    }
}
