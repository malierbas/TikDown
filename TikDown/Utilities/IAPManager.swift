//
//  IAPManager.swift
//  TikDown
//
//  Created by Ali on 23.05.2022.
//

import Foundation
import StoreKit
import UIKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> Void

extension Notification.Name {
    static let IAPHelperPurchaseNotification = Notification.Name("didPurchasedProduct")
    static let IAPHelperPurchaseFailNotification = Notification.Name("didFailPurchase")
    static let DownloadEndSuccess = Notification.Name("didDownloadEnd")
}
 
class InAppPurchaseManager: NSObject  {

    static let credit50 = "Claim_Credit_50"
    static let credit100 = "Claim_Credit_100"
    static let credit300 = "Claim_Credit_300"
    static let credit500 = "Claim_Credit_500"
    static let credit1000 = "Claim_Credit_1000"
    static let credit3000 = "Claim_Credit_3000"

    private let productIdentifiers: Set<ProductIdentifier> = [credit50, credit100, credit300, credit500, credit1000, credit3000]

    private var purchasedProductIdentifiers: Set<ProductIdentifier> = []
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletionHandler: ProductsRequestCompletionHandler?

    static let shared: InAppPurchaseManager = InAppPurchaseManager()

    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension InAppPurchaseManager {

    public func requestProducts(_ completionHandler: @escaping ProductsRequestCompletionHandler) {
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler

        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }

    public func buyProduct(_ product: SKProduct) {
        guard InAppPurchaseManager.canMakePayments() else {

            return
        }
        
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func isProductPurchased(_ productIdentifier: ProductIdentifier) -> Bool {
        return purchasedProductIdentifiers.contains(productIdentifier)
    }
    
    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    public func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

// MARK: - SKProductsRequestDelegate

extension InAppPurchaseManager: SKProductsRequestDelegate {

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("Loaded list of products...")
        let products = response.products.sorted { $0.price.floatValue < $1.price.floatValue }
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
    }

    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load list of products.")
        print("Error: \(error.localizedDescription)")
        productsRequestCompletionHandler?(false, nil)
        clearRequestAndHandler()
    }

    private func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

// MARK: - SKPaymentTransactionObserver

extension InAppPurchaseManager: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        print("Transaction completed successfully!")
        deliverPurchaseNotificationFor(identifier: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
        //desc: save to BE
    }

    private func restore(transaction: SKPaymentTransaction) {
        guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }

        print("restore... \(productIdentifier)")
        deliverPurchaseNotificationFor(identifier: productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func fail(transaction: SKPaymentTransaction) {
        print("fail...")
        NotificationCenter.default.post(name: .IAPHelperPurchaseFailNotification, object: nil)
//        SVProgressHUD.dismiss()
        if let transactionError = transaction.error as NSError?,
            let localizedDescription = transaction.error?.localizedDescription,
            transactionError.code != SKError.paymentCancelled.rawValue {
            print("Transaction Error: \(localizedDescription)")
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func deliverPurchaseNotificationFor(identifier: String?) {
        guard let identifier = identifier else { return }

        purchasedProductIdentifiers.insert(identifier)
        UserDefaults.standard.set(true, forKey: identifier)
        NotificationCenter.default.post(name: .IAPHelperPurchaseNotification, object: identifier)
    }
}

