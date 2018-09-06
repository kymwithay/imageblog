//
//  PhotoDetailsViewController.swift
//  Tumblr
//
//  Created by Kymberlee Hill on 9/4/18.
//  Copyright © 2018 Kymberlee Hill. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var photoURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.af_setImage(withURL: photoURL)
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        scrollView.delegate = self
    }
    
    @IBAction func downloadPhoto(_ sender: Any) {
        if self.presentedViewController == nil {
            let alertController = UIAlertController(title: "Downloader", message: "Do you want to download the photo?", preferredStyle: .actionSheet)
            
            let logoutAction = UIAlertAction(title: "Download", style: .destructive) { (action) in
                UIImageWriteToSavedPhotosAlbum(
                    self.photoImageView.image!, nil, nil, nil)
            }
            alertController.addAction(logoutAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photoImageView
    }
    
    @IBAction func dismissView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
