//
//  CollectionViewController.swift
//  CustomLayoutSample
//
//  Created by ishmeev on 19.09.17.
//  Copyright © 2017 tinkoff. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let numberOfElements = 15
    
    //MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfElements
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        cell.backgroundColor = self.randomColor()
        return cell
    }
    
    // MARK: Private 
    
    private func randomColor() -> UIColor {
        let r = self.randomFloat()
        let g = self.randomFloat()
        let b = self.randomFloat()
        let color = UIColor(colorLiteralRed: r, green: g, blue: b, alpha: 1.0)
        return color
    }
    
    private func randomFloat() -> Float {
        let value = Float(arc4random() % 256) / 256
        return value
    }
}

