//
//  DetailViewController.swift
//  Flicks
//
//  Created by Phương Nguyễn on 10/12/16.
//  Copyright © 2016 Phương Nguyễn. All rights reserved.
//

import UIKit
import AFNetworking

class DetailViewController: UIViewController{

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var overview: String!
    var titleMovie: String!
    var posterMovieUrl: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        let contentWidth = scrollView.frame.size.width
        let contentHeight = infoView.frame.origin.y + infoView.frame.size.height
        scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        titleLabel.text = titleMovie
        //titleLabel.sizeToFit()
        if posterMovieUrl != "" {
            posterImageView.alpha = 0.0
            posterImageView.setImageWith(URL(string: posterMovieUrl)!)
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.posterImageView.alpha = 1.0
            })
        } else {
            posterImageView.image = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
