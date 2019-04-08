//
//  FeedCell.swift
//  RSS Feeds
//
//  Copyright © 2019 Keval Patel. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPubDate: UILabel!
    var feedViewModel : FeedViewModel!{
        didSet{
            lblTitle.text = feedViewModel.title
            lblPubDate.text = feedViewModel.getformattedDate(feedViewModel.pubDate)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lblPubDate.dateSizeFont()
        lblTitle.titleSizeFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
