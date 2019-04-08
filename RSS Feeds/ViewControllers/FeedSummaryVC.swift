//
//  FeedSummaryVC.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit

class FeedSummaryVC: UIViewController {
    // All static categary
    enum summaryTitles : String{
        case opinion = "Opinion"
        case worldNews = "World News"
        case usBusiness = "U.S. Business"
        case marketNews = "Market News"
        case technology = "Technology: What's News"
        case lifeStyle = "Lifestyle"
    }
    // All static Urls
    enum summaryUrls : String{
        case opinion = "https://feeds.a.dj.com/rss/RSSOpinion.xml"
        case worldNews = "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
        case usBusiness = "https://feeds.a.dj.com/rss/WSJcomUSBusiness.xml"
        case marketNews = "https://feeds.a.dj.com/rss/RSSMarketsMain.xml"
        case technology = "https://feeds.a.dj.com/rss/RSSWSJD.xml"
        case lifeStyle = "https://feeds.a.dj.com/rss/RSSLifestyle.xml"
    }
    @IBOutlet weak var tblSummary: UITableView!
    var categoryCell = "CategorCell"
    var summaryModelArray : [SummaryModel]?

    //MARK: - View Controller LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewProperties()
        setUpSummaryArray()
    }
    
    //MARK: - Custom Functions

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
        tblSummary.accessibilityIdentifier = accessibilityIdentifier.tblSummary.rawValue
        tblSummary.register(UITableViewCell.self, forCellReuseIdentifier: categoryCell)
        tblSummary.delegate = self
        tblSummary.dataSource = self
        tblSummary.tableFooterView = UIView()
    }
    /**
     Function that set up *summaryModelArray* of type **SummaryModel**.
     ## Properties
     
     - Accessibility
     - Register tableViewCell
     - delegate
     - dataSource
     - footerView set Up
     */
    func setUpSummaryArray(){
        summaryModelArray = [SummaryModel(title: summaryTitles.opinion.rawValue, urlString: summaryUrls.opinion.rawValue),SummaryModel(title: summaryTitles.worldNews.rawValue, urlString: summaryUrls.worldNews.rawValue),SummaryModel(title: summaryTitles.usBusiness.rawValue, urlString: summaryUrls.usBusiness.rawValue),SummaryModel(title: summaryTitles.marketNews.rawValue, urlString: summaryUrls.marketNews.rawValue),SummaryModel(title: summaryTitles.technology.rawValue, urlString: summaryUrls.technology.rawValue),SummaryModel(title: summaryTitles.lifeStyle.rawValue, urlString: summaryUrls.lifeStyle.rawValue)]
    }
}

//MARK:- UITableView Delegate and DataSource
extension FeedSummaryVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryModelArray?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblSummary.dequeueReusableCell(withIdentifier: categoryCell)
        cell?.textLabel?.text = summaryModelArray?[indexPath.row].title
        cell?.textLabel?.regularSizeFont()
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = UIColor.darkGray
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let destVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedListVC") as? FeedListVC{
            destVC.summary = summaryModelArray?[indexPath.row]
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
}
