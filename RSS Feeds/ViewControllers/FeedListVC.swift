//
//  FeedListVC.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit

class FeedListVC: UIViewController {
    enum titleString: String{
        case wsj = "WSJ"
        case leftImageTitle = "LeftArrow"
        case error = "Error"
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tblFeeds: UITableView!
    var feedViewModel = [FeedViewModel]()
    var summary : SummaryModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProperties()
        setUpNavigationBar()
        activityProperties()
        guard checkForInternetConnection() else{return}
        initialSetUp()
        fetchData()
    }
    
    //MARK: - Custom Functions

    /**
     Calls *startAndShowActivity()* and Hide  tableView *tblFeeds*
     */
    func initialSetUp(){
        startAndShowActivity()
        tblFeeds.isHidden = true
    }
    
    /**
     Calls *isConnectedToNetwork()* of class **InternetConnectivity**, to check internet Connection
     
     - Returns: Bool, which indicate internet connectivity
     */
    func checkForInternetConnection() -> Bool{
        guard InternetConnectivity.isConnectedToNetwork() else {
            let alert = createAlert(globalConstants.noInternetConnection.rawValue, globalConstants.turnOnInternetconnectivity.rawValue)
            present(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
    /**
     Function that set up navigationBar properties.
     ## Properties
     
     - navigationItem title
     - hides custom backBarButton
     - create custom back button and assign as leftBarButtonItem, action: *selbtnBack(_:)*
     - create custome rightBarButtonItem and assign as rightBarButtonItem, action: *selbtnRefresh(_:)*
     - create and assign attributed string for leftBarButtonItem
     */
    func setUpNavigationBar(){
        self.navigationItem.title = summary?.title
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(image: UIImage(named: titleString.leftImageTitle.rawValue), landscapeImagePhone: UIImage(named: titleString.leftImageTitle.rawValue), style: .plain, target: self, action: #selector(selbtnBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(selbtnRefresh(_:)))
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: fonts.timesNewRoman.rawValue, size: 17)!], for: .normal)
    }
    
    /**
     Function that set up tableView Properties.
     ## Properties
     
     - Accessibility
     - Register tableViewCell
     - delegate
     - dataSource
     - footerView set Up
     */
    func tableViewProperties(){
        tblFeeds.delegate = self
        tblFeeds.dataSource = self
        tblFeeds.tableFooterView = UIView()
        tblFeeds.accessibilityIdentifier = accessibilityIdentifier.tblFeedList.rawValue
    }
    /**
     Set up accessibility property for activity indicator.
     */
    func activityProperties(){
        activityIndicator.accessibilityIdentifier = accessibilityIdentifier.activityIndicator.rawValue
    }
    /**
     Function that make an api call and handle response, by calling *parseFeeds()* of class **Parser**.
     Also uses method *stopAndHideActivity()* and reload tableview *tblFeeds*
     */
    func fetchData(){
        let feedParser = Parser()
        guard summary?.urlString != nil else {return}
        feedParser.parseFeeds(summary!.urlString) { (feeds,error) in
            //Error Occured
            guard error == nil else{
                let alert = createErrorAlert(titleString.error.rawValue,error?.localizedDescription ?? globalConstants.somethingWentWrong.rawValue)
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.feedViewModel = feeds.map({return FeedViewModel($0)})
            OperationQueue.main.addOperation {
                guard self.feedViewModel.count >= 0 else{
                    self.tblFeeds.isHidden = true
                    self.stopAndHideActivity()
                    return
                }
                self.stopAndHideActivity()
                self.tblFeeds.isHidden = false
                self.tblFeeds.reloadData()
            }
        }
    }
    /**
     Start animate and show activity *activityIndicator*
     */
    func startAndShowActivity(){
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    /**
     Stop animate and hide activity *activityIndicator*
     */
    func stopAndHideActivity(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    //MARK: - Button Actions
    @IBAction func selbtnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func selbtnRefresh(_ sender: Any) {
        guard checkForInternetConnection() else{return}
        initialSetUp()
        fetchData()
    }

}

//MARK:- UITableView Delegate and DataSource
extension FeedListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblFeeds.dequeueReusableCell(withIdentifier:"FeedCell") as? FeedCell
        cell?.feedViewModel = feedViewModel[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard checkForInternetConnection() else{return}
        if let destVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebViewVC{
            destVC.link = feedViewModel[indexPath.row].link
            self.navigationController?.present(destVC, animated: true, completion: nil)
        }
    }
}
