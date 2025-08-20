//
//  SearchResultViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 28/07/25.
//



//new processsss
// check point

import UIKit
import Kingfisher

class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate {

    @IBOutlet var searchResultTableView: UITableView!
    
    var searchController: UISearchController?
    
    var menuData: Menu?
    
    var filteredMenuData : Menu?

    var searchResultVC: SearchResultViewController!
    
    var customCartButton = UIButton(type: .system)
    
    weak var presentingVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchController()
        
        var config = UIButton.Configuration.filled()
        config.title = "\(cartData.shared.totalQuantity) item(s) added"
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
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
    
    
    func setupSearchController() {
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
//        filteredMenuData?.menu.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
//        if(filteredMenuData?.menu[section].items.count)! > 0 {
//            return filteredMenuData?.menu[section].type
//        } else {
//            return nil
//        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
//        filteredMenuData?.menu[section].items.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultMenuCell") as! ResultMenuCell
//        
//        let item = filteredMenuData!.menu[indexPath.section].items[indexPath.row]
//        cell.nameLabel.text = item.name
//        cell.priceLabel.text = "₹\(item.price)"
//        cell.descriptionLabel.text = item.description
//        
//        let urlString = item.image
//        if let url = URL(string: urlString) {
//            cell.itemImage.kf.setImage(with: url)
//            cell.itemImage.layer.cornerRadius = 20
//        }
//        
//        
//        cell.addButton.layer.cornerRadius = 15
//        cell.addButton.layer.borderWidth = 1
//        cell.addButton.layer.borderColor = UIColor.lightGray.cgColor
//        cell.addButton.name = item.name
//        cell.addButton.price = item.price
//        
//        let isCustomizable = filteredMenuData?.menu[indexPath.section].type == "Cold Beverages" || filteredMenuData?.menu[indexPath.section].type  == "Hot Beverages"
//        
//        if isCustomizable {
//            cell.addButton.isCustomizable = true
//        } else {
//            cell.customizeLabel.isHidden = true
//            cell.addButton.isCustomizable = false
//        }
//        
        return cell
    }
    

    @IBAction func addTapped(_ sender: CustomDataButton) {
        let vc = AddItemViewController()
            
        vc.isCustomizable = sender.isCustomizable
        vc.name = sender.name
        vc.price = sender.price
        vc.presentingVC = self
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .custom{ _ in
                    if sender.isCustomizable ?? true {
                        return 240
                    } else {
                        return 110
                    }
                }
            ]
        }
            
        present(vc, animated: true)
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
//        let searchText = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
//        
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
    
    
    @objc func cartTapped() {
        if let vc = storyboard?.instantiateViewController(identifier: "CartTableViewController") as? CartTableViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
