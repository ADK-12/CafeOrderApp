//
//  SearchResultViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 28/07/25.
//


import UIKit

class SearchResultViewController: UIViewController {

    var viewModal = SearchResultViewModel()
    
    var isPresented = false
    
    @IBOutlet var searchResultTableView: UITableView!
    
    var customCartButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CartManager.shared.totalQuantity > 0 {
            navigationController?.isToolbarHidden = false
            customCartButton.setTitle("\(CartManager.shared.totalQuantity) item(s) added", for: .normal)
        } else {
            navigationController?.isToolbarHidden = true
        }
    }
    
    
    func configuration() {
        navigationItem.largeTitleDisplayMode = .never
        searchResultTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        
        setupKeyboardNotification()
        setupSearchController()
        setupCartButton()
    }
    
    
    func setupKeyboardNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func adjustForKeyboard(notification: Notification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            searchResultTableView.contentInset = .zero
        } else {
            searchResultTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        searchResultTableView.scrollIndicatorInsets = searchResultTableView.contentInset
    }
    
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search in Menu"
        searchController.obscuresBackgroundDuringPresentation = false
        
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    
    func setupCartButton() {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "cart.fill")
        config.imagePlacement = .trailing
        config.imagePadding = 8
        config.baseBackgroundColor = .red
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        
        customCartButton = UIButton(configuration: config)
        customCartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        
        let cartButton = UIBarButtonItem(customView: customCartButton)
        toolbarItems = [cartButton]
    }
    
    
    @objc func cartTapped() {
        if let vc = storyboard?.instantiateViewController(identifier: "CartTableViewController") as? CartTableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}



extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModal.filteredMenu.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerView.backgroundColor = .systemBackground
        let titleLabel = UILabel(frame: headerView.bounds)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        titleLabel.textAlignment = .left
        titleLabel.text = viewModal.filteredMenu[section].type
        headerView.addSubview(titleLabel)
        
        if viewModal.filteredMenu[section].items.count > 0 {
            return headerView
        } else {
            return nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if viewModal.filteredMenu[section].items.count > 0 {
            return 50
        } else {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.filteredMenu[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as? MenuTableViewCell else {
            return UITableViewCell()
        }
        
        let item  = viewModal.filteredMenu[indexPath.section].items[indexPath.row]
        
        cell.item = item
        cell.onButtonTap = { [weak self] in
            let vc = AddItemSheet()
            vc.isCustomizable = item.isCustomizable
            vc.name = item.name
            vc.price = item.price
            vc.onDismiss = { [weak self] in
                if self?.isPresented ?? false {
                    if let presentingVC = self?.presentingViewController as? MenuViewController {
                        presentingVC.customCartButton.setTitle("\(CartManager.shared.totalQuantity) item(s) added", for: .normal)
                        presentingVC.navigationController?.isToolbarHidden = false
                    }
                } else {
                    self?.customCartButton.setTitle("\(CartManager.shared.totalQuantity) item(s) added", for: .normal)
                    self?.navigationController?.isToolbarHidden = false
                }
            }
            
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [
                    .custom{ _ in
                        if item.isCustomizable {
                            return 240
                        } else {
                            return 110
                        }
                    }
                ]
                sheet.preferredCornerRadius = 20
            }
               
            self?.present(vc, animated: true)
        }
        
        return cell
    }
    
}



extension SearchResultViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        viewModal.filteredMenu = viewModal.menu
        
        if let searchText = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            if !searchText.isEmpty {
                for i in 0 ..< viewModal.menu.count {
                    let filteredItems = viewModal.menu[i].items.filter { item in
                        item.name.lowercased().contains(searchText)
                    }
                    viewModal.filteredMenu[i].items = filteredItems
                }
            }
        }
        
        searchResultTableView.reloadData()
    }
    
}
