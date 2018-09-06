//
//  PhotoViewController.swift
//  Tumblr
//
//  Created by Kymberlee Hill on 8/31/18.
//  Copyright © 2018 Kymberlee Hill. All rights reserved.
//

import UIKit
import AlamofireImage
import PKHUD

class PhotoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var PhotoTableView: UITableView!
    
    var posts: [[String: Any]] = []
    var refreshControl: UIRefreshControl! = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.tintColor = .clear   // Remove UIRefreshControl default spinner
        refreshControl.addTarget(self, action: #selector(PhotoViewController.didPullToRefresh(_:)), for: .valueChanged)
        PhotoTableView.insertSubview(refreshControl, at: 0)
        
        PhotoTableView.dataSource = self
        PhotoTableView.delegate = self
        
        fetchPost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView()
        PKHUD.sharedHUD.show()
        fetchPost()
        PKHUD.sharedHUD.hide(afterDelay: 1.0)
    }
    
    func fetchPost() {
        // Network request snippet
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        session.configuration.requestCachePolicy = .returnCacheDataElseLoad
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: "Network Error, Please Refresh Again", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Get the dictionary from the response key
                    let responseDictionary = dataDictionary["response"] as! [String: Any]
                    // Store the returned array of dictionaries in our posts property
                    self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                    self.PhotoTableView.reloadData()
                    self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell", for: indexPath) as! PhotoCell
        let post = self.posts[indexPath.section]
        
        if let photos = post["photos"] as? [[String: Any]] {
            
            let placeholderImage = UIImage(named: "placeholder")!
            let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                size: cell.photoImageView.frame.size,
                radius: 20.0
            )
            
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            let altSizes = photo["alt_sizes"] as! [[String: Any]]
            let smallSize = altSizes[7]      // Samllest size photo
            let originalurlString = originalSize["url"] as! String
            let smallurlString = smallSize["url"] as! String
            let originalurl = URL(string: originalurlString)!
            let smallPostRequest = URLRequest(url: URL(string: smallurlString)!)
            
            cell.photoImageView.af_setImage(
                withURLRequest: smallPostRequest,
                placeholderImage: placeholderImage,
                filter: filter,
                imageTransition: .crossDissolve(0.2),
                runImageTransitionIfCached: false,
                completion: { response in
                    cell.photoImageView.af_setImage(withURL: originalurl)
                }
            )
        }
        else {
            cell.photoImageView = nil
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    // Header Setting
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        
        // Set the avatar
        profileView.af_setImage(withURL: URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/avatar")!)
        headerView.addSubview(profileView)
        
        // Add a UILabel for the date here
        let post = self.posts[section]
        let dateString = post["date"] as! String
        let dateLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 230, height: 50))
        dateLabel.text = dateString
        headerView.addSubview(dateLabel)
        
        return headerView
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let vc = segue.destination as! PhotoDetailsViewController
        let indexPath = PhotoTableView.indexPath(for: cell)!
        let post = self.posts[indexPath.row]
        if let photos = post["photos"] as? [[String: Any]] {
            let photo = photos[0]
            let originalSize = photo["original_size"] as! [String: Any]
            vc.photoURL = URL(string: originalSize["url"] as! String)
        }
    }
    
}
