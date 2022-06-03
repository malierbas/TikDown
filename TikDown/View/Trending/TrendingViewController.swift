//
//  TrendingViewController.swift
//  TikDown
//
//  Created by Ali on 18.05.2022.
//

import UIKit
import CCBottomRefreshControl

class TrendingViewController: BaseViewController {
    //MARK: Properties
    //desc: views
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //desc: variables
    var collectionRefreshConrol: UIRefreshControl!
    let trendingViewModel = TrendingViewModel.instance
    var trendingData: [AwemeList] = [] {
        didSet {
            collectionView.reloadData()
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
        AppUtils.showIndicator(on: self)
        collectionView.dataSource = self
        collectionView.delegate = self
        trendingViewModel.getTrendingItems { dataList in
            self.trendingViewModel.getTrendingItems { moreDataList in //get more item 
                self.trendingData = dataList + moreDataList
                AppUtils.hideIndicator(on: self)
                
                let refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                refreshControl.addTarget(self, action: #selector(self.paginateMore), for: .valueChanged)
                self.collectionView.bottomRefreshControl = refreshControl
                self.collectionRefreshConrol = refreshControl
            }
        }
        
        settingsButtonOutlet.increaseArea(size: 10)
    }
    
    //MARK: Actions
    @IBAction func settingsButtonTapped(_ sender: Any) {
        showSettingsViewController()
    }
    
    @objc func paginateMore() {
        AppUtils.showIndicator(on: self)
        trendingViewModel.getTrendingItems { dataList in
            self.trendingData += dataList
            self.collectionRefreshConrol.endRefreshing()
            AppUtils.hideIndicator(on: self)
        }
    }
}

extension TrendingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCVC", for: indexPath) as! TrendingCVC
        let data = trendingData[indexPath.row]
        cell.data = data
        cell.delegate = self
        return cell
    }
}

extension TrendingViewController: TrendingCVCDelegate {
    
    func didCellTapped(on cell: TrendingCVC, model: AwemeList?) {
        guard let newModel = model else {
            
            return
        }
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "VideoDetailViewController") as! VideoDetailViewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.awemeListDetail = newModel
        present(viewController, animated: true, completion: nil)
    }
}
