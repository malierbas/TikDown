//
//  PaywallViewController.swift
//  TikDown
//
//  Created by Ali on 20.05.2022.
//

import Foundation
import RevenueCat
import StoreKit
import UIKit

class PaywallViewController: BaseViewController {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var premiumDescriptionsStackView: UIStackView!
    @IBOutlet weak var plansStackView: UIStackView!
    @IBOutlet weak var firstPlanView: UIView!
    @IBOutlet weak var secondPlanView: UIView!
    @IBOutlet weak var secondPlanPopularView: UILabel!
    @IBOutlet weak var firstContentView: UIView!
    @IBOutlet weak var secondContentView: UIView!
    @IBOutlet weak var startButtonOutlet: UIButton!
    
    //desc: views-product-first
    @IBOutlet weak var firstPlanPopularView: UILabel!
    @IBOutlet weak var firstProductPriceLabel: UILabel!
    @IBOutlet weak var firstFreeDescLabel: UILabel!
    @IBOutlet weak var firstBottomDescLabel: UILabel!
    //desc: second
    @IBOutlet weak var secondFreeDescLabel: UILabel!
    @IBOutlet weak var secondProductPriceLabel: UILabel!
    @IBOutlet weak var secondBottomDescLabel: UILabel!
    
    
    //desc: variables
    let viewModel = PaywallViewModel.instance
    var models: [SubscriptionModel] = []
    var selectedProduct: Package? = nil
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup ui
        setupUI()
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    //MARK: Functions
    func setupUI() {
        viewModel.setDescriptions(stackView: premiumDescriptionsStackView)
        
        startButtonOutlet.rounded()
        secondPlanPopularView.rounded()
        
        firstContentView.setRadius(radii: 8)
        secondContentView.setRadius(radii: 8)
        
        viewModel.fetchProducts() { products in
            DispatchQueue.main.async {
                
                if !products.isEmpty {
                    self.models = products
                    self.setupProductData()
                    AppUtils.hideIndicator(on: self)
                }
            }
        }
        
        AppUtils.showIndicator(on: self)
        
        let firstProductGesture = UITapGestureRecognizer(target: self, action: #selector(firstProductTapped(_:)))
        let secondProductGesture = UITapGestureRecognizer(target: self, action: #selector(secondProductTapped(_:)))
        self.firstContentView.addGestureRecognizer(firstProductGesture)
        self.secondContentView.addGestureRecognizer(secondProductGesture)
        
        NotificationCenter.default.addObserver(forName: Notification.Name.IAPHelperPurchaseFailNotification, object: nil, queue: .main) { notification in
            DispatchQueue.main.async {
                print("did fail product process")
                AppUtils.hideIndicator(on: self)
                LocalStorageManager.shared.hasCredit = false
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.IAPHelperPurchaseNotification, object: nil, queue: .main) { notification in
            DispatchQueue.main.async {
                AppUtils.hideIndicator(on: self)
                LocalStorageManager.shared.hasCredit = true
                AppUtils.showConfetti(self, .star, [UIColor.init(named: "AccentColor")!, UIColor.init(named: "redDominant")!, UIColor.init(named: "unUseed")!], 0.75)
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    AppUtils.hideConfetti()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func setupProductData() {
        if !models.isEmpty {
            for (index, subModel) in models.enumerated() {
                guard let identifier = subModel.idendifier, let _ = subModel.product else {
                    
                    return
                }
                
                if identifier.contains(Product.weekly.rawValue) {
                    //desc: setup weekly
                    firstPlanPopularView.fadeOut()
                    firstFreeDescLabel.fadeIn()
                    firstBottomDescLabel.fadeOut()
                    
                    if let price = subModel.price, let _ = subModel.currencySymbol {
                        
                        let newPrice = "\(price)/\nweek"
                        firstProductPriceLabel.text = newPrice
                    }
                    
                    firstContentView.tag = index
                } else if identifier.contains(Product.yearly.rawValue) {
                    //desc: setup yearly
                    secondPlanPopularView.fadeIn()
                    secondFreeDescLabel.fadeOut()
                    secondBottomDescLabel.fadeIn()
                    
                    if let price = subModel.price, let symbol = subModel.currencySymbol {
                        
                        let newPrice = "\(price)/\nyear"
                        secondProductPriceLabel.text = newPrice
                        
                        
                        //desc: divide to 52 for weekly price
                        secondBottomDescLabel.text = "only \(symbol)\(subModel.perByWeek ?? "")/week"
                    }
                    
                    secondContentView.tag = index
                    
                    if let productType = Product.allCases.first(where: { $0.rawValue.contains(subModel.idendifier ?? "") }) {
                        changeUI(product: productType)
                        selectedProduct = subModel.product
                    }
                } else if identifier.contains(Product.monthly.rawValue) {
                    //desc: setup monthly(not yet)
                }
            }
        }
    }
    
    //MARK: Actions
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if let product = selectedProduct {
            AppUtils.showIndicator(on: self)
            viewModel.selectProduct(product)
        } else {
            AppUtils.showAlert(
                on: self,
                "Opps!",
                "You did not select product!",
                callback: nil
            )
        }
    }
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        viewModel.restoreProdut()
    }
    
    @IBAction func termsOfUseTapped(_ sender: Any) {
        
    }
    
    @IBAction func privacyButtonTapped(_ sender: Any) {
        
    }
    
    @objc func firstProductTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view,
              let product = models[selectedView.tag].product else {
            
            return
        }
        
        let model = models[selectedView.tag]
        
        if let productType = Product.allCases.first(where: { $0.rawValue.contains(model.idendifier ?? "") }) {
            changeUI(product: productType)
            self.selectedProduct = product
        }
    }
    
    @objc func secondProductTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view,
              let product = models[selectedView.tag].product else {
            
            return
        }
        
        let model = models[selectedView.tag]
        
        if let productType = Product.allCases.first(where: { $0.rawValue.contains(model.idendifier ?? "") }) {
            changeUI(product: productType)
            self.selectedProduct = product
        }
    }
    
    //MARK: Helper Functions
    func changeUI(product: Product) {
        switch product {
        case .weekly:
            self.firstContentView.setupBorder(
                size: 3,
                color: UIColor(named: "AccentColor"),
                cornerRadius: firstContentView.layer.cornerRadius
            )
            self.secondContentView.removeBorder()
            break
        case .yearly:
            self.secondContentView.setupBorder(
                size: 3,
                color: UIColor(named: "AccentColor"),
                cornerRadius: firstContentView.layer.cornerRadius
            )
            self.firstContentView.removeBorder()
            break
        case .monthly:
            break
        default:
            break
        }
    }
}
