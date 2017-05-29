//
//  CollectionAlignedLayout.swift
//  Pods
//
//  Created by 李辉 on 2017/5/28.
//
//

import UIKit

public enum HorizontalAlignment {
    case justified
    case left
    case center
    case right
}

public enum VerticalAlignment {
    case justified
    case top
    case center
    case bottom
}

open class CollectionAlignedLayout: UICollectionViewFlowLayout {
    
    // MARK: - Properties
    
    open var horizontalAlignment: HorizontalAlignment = .justified

    open var verticalAlignment: VerticalAlignment = .justified
    
    open var isEnabledDebugLog: Bool = false

    // MARK: - Init
    
    convenience init(horizontalAlignment: HorizontalAlignment = .justified, verticalAlignment: VerticalAlignment = .justified) {
        self.init()
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }
    
    // MARK: - Override
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        switch self.horizontalAlignment {
        case .left, .right:
            return horizontalAlignLeft(with: layoutAttributes, in: rect)
        default:
            break
        }
        
        return layoutAttributes
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        switch self.horizontalAlignment {
        case .left:
            return horizontalAlignLeft(with: layoutAttributes, at: indexPath)
        case .right:
            return horizontalAlignRight(with: layoutAttributes, at: indexPath)
        default:
            break
        }

        return layoutAttributes
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    fileprivate func log(_ items: Any...) {
        guard isEnabledDebugLog else {
            return
        }
        print(items)
    }

}

// MARK: - Alignment Rect

fileprivate extension CollectionAlignedLayout {
    
    func horizontalAlignLeft(with layoutAttributes: [UICollectionViewLayoutAttributes], in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var updateAttributes = layoutAttributes.map { $0.copy() } as! [UICollectionViewLayoutAttributes]
        for (index, attributes) in layoutAttributes.enumerated() {
            if attributes.representedElementKind == nil {
                if let itemAttributes = self.layoutAttributesForItem(at: attributes.indexPath) {
                    updateAttributes[index] = itemAttributes
                }
            }
        }
        return updateAttributes
    }
    
}

// MARK: - Alignment IndexPath

fileprivate extension CollectionAlignedLayout {
    
    func horizontalAlignLeft(with itemAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let sectionInset = evaluateSectionInsetForItem(at: indexPath.section)
        
        let isFirstItemInSection = indexPath.item == 0
        if isFirstItemInSection {
            itemAttributes.leftAlignFrame(with: sectionInset)
            log("\(#function) isFirstItemInSection indexPath: \(indexPath), currentFrame: \(itemAttributes.frame)")
            return itemAttributes
        }
        
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        guard let previousFrame = self.layoutAttributesForItem(at: previousIndexPath)?.frame else {
            return itemAttributes
        }
        let contentWidth = collectionView!.frame.width - sectionInset.left - sectionInset.right
        var currentFrame = itemAttributes.frame
        let strecthedCurrentFrame = CGRect(x: sectionInset.left, y: currentFrame.minY, width: contentWidth, height: currentFrame.height)
        
        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow {
            itemAttributes.leftAlignFrame(with: sectionInset)
            log("\(#function) isFirstItemInRow indexPath: \(indexPath), currentFrame: \(currentFrame)")
            return itemAttributes
        }
        
        currentFrame.origin.x = previousFrame.maxX + evaluateMinimumInteritemSpacingForSection(at: indexPath.section)
        itemAttributes.frame = currentFrame
        log("\(#function) indexPath: \(indexPath), currentFrame: \(currentFrame)")
        
        return itemAttributes
    }
    
    func horizontalAlignRight(with itemAttributes: UICollectionViewLayoutAttributes, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let sectionInset = evaluateSectionInsetForItem(at: indexPath.section)
        
        let contentWidth = collectionView!.frame.width
        let isFirstItemInSection = indexPath.item == 0
        if isFirstItemInSection {
            itemAttributes.rightAlignFrame(with: contentWidth, sectionInset: sectionInset)
            log("\(#function) isFirstItemInSection indexPath: \(indexPath), currentFrame: \(itemAttributes.frame)")
            return itemAttributes
        }
        
        let previousIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        guard let previousFrame = self.layoutAttributesForItem(at: previousIndexPath)?.frame else {
            return itemAttributes
        }
        var currentFrame = itemAttributes.frame
        let strecthedCurrentFrame = CGRect(x: 0, y: currentFrame.minY, width: contentWidth, height: currentFrame.height)
        
        let isFirstItemInRow = !previousFrame.intersects(strecthedCurrentFrame)
        if isFirstItemInRow {
            itemAttributes.rightAlignFrame(with: contentWidth, sectionInset: sectionInset)
            log("\(#function) isFirstItemInRow indexPath: \(indexPath), currentFrame: \(currentFrame)")
            return itemAttributes
        }
        
        currentFrame.origin.x = previousFrame.minX - evaluateMinimumInteritemSpacingForSection(at: indexPath.section) - currentFrame.width
        itemAttributes.frame = currentFrame
        log("\(#function) indexPath: \(indexPath), currentFrame: \(currentFrame)")
        
        return itemAttributes
    }
    
}

// MARK: - Evaluate

fileprivate extension CollectionAlignedLayout {
    
    func evaluateMinimumLineSpacingForSection(at index: Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let minimumLineSpacing = delegate.collectionView?(self.collectionView!, layout: self.collectionView!.collectionViewLayout, minimumLineSpacingForSectionAt: index) {
            return minimumLineSpacing
        }
        return self.minimumLineSpacing
    }
    
    func evaluateMinimumInteritemSpacingForSection(at index: Int) -> CGFloat {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let minimumInteritemSpacing = delegate.collectionView?(self.collectionView!, layout: self.collectionView!.collectionViewLayout, minimumInteritemSpacingForSectionAt: index) {
            return minimumInteritemSpacing
        }
        return self.minimumInteritemSpacing
    }
    
    func evaluateSectionInsetForItem(at index: Int) -> UIEdgeInsets {
        if let delegate = self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout, let sectionInset = delegate.collectionView?(self.collectionView!, layout: self.collectionView!.collectionViewLayout, insetForSectionAt: index) {
            return sectionInset
        }
        return self.sectionInset
    }
    
}

// MARK: - UICollectionViewLayoutAttributes

fileprivate extension UICollectionViewLayoutAttributes {
    
    func leftAlignFrame(with sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
    
    func rightAlignFrame(with width: CGFloat, sectionInset: UIEdgeInsets) {
        var frame = self.frame
        frame.origin.x = width - frame.size.width - sectionInset.right
        self.frame = frame
    }
    
}
