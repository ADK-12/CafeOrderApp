//
//  MenuViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 22/07/25.
//

import UIKit


class MenuViewController: UIViewController {
    
    private var viewModal = MenuViewModal()
    
    @IBOutlet var menuCollectionView: UICollectionView!
    @IBOutlet var viewAllButton: UIButton!
    
    var customCartButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateToolbar()
    }
    
    
    func configuration() {
        menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
        
        fetchMenu()
        
        fetchCart()
        
        setupCartButton()
    }
    
    
    func updateToolbar() {
        if viewModal.cartQuantity > 0 {
            navigationController?.isToolbarHidden = false
            customCartButton.setTitle("\(viewModal.cartQuantity) item(s) added", for: .normal)
        } else {
            navigationController?.isToolbarHidden = true
        }
    }
    
    
    func fetchMenu() {
        viewModal.onMenuFetch = { [weak self] event in
            switch event {
            case .loading:
                print("Loading...")
            case .dataLoaded:
                print("Menu Data Loaded")
                DispatchQueue.main.async {
                    self?.menuCollectionView.reloadData()
                    self?.setupSearchController()
                    self?.viewAllButton.isHidden = false
                }
            case .error(let error) :
                let ac = UIAlertController(title: "Menu Could Not Be Loaded", message: "\(String(describing: error))", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                DispatchQueue.main.async {
                    self?.present(ac, animated: true)
                }
            }
        }
        
        viewModal.fetchMenu()
    }
    
    
    func fetchCart() {
        viewModal.fetchCart()
        
        updateToolbar()
    }
    
    
    func setupCartButton() {
        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.image = UIImage(systemName: "cart.fill")
        buttonConfig.imagePlacement = .trailing
        buttonConfig.imagePadding = 8
        buttonConfig.baseBackgroundColor = .red
        buttonConfig.baseForegroundColor = .white
        buttonConfig.cornerStyle = .capsule
        
        customCartButton = UIButton(configuration: buttonConfig)
        customCartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        
        let cartButton = UIBarButtonItem(customView: customCartButton)
        toolbarItems = [cartButton]
    }
    
    
    @objc func cartTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CartTableViewController") as? CartTableViewController {
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    func setupSearchController() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController
        vc?.viewModal.isPresented = true
        let searchController = UISearchController(searchResultsController: vc)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search in Menu"
        searchController.obscuresBackgroundDuringPresentation = true
        
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    @IBAction func viewAllTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController {
            vc.viewModal.menu = viewModal.menu
            vc.viewModal.filteredMenu = viewModal.menu
            vc.hidesBottomBarWhenPushed = true
            vc.title = "Full Menu"
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}



extension MenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SearchResultViewController") as? SearchResultViewController {
            vc.viewModal.menu = viewModal.menu
            vc.viewModal.filteredMenu.append(viewModal.menu[indexPath.row])
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



extension MenuViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func didPresentSearchController(_ searchController: UISearchController) {
        tabBarController?.isTabBarHidden = true
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchResultVC = searchController.searchResultsController as? SearchResultViewController else { return }
        searchResultVC.viewModal.filteredMenu = viewModal.menu
        
        if let searchText = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            if !searchText.isEmpty {
                for i in 0 ..< viewModal.menu.count {
                    let filteredItems = viewModal.menu[i].items.filter { item in
                        item.name.lowercased().contains(searchText)
                    }
                    searchResultVC.viewModal.filteredMenu[i].items = filteredItems
                }
            }
        }

        searchResultVC.searchResultTableView.reloadData()
    }
    
    
    func didDismissSearchController(_ searchController: UISearchController) {
        tabBarController?.isTabBarHidden = false
    }

}
