//
//  CartTableViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 01/08/25.
//

import UIKit

class CartTableViewController: UITableViewController {

    var cart = cartData.shared.allItems
    var totallabel = UILabel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Cart"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashTapped))
        
        totallabel.text = "Total: ₹\(cartData.shared.totalPrice)"
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
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        if let size = cart[indexPath.row].size {
            cell.name.text = cart[indexPath.row].name + "-(\(size))"
        } else {
            cell.name.text = cart[indexPath.row].name
        }
        
        cell.quantityLabel.text = "\(cart[indexPath.row].quantity)"
        cell.priceLabel.text = "₹\(cart[indexPath.row].price * cart[indexPath.row].quantity)"
        cell.minusButton.index = indexPath.row
        cell.minusButton.quantity = cart[indexPath.row].quantity
        cell.plusButton.index = indexPath.row
        cell.plusButton.quantity = cart[indexPath.row].quantity

        return cell
    }
    
    
    @IBAction func minusTapped(_ sender: CartDataButton) {
        var quantity = sender.quantity!
        
        quantity -= 1
        
        if quantity == 0 {
            cart.remove(at: sender.index!)
            
            if cart.count == 0 {
                cartData.shared.allItems = [item]()
                navigationController?.popViewController(animated: true)
                return
            }
        } else {
            cart[sender.index!].quantity = quantity
        }
        
        cartData.shared.allItems = cart
        totallabel.text = "Total: ₹\(cartData.shared.totalPrice)"
    
        tableView.reloadData()
    }
    
    
    @IBAction func plusTapped(_ sender: CartDataButton) {
        var quantity = sender.quantity!
        
        if quantity < 10 {
            quantity += 1
            cart[sender.index!].quantity = quantity
            cartData.shared.allItems = cart
            totallabel.text = "Total: ₹\(cartData.shared.totalPrice)"
            tableView.reloadData()
        }
    }
    
    
    @objc func trashTapped() {
        cartData.shared.allItems = [item]()
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func placeOrderTapped() {
        navigationItem.backButtonTitle = ""
        
        let vc = OrderPlacedViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
