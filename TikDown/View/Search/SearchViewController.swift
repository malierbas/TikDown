//
//  SearchViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import Foundation
import UIKit

class SearchViewController: BaseViewController {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var setttingsButtonOutlet: UIButton!
    @IBOutlet weak var fieldBackgroundView: UIView!
    @IBOutlet weak var hashtagField: UITextField!
    
    @IBOutlet weak var hashtagTableView: UITableView!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    //desc: variables
    let searchViewModel = SearchViewModel.instance
    var searchResults: [AwemeList] = [] {
        didSet {
            resultCollectionView.reloadData()
        }
    }
    var hashtags: [Hashtag] = []
    var isEditingView = false {
        didSet {
            hideTableViewAndShowResultView()
        }
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //desc: setup ui
        setupUI()
    }
    
    //MARK: Functions
    func setupUI() {
        resultCollectionView.fadeOut()
        
        hashtags = searchViewModel.getHashtags()
        hashtagTableView.dataSource = self
        hashtagTableView.reloadData()
        
        resultCollectionView.dataSource = self
        
        fieldBackgroundView.setupBorder(
            size: 1,
            color: UIColor(named: "unUseed"),
            cornerRadius: 8
        )
        
        hashtagField.returnKeyType = .search
        hashtagField.delegate = self
        hashtagField.placeHolderColor()
        hashtagField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        setttingsButtonOutlet.increaseArea(size: 10)
    }
    
    //MARK: Actions
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text?.lowercased() else {
            return
        }
        
        
        //let datas = searchViewModel.getTrendingItems().filter({ $0.name.lowercased().contains(text) })
        //searchResults = datas
    }
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        showSettingsViewController()
    }
    
    
    //MARK: Helper Functions
    func hideTableViewAndShowResultView() {
        if (isEditingView) {
            hashtagTableView.fadeOut() {
                //desc: show result collection view
                
                self.resultCollectionView.fadeIn()
            }
        } else {
            resultCollectionView.fadeOut() {
                //desc: show hashtag table view
                
                self.hashtagTableView.fadeIn()
                self.hashtagField.resignFirstResponder()
            }
        }
    }
    
    func searchHashtag(text: String) {
        AppUtils.showIndicator(on: self)
        let networking = NetworkManager.shared
        let endpoint = Endpoints.searchHashtag(hashtag: text)
        networking.request(endpoint) { (result: Result<SearchResultBase>) in
            switch result {
            case .success(let awemeList):
                AppUtils.hideIndicator(on: self)
                print("aweme list detail = ", awemeList.aweme_list)
                guard let list = awemeList.aweme_list else {
                    
                    return
                }
                if !list.isEmpty {
                    self.searchResults = list
                    self.isEditingView = true
                } else {
                    self.isEditingView = false
                }
                
            case .error(let error):
                print("an error occured = ", error.localizedDescription)
                AppUtils.hideIndicator(on: self)
                self.isEditingView = false
            }
        }
    }
}

//MARK: Tableview Extension
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hashtags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTVC", for: indexPath) as! SearchTVC
        let hashtagData = hashtags[indexPath.row]
        cell.data = hashtagData
        cell.delegate = self
        return cell
    }
}

extension SearchViewController: SearchTVCDelegate {
    func didCellTapped(on cell: SearchTVC, withHashtag: Hashtag?) {
        guard let hashtagCharp = withHashtag else {
            return
        }

        let hashtag = hashtagCharp.replacingOccurrences(of: "#", with: "")
        print("selected hashtag = ", hashtag)
        searchHashtag(text: hashtag)
    }
}

//MARK: CollectionView Extension
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchResultCVC", for: indexPath) as! SearchResultCVC
        let dataModel = searchResults[indexPath.row]
        cell.data = dataModel
        cell.delegate = self
        return cell
    }
}

extension SearchViewController: SearchResultCVCDelegate {
    func didCellTapped(on cell: SearchResultCVC, model: AwemeList?) {
        guard let model = model else {
            return
        }

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.awemeListDetail = model
        present(viewController, animated: true, completion: nil)
    }
}


//MARK: TextField Extension
extension SearchViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingView = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isEditingView = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let hashtag = textField.text,
              !hashtag.isEmpty else {
                  
            isEditingView = false
            return false
        }
        searchHashtag(text: hashtag)
        return true
    }
}
