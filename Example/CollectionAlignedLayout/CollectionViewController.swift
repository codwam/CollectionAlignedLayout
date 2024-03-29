//
//  CollectionViewController.swift
//  CollectionAlignedLayout
//
//  Created by 李辉 on 2017/5/28.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import CollectionAlignedLayout

private let reuseIdentifier = "CollectionViewCell"

class CollectionViewController: UICollectionViewController {
    
    fileprivate let data = CollectionDataManager.shared.dataSource

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white

        let layout = self.collectionViewLayout as? CollectionAlignedLayout
        layout?.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout?.minimumLineSpacing = 15
        layout?.minimumInteritemSpacing = 10
        layout?.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        let contentWidth = self.view.frame.width - 40
        layout?.estimatedItemSize = CGSize(width: contentWidth, height: 40)
//        layout?.scrollDirection = .horizontal
//        layout?.isEnabledDebugLog = true
        layout?.horizontalAlignment = .center
        
        layout?.registerDecorationView(DecorationSectionView.self, inSection: CollectionAlignedLayout.Constant.commonDecorationViewIndex, updateAttributes: { attr in
            attr.backgroundColor = UIColor.white
        })
        layout?.registerDecorationView(DecorationSectionView.self, inSection: 0, updateAttributes: { attr in
            attr.backgroundColor = UIColor.yellow
        })
        layout?.registerDecorationView(DecorationSectionView.self, inSection: 1, updateAttributes: { attr in
            attr.backgroundColor = UIColor.green
        })
        layout?.registerDecorationView(DecorationSectionView.self, inSection: 2, updateAttributes: { attr in
            attr.backgroundColor = UIColor.red
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = data[indexPath.section][indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
