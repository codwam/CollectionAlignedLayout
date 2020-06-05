//
//  DecorationSectionLayout.swift
//  Pods
//
//  Created by 李辉 on 2017/5/30.
//
//

import UIKit

open class DecorationSectionLayout: UICollectionViewFlowLayout {
    
    /// hold the section full width.
    open var ignoreSectionInsetLeftRight = true
    open var decorationSectionInset = UIEdgeInsets.zero
    open var cornerRadius: CGFloat?
    
    public struct Constant {
        public static let allDecorationViewIndex = -1
    }
    
    fileprivate var decorationAttributes = [DecorationSectionLayoutAttributes]()
    
    fileprivate var allDecorationViewKind: String?
    fileprivate var decorationViewKinds: [Int: String]?
    
    fileprivate var allDecorationViewColor: UIColor?
    fileprivate var decorationViewColors: [Int: UIColor]?
    
    // MARK: - Override
    
    open override func prepare() {
        super.prepare()
        
        if let decorationViewKinds = self.decorationViewKinds, decorationViewKinds.count > 0 {
            configureDecorationAttributes()
        }
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        guard let decorationViewKinds = self.decorationViewKinds else {
            return layoutAttributes
        }
        if decorationViewKinds.count == 0 {
            return layoutAttributes
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
    
    // Add default white Color for all section

    open func registerDefaultDecorationView() {
        addDecorationView(withBackgroundColor: UIColor.white)
    }
    
    // Add by custom class
    
    open func registerDecorationView(withClassName className: String, inSection section: Int = Constant.allDecorationViewIndex) {
        let viewClass: AnyClass? = NSClassFromString(className)
        register(viewClass, forDecorationViewOfKind: className)
        
        addDecorationView(withViewName: className, inSection: section)
    }
    
    open func registerDecorationView(withNibName nibName: String, inSection section: Int = Constant.allDecorationViewIndex) {
        let nib = UINib(nibName: nibName, bundle: nil)
        register(nib, forDecorationViewOfKind: nibName)
        
        addDecorationView(withViewName: nibName, inSection: section)
    }
    
    fileprivate func addDecorationView(withViewName viewName: String, inSection section: Int) {
        if section == Constant.allDecorationViewIndex {
            self.allDecorationViewKind = viewName
        }
        
        if self.decorationViewKinds == nil {
            self.decorationViewKinds = [Int: String]()
        }
        self.decorationViewKinds![section] = viewName
    }
    
    // Add by custom color

    open func addDecorationView(withBackgroundColor bgColor: UIColor, inSection section: Int = Constant.allDecorationViewIndex) {
        let className = "DecorationSectionView"
        self.registerDecorationView(withClassName: className, inSection: section)
        
        if section == Constant.allDecorationViewIndex {
            self.allDecorationViewColor = bgColor
        }
        
        if self.decorationViewColors == nil {
            self.decorationViewColors = [Int: UIColor]()
        }
        self.decorationViewColors![section] = bgColor
    }
    
    // MARK: - Private Methods
    
    fileprivate func configureDecorationAttributes() {
        guard let collectionView = self.collectionView else {
            return
        }
        let numberOfSection = collectionView.numberOfSections
        var decorationAttributes = [DecorationSectionLayoutAttributes]()
        
        for section in 0..<numberOfSection {
            var decorationViewOfKind = decorationViewKinds?[section]
            if decorationViewOfKind == nil {
                decorationViewOfKind = self.allDecorationViewKind
            }
            // no decorationViewOfKind will skip
            if decorationViewOfKind == nil {
                continue
            }
            
            let sectionFrame = self.frameOfSectionView(inSection: section)
            if sectionFrame.isEmpty {
                continue
            }
            
            let attributes = DecorationSectionLayoutAttributes(forDecorationViewOfKind: decorationViewOfKind!, with: IndexPath(row: 0, section: section))
            attributes.zIndex = -1
            attributes.frame = sectionFrame
            let bgColor = self.decorationViewColors?[section]
            if let bgColor = bgColor {
                attributes.backgroundColor = bgColor
            } else if let allDecorationViewColor = self.allDecorationViewColor {
                attributes.backgroundColor = allDecorationViewColor
            }
            attributes.cornerRadius = self.cornerRadius
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
        if self.ignoreSectionInsetLeftRight {
            frame.origin.x = 0
        } else {
            frame.origin.x -= sectionInset.left
        }
        frame.origin.y -= sectionInset.top
        
        if (self.scrollDirection == .horizontal) {
            frame.size.width += sectionInset.left + sectionInset.right
            frame.size.height = collectionView.frame.height
        } else {
            frame.size.width = collectionView.frame.width
            frame.size.height += sectionInset.top + sectionInset.bottom
        }
        
        frame = frame.inset(by: self.decorationSectionInset)
        
        return frame
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
