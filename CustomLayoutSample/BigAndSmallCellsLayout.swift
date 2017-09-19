//
//  BigAndSmallCellsLayout.swift
//  CustomLayoutSample
//
//  Created by ishmeev on 19.09.17.
//  Copyright © 2017 tinkoff. All rights reserved.
//

import UIKit

struct Sides {
    let big: CGFloat
    let small: CGFloat
}

class BigAndSmallCellsLayout: UICollectionViewLayout {
    
    private lazy var sides: Sides = {
        let screenWidth = UIScreen.main.bounds.width
        let coefficient = CGFloat(2) / CGFloat(3)
        let bigSide = screenWidth * coefficient
        let smallSide = screenWidth * (1 - coefficient)
        return Sides(big: bigSide, small: smallSide)
    }()
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        let groups = numberOfItems / 6
        let remaining = numberOfItems % 6
        var height = CGFloat(groups) * self.sides.big * 2
        switch remaining {
        case 1, 2, 3:
            height += self.sides.big
        case 4:
            height += self.sides.big + self.sides.small
        case 5:
            height += 2 * self.sides.big
        default:
            break
        }
        let insets = collectionView.contentInset
        return height - (insets.top + insets.bottom)
    }
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.contentWidth, height: self.contentHeight)
    }
    
    override func prepare() {
        guard self.cache.isEmpty == true, let collectionView = collectionView else {
            return
        }

        for index in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = self.frameByIndex(index)
            self.cache.append(attributes)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in self.cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    // MARK: Private
    
    private func frameByIndex(_ index: Int) -> CGRect {
        let groups = index / 6
        let remaining = index % 6
        let height = CGFloat(groups) * self.sides.big * 2
        
        switch remaining {
        case 0:
            return CGRect(x: 0, y: height, width: self.sides.big, height: self.sides.big)
        case 1:
            return CGRect(x: self.sides.big, y: height, width: self.sides.small, height: self.sides.small)
        case 2:
            return CGRect(x: self.sides.big, y: height + self.sides.small, width: self.sides.small, height: self.sides.small)
        case 3:
            return CGRect(x: 0, y: height + self.sides.big, width: self.sides.small, height: self.sides.small)
        case 4:
            return CGRect(x: 0, y: height + self.sides.big + self.sides.small, width: self.sides.small, height: self.sides.small)
        case 5:
            return CGRect(x: self.sides.small, y: height + self.sides.big, width: self.sides.big, height: self.sides.big)
        default:
            return CGRect.zero
        }
    }
}
