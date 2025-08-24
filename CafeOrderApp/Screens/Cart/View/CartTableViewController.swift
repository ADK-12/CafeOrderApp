//
//  CartTableViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 01/08/25.
//

import UIKit


class CartTableViewController: UITableViewController {

    var viewModal = CartViewModal()
    
    var totallabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModal.updateCart()
    }
    
    
    func configuration() {
        title = "Cart"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        
        setupToolbar()
    }
    
    
    @objc func trashTapped() {
        viewModal.trashTapped()
        navigationController?.popViewController(animated: true)
    }
    
    
    func setupToolbar() {
        totallabel.text = "Total: ₹\(viewModal.totalPrice)"
        totallabel.font = UIFont.boldSystemFont(ofSize: 20)
        totallabel.textAlignment = .center
        
        let finalPrice = UIBarButtonItem(customView: totallabel)
        finalPrice.customView?.frame.size.width = 150
        finalPrice.customView?.frame.size.height = 40
        finalPrice.customView?.contentMode = .center
        
        let placeOrderButton = UIButton(type: .system)
        placeOrderButton.backgroundColor = .systemGreen
        placeOrderButton.setTitle("Place Order", for: .normal)
        placeOrderButton.layer.cornerRadius = 10
        placeOrderButton.setTitleColor(.white, for: .normal)
        placeOrderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        placeOrderButton.addTarget(self, action: #selector(placeOrderTapped), for: .touchUpInside)
        
        let orderButton = UIBarButtonItem(customView: placeOrderButton)
        orderButton.customView?.frame.size.width = 150
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [spacer,finalPrice,spacer, orderButton, spacer]
        
        navigationController?.isToolbarHidden = false
    }
    
    
    @objc func placeOrderTapped() {
        navigationItem.backButtonTitle = ""
        
        let vc = OrderPlacedViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
}



extension CartTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModal.cartItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell else {
            return UITableViewCell()
        }
        
        cell.cartItem = viewModal.cartItems[indexPath.row]
        
        cell.onMinusTap = { [weak self] in
            self?.viewModal.cartItems[indexPath.row].quantity -= 1
            if self?.viewModal.cartItems[indexPath.row].quantity == 0 {
                self?.viewModal.cartItems.remove(at: indexPath.row)
                
                if self?.viewModal.cartItems.count == 0 {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            self?.totallabel.text = "Total: ₹\(self?.viewModal.totalPrice ?? 0)"
            self?.tableView.reloadData()
        }
        
        cell.onPlusTap = { [weak self] in
            if self?.viewModal.cartItems[indexPath.row].quantity ?? 0 < 10 {
                self?.viewModal.cartItems[indexPath.row].quantity += 1
                self?.totallabel.text = "Total: ₹\(self?.viewModal.totalPrice ?? 0)"
                self?.tableView.reloadData()
            }
        }
        
        return cell
    }
    
}
