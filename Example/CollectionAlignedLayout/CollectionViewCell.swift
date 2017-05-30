//
//  CollectionViewCell.swift
//  CollectionAlignedLayout
//
//  Created by 李辉 on 2017/5/28.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bgImageView.layer.borderColor = UIColor.blue.cgColor
        bgImageView.layer.borderWidth = 1
        
        let sbv = UIView()
        sbv.backgroundColor = UIColor(red: 217 / 255.0, green: 217 / 255.0, blue: 217 / 255.0, alpha: 1)
        self.selectedBackgroundView = sbv
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImageView.layer.cornerRadius = self.frame.height / 2
        bgImageView.layer.masksToBounds = true
        
        self.selectedBackgroundView?.layer.cornerRadius = self.frame.height / 2
        self.selectedBackgroundView?.layer.masksToBounds = true
    }
    
}
