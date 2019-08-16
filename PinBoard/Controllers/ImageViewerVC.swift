//
//  ImageViewerVC.swift
//  PinBoard
//
//  Created by Keshav Bansal on 16/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit
import Hero

class ImageViewerVC: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    var panGR = UIPanGestureRecognizer()

    var selectedIndex: IndexPath!
    var pins: [Pin]!
    
    private let reuseIdentifier = "PhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        self.view.layoutIfNeeded()
        self.backButton.addShadow()
        self.collectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: false)
        
        self.panGR.addTarget(self, action: #selector(pan))
        self.panGR.delegate = self
        self.collectionView.addGestureRecognizer(self.panGR)
    }
    
    @objc func pan() {
        let translation = self.panGR.translation(in: nil)
        let progress = translation.y / 2 / self.collectionView.bounds.height
        switch self.panGR.state {
        case .began:
            hero.dismissViewController()
        case .changed:
            Hero.shared.update(progress)
            if let cell = collectionView?.visibleCells[0] as? PhotoCell {
                let currentPos = CGPoint(x: translation.x + view.center.x, y: translation.y + view.center.y)
                Hero.shared.apply(modifiers: [.position(currentPos)], to: cell.imageView)
            }
        default:
            if progress + self.panGR.velocity(in: nil).y / self.collectionView.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
}

extension ImageViewerVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        if self.pins.count > indexPath.row {
            photoCell.pin = self.pins[indexPath.row]
            photoCell.hero.id = "cell\(indexPath.row)"
        }
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.frame.size
    }
    
}

extension ImageViewerVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let v = self.panGR.velocity(in: nil)
        return v.y > abs(v.x)
    }
    
}
