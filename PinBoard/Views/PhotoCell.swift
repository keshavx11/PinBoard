//
//  PhotoCell.swift
//  PinBoard
//
//  Created by Keshav Bansal on 13/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit
import KBCachier

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var loadingBgView: UIView!
    @IBOutlet var imageLoadingView: CPLoadingView!
    @IBOutlet weak var cancelDownloadButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!

    var downloadTask: CachierTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addThinShadow()
    }
    
    var pin: Pin? {
        didSet {
            self.configureView()
        }
    }
    
    func configureView() {
        self.hideLoaderView()
        if let pin = self.pin {
            self.imageView.image = nil
            if let bgColor = pin.color {
                self.imageView.backgroundColor = UIColor.getColor(fromHexString: bgColor)
            } else {
                self.imageView.backgroundColor = UIColor.red
            }
            if let url = pin.urls?.regular {
                self.startImageDownload(fromURL: url)
            }
            self.captionLabel.text = pin.user?.name ?? "Anonymous"
            self.commentLabel.text = "\(pin.likes) Likes"
        }
    }
    
    func hideLoaderView() {
        self.loadingBgView.isHidden = true
        self.imageLoadingView.completeLoading(success: true)
    }
    
    func setImageDownloadFailed() {
        self.loadingBgView.isHidden = false
        self.imageLoadingView.isHidden = true
        self.cancelDownloadButton.isHidden = true
        self.downloadButton.isHidden = false
        self.imageLoadingView.completeLoading(success: false)
    }
    
    func startImageDownload(fromURL url: String) {
        self.loadingBgView.isHidden = false
        self.imageLoadingView.isHidden = false
        self.cancelDownloadButton.isHidden = false
        self.downloadButton.isHidden = true
        self.imageLoadingView.startLoading()
        self.downloadTask = self.imageView.setImage(withUrl: url, placeholder: nil, completion: { (success) in
            if success {
                self.hideLoaderView()
            } else {
                self.setImageDownloadFailed()
            }
        })
    }
    
    @IBAction func cancelDownloadRequest() {
        if let task = self.downloadTask {
            task.cancel()
        }
    }
    
    @IBAction func retryDownload() {
        if let pin = self.pin, let url = pin.urls?.regular {
            self.startImageDownload(fromURL: url)
        }
    }
}
