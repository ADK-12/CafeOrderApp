//
//  addItemViewController.swift
//  CoffeeDelivery
//
//  Created by Aditya Khandelwal on 29/07/25.
//

import UIKit

class AddItemViewController: UIViewController {

    var isCustomizable: Bool?
    var name: String?
    var price: Int?
    
    var quantityLabel = UILabel()
    var priceLabel = UILabel()
    var selectRegularButton = UIButton(type: .system)
    var selectLargeButton = UIButton(type: .system)
    var addItemButton = UIButton(type: .custom)
    
    
    var regularPrice: Int?
    
    var quantity = 1 {
        didSet {
            quantityLabel.text = "\(quantity)"
            priceLabel.text = "₹\((price ?? 100)*quantity)"
        }
    }
    
    weak var presentingVC: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regularPrice = price
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        
        setupSubViews()

        // Do any additional setup after loading the view.
    }
    
    
    func setupSubViews() {
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.numberOfLines = 3
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let crossButton = UIButton(type: .system)
        crossButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        crossButton.tintColor = .systemGray
        crossButton.imageView?.contentMode = .scaleAspectFit
        crossButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crossButton)
        crossButton.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        
        let separatorLine1 = UIView()
        separatorLine1.backgroundColor = .systemGray3
        separatorLine1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorLine1)
        
        let separatorLine2 = UIView()
        separatorLine2.backgroundColor = .systemGray3
        separatorLine2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorLine2)
        
        if isCustomizable ?? true {
            let sizeLabel = UILabel()
            sizeLabel.text = "Size"
            sizeLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            sizeLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(sizeLabel)
            
            let selectLabel = UILabel()
            selectLabel.text = "(Select one)"
            selectLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            selectLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(selectLabel)
            
            let regularLabel = UILabel()
            regularLabel.text = "Regular"
            regularLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
            regularLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(regularLabel)
            
            let largeLabel = UILabel()
            largeLabel.text = "Large"
            largeLabel.font = UIFont.systemFont(ofSize: 17, weight: .light)
            largeLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(largeLabel)
            
            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .blue
            
            selectRegularButton.configuration = config
            selectRegularButton.setImage(UIImage(systemName: "circle"), for: .normal)
            selectRegularButton.isSelected = true
            selectRegularButton.setImage(UIImage(systemName: "inset.filled.circle"), for: .selected)
            selectRegularButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(selectRegularButton)
            selectRegularButton.addTarget(self, action:#selector(selectRegularButtonTapped), for: .touchUpInside)
            
            selectLargeButton.configuration = config
            selectLargeButton.setImage(UIImage(systemName: "circle"), for: .normal)
            selectLargeButton.setImage(UIImage(systemName: "inset.filled.circle"), for: .selected)
            selectLargeButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(selectLargeButton)
            selectLargeButton.addTarget(self, action:#selector(selectLargeButtonTapped), for: .touchUpInside)
            

            NSLayoutConstraint.activate([
                sizeLabel.topAnchor.constraint(equalTo: separatorLine1.bottomAnchor, constant: 10),
                sizeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                
                selectLabel.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor),
                selectLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                
                regularLabel.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 10),
                regularLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                
                largeLabel.topAnchor.constraint(equalTo: regularLabel.bottomAnchor, constant: 10),
                largeLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                
                selectRegularButton.centerYAnchor.constraint(equalTo: regularLabel.centerYAnchor),
                selectRegularButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                
                selectLargeButton.centerYAnchor.constraint(equalTo: largeLabel.centerYAnchor),
                selectLargeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                
                separatorLine2.topAnchor.constraint(equalTo: largeLabel.bottomAnchor, constant: 20),
                separatorLine2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                separatorLine2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                separatorLine2.heightAnchor.constraint(equalToConstant: 1)
            ])
        } else {
            NSLayoutConstraint.activate([
                separatorLine2.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
                separatorLine2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                separatorLine2.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                separatorLine2.heightAnchor.constraint(equalToConstant: 1)
            ])
        }

        
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        minusButton.tintColor = .white
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        minusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        minusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(minusButton)
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        
        quantityLabel.text = "\(quantity)"
        quantityLabel.textColor = .white
        quantityLabel.textAlignment = .center
        quantityLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.widthAnchor.constraint(equalToConstant: 20).isActive = true
        view.addSubview(quantityLabel)
        
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        plusButton.tintColor = .white
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        plusButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(plusButton)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        let cutomStepper = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        cutomStepper.layer.cornerRadius = 20
        cutomStepper.backgroundColor = .blue
        cutomStepper.axis = .horizontal
        cutomStepper.alignment = .center
        cutomStepper.distribution = .fillProportionally
        cutomStepper.spacing = 6
        cutomStepper.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cutomStepper)
        
        addItemButton.setTitle("ADD ITEM   |         ", for: .normal)
        addItemButton.backgroundColor = .blue
        addItemButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        addItemButton.tintColor = .white
        addItemButton.layer.cornerRadius = 10
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(addItemTapped), for: .touchDown)
        
        priceLabel.text = "₹\((price ?? 100)*quantity)"
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        priceLabel.alpha = 1
        priceLabel.textColor = .white
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(priceLabel)
    
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
           
            crossButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            crossButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            separatorLine1.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            separatorLine1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            separatorLine1.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            separatorLine1.heightAnchor.constraint(equalToConstant: 1),
            
            cutomStepper.topAnchor.constraint(equalTo: separatorLine2.bottomAnchor, constant: 20),
            cutomStepper.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            addItemButton.topAnchor.constraint(equalTo: separatorLine2.bottomAnchor, constant: 20),
            addItemButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addItemButton.widthAnchor.constraint(equalToConstant: 220),
            addItemButton.heightAnchor.constraint(equalToConstant: 40),
            
            priceLabel.topAnchor.constraint(equalTo: separatorLine2.bottomAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: addItemButton.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 40),
            priceLabel.widthAnchor.constraint(equalToConstant: 70)
            ])
    }
    
    
    @objc func dismissSheet() {
        dismiss(animated: true)
    }
    
    
    @objc func selectRegularButtonTapped() {
        if price! > regularPrice! {
            price = regularPrice
            quantity += 0
        }
        selectRegularButton.isSelected = true
        selectLargeButton.isSelected = false
    }
    
    
    @objc func selectLargeButtonTapped() {
        if price! == regularPrice! {
            price! += 40
            quantity += 0
        }
        
        selectLargeButton.isSelected = true
        selectRegularButton.isSelected = false
    }
    
    
    @objc func minusTapped() {
        if quantity > 1 {
            quantity -= 1
        } else if quantity == 1 {
            dismiss(animated: true)
        }
    }
    
    
    @objc func plusTapped() {
        if quantity < 10 {
            quantity += 1
        }
    }
    
    
    @objc func addItemTapped() {
        dismiss(animated: true)
        
        var size: String?
        if isCustomizable ?? true {
            size = selectRegularButton.isSelected ? "Regular" : "Large"
        } else {
            size = nil
        }
        
        for (index,item) in cartData.shared.allItems.enumerated() {
            if item.name == name {
                if item.size == size {
                    cartData.shared.allItems[index].quantity += quantity
                    updateToolbar()
                    return
                }
            }
        }
        
        cartData.shared.allItems.append(item(name: name!, size: size, quantity: quantity, price: price!))
        
        updateToolbar()
    }
    
    
    
    func updateToolbar() {
        if let presentingVC = presentingVC as? SearchResultViewController {
            if let mainVC = presentingVC.presentingVC as? MenuViewController {
                mainVC.customCartButton.setTitle("\(cartData.shared.totalQuantity) item(s) added", for: .normal)
                mainVC.navigationController?.isToolbarHidden = false
                return
            } else if let mainVC = presentingVC.presentingVC as? SearchResultViewController {
                mainVC.customCartButton.setTitle("\(cartData.shared.totalQuantity) item(s) added", for: .normal)
                mainVC.navigationController?.isToolbarHidden = false
                return
            } else  {
                presentingVC.customCartButton.setTitle("\(cartData.shared.totalQuantity) item(s) added", for: .normal)
                presentingVC.navigationController?.isToolbarHidden = false
            }
            
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
