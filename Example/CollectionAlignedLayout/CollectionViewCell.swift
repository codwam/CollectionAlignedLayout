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
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        bgImageView.layer.cornerRadius = bgImageView.frame.height / 2
//        bgImageView.layer.masksToBounds = true
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgImageView.layer.cornerRadius = self.frame.height / 2
        bgImageView.layer.masksToBounds = true
    }
    
}
