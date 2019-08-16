//
//  PinBoardVC.swift
//  PinBoard
//
//  Created by Keshav Bansal on 13/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit
import KBCachier
import Hero

class PinBoardVC: UICollectionViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshControl = UIRefreshControl()

    var pins = [Pin]()
    
    private let reuseIdentifier = "PhotoCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.getPins()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureCollectionView() {
        self.collectionView?.contentInset = UIEdgeInsets(top: 24, left: 10, bottom: 10, right: 10)
        
        // Set the PinBoardLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinBoardLayout {
            layout.delegate = self
        }
        
        // Pull to refresh
        self.collectionView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.reloadPins), for: .valueChanged)
    }
    
    func getPins() {
        Cachier.shared.fetchJSONData(forUrl: "https://pastebin.com/raw/wgkJgazE", completion: {[weak self] (response: [Pin]) in
            if self?.refreshControl.isRefreshing ?? false {
                self?.pins = response
                self?.refreshControl.endRefreshing()
            } else {
                self?.pins.append(contentsOf: response)
            }
            self?.pins = response
            self?.collectionView.reloadData()
            self?.activityIndicator.stopAnimating()
        }, error: { errorString in
            
        })
    }
    
    @objc func reloadPins() {
        self.getPins()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pins.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        if self.pins.count > indexPath.row {
            photoCell.pin = self.pins[indexPath.row]
            photoCell.hero.id = "cell\(indexPath.row)"
        }
        return photoCell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentCell = sender as? PhotoCell,
            let vc = segue.destination as? ImageViewerVC,
            let currentCellIndex = collectionView.indexPath(for: currentCell) {
            vc.selectedIndex = currentCellIndex
            vc.pins = self.pins
        }
    }

}

extension PinBoardVC: PinBoardLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGSize {
        if self.pins.count > indexPath.row {
            return self.pins[indexPath.item].getImageSize()
        }
        return CGSize.zero
    }
    
}
