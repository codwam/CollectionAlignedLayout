//
//  DecorationSectionLayout.swift
//  Pods
//
//  Created by anon on 2017/5/30.
//
//

import UIKit

open class DecorationSectionLayout: UICollectionViewFlowLayout {
    
    public struct Constant {
        public static let commonDecorationViewIndex = -1
    }
    
    fileprivate var commonAttributes: DecorationAttributes?
    fileprivate var sectionToAttributes: [Int: DecorationAttributes]?

    fileprivate var decorationAttributes = [DecorationSectionLayoutAttributes]()
    
    // MARK: - Override
    
    open override func prepare() {
        super.prepare()
        
        configureDecorationAttributes()
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        var tempAttributes = layoutAttributes.map { $0.copy() } as! [UICollectionViewLayoutAttributes]
        for attribute in decorationAttributes {
            if !attribute.frame.intersects(rect) {
                continue
            }
            tempAttributes.append(attribute)
            // Just for CSStickyHeaderFlowLayout
            attribute.transform3D = CATransform3DMakeTranslation(0, 0, -2)
        }
        
        return tempAttributes
    }
    
    open override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        for attribute in self.decorationAttributes {
            if attribute.indexPath == indexPath {
                return attribute
            }
        }
        
        return super.layoutAttributesForDecorationView(ofKind: elementKind, at: indexPath)
    }
    
    // MARK: - Register Methods
    
    open func registerDecorationView(_ viewClass: AnyClass?, inSection section: Int = Constant.commonDecorationViewIndex, updateAttributes: ((DecorationAttributes) -> Void)? = nil) {
        guard let cls = viewClass else { return }
        let className = NSStringFromClass(cls)
        register(cls, forDecorationViewOfKind: className)
        
        registerDecorationView(withViewName: className, inSection: section, updateAttributes: updateAttributes)
    }
    
    open func registerDecorationView(_ nibName: String, inSection section: Int = Constant.commonDecorationViewIndex) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forDecorationViewOfKind: nibName)
        
        registerDecorationView(withViewName: nibName, inSection: section)
    }
    
    fileprivate func registerDecorationView(withViewName viewName: String, inSection section: Int, updateAttributes: ((DecorationAttributes) -> Void)? = nil) {
        let attri = DecorationAttributes(decorationViewOfKind: viewName)
        updateAttributes?(attri)
        
        if section == Constant.commonDecorationViewIndex {
            self.commonAttributes = attri
            return
        }
        
        if self.sectionToAttributes == nil {
            self.sectionToAttributes = [Int: DecorationAttributes]()
        }
        self.sectionToAttributes![section] = attri
    }
    
    // MARK: - Private Methods
    
    fileprivate func configureDecorationAttributes() {
        guard let collectionView = self.collectionView else {
            return
        }
        let numberOfSection = collectionView.numberOfSections
        var decorationAttributes = [DecorationSectionLayoutAttributes]()
        
        for section in 0..<numberOfSection {
            var attriOP = sectionToAttributes?[section]
            if attriOP == nil {
                attriOP = self.commonAttributes
            }
            // no decorationViewOfKind will skip
            guard let attri = attriOP else {
                continue
            }
            
            let sectionFrame = frameOfSectionView(inSection: section)
            if sectionFrame.isEmpty {
                continue
            }
            
            let attributes = DecorationSectionLayoutAttributes(forDecorationViewOfKind: attri.decorationViewOfKind, with: IndexPath(row: 0, section: section))
            attributes.zIndex = -2
            attributes.frame = sectionFrame
            attributes.backgroundColor = attri.backgroundColor
            attributes.cornerRadius = attri.cornerRadius
            decorationAttributes.append(attributes)
        }
        self.decorationAttributes = decorationAttributes
    }
    
    fileprivate func frameOfSectionView(inSection section: Int) -> CGRect {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        let lastIndex = collectionView.numberOfItems(inSection: section) - 1
        if lastIndex < 0 {
            return .zero
        }
        
        guard let firstItem = self.layoutAttributesForItem(at: IndexPath(row: 0, section: section)) else {
            return .zero
        }
        guard let lastItem = self.layoutAttributesForItem(at: IndexPath(row: lastIndex, section: section)) else {
            return .zero
        }
        
        let sectionInset: UIEdgeInsets!
        if let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout, delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))) {
            sectionInset = delegate.collectionView!(collectionView, layout: self, insetForSectionAt: section)
        } else {
            sectionInset = self.sectionInset
        }
        
        var frame = firstItem.frame.union(lastItem.frame)
        frame.origin.x -= sectionInset.left
        frame.origin.y -= sectionInset.top
        
        if (self.scrollDirection == .horizontal) {
            frame.size.width += sectionInset.left + sectionInset.right
            frame.size.height = collectionView.frame.height
        } else {
            frame.size.width = collectionView.frame.width
            frame.size.height += sectionInset.top + sectionInset.bottom
        }
        
        return frame
    }
    
}

// MARK: - support

open class DecorationAttributes {
    open var decorationViewOfKind: String
    
    open var backgroundColor: UIColor?
    
    open var cornerRadius: CGFloat?
    
//    open var decorationSectionInset = UIEdgeInsets.zero
    
    init(decorationViewOfKind: String) {
        self.decorationViewOfKind = decorationViewOfKind
    }
}

open class DecorationSectionLayoutAttributes: UICollectionViewLayoutAttributes {
    open var backgroundColor: UIColor?
    
    open var cornerRadius: CGFloat?
}

@objc(DecorationSectionView)
open class DecorationSectionView: UICollectionReusableView {
    override open func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        if let layoutAttributes = layoutAttributes as? DecorationSectionLayoutAttributes {
            let bgColor = layoutAttributes.backgroundColor
            if self.backgroundColor == nil || bgColor != nil {
                self.backgroundColor = bgColor
                if let cornerRadius = layoutAttributes.cornerRadius, cornerRadius > 0 {
                    self.layer.cornerRadius = cornerRadius
                    self.layer.masksToBounds = true
                } else {
                    self.layer.cornerRadius = 0
                    self.layer.masksToBounds = false
                }
            }
        }
    }
}
