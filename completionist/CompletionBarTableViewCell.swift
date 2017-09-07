//
//  CompletionBarTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/24/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit

class CompletionBarTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityCompletionView: ActivityCompletionBarView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        progressView.setProgress(0.0, animated: false)
//        progressView.progressTintColor = UIColor(red: 0.041, green: 0.920, blue: 0.000, alpha: 1.00)
        
        // Set up completion bar view
        activityCompletionView.setupView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadCell(_ progress: Float) {
//        progressView.setProgress(progress, animated: true)
        
        activityCompletionView.setProgress(progress, animated: true)
    }
    
}
