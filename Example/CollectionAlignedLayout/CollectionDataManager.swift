//
//  CollectionDataManager.swift
//  CollectionAlignedLayout
//
//  Created by 李辉 on 2017/5/29.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

final class CollectionDataManager: NSObject {
    
    static let shared: CollectionDataManager = {
        let instance = CollectionDataManager()
        // setup code
        return instance
    }()
    
    lazy var dataSource: [[String]] = {
        let text1 = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        let text2 = "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."
        let text3 = "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        var dataSource = [[String]]()
        dataSource.append(text1.components(separatedBy: " "))
//        dataSource.append(text2.components(separatedBy: " "))
//        dataSource.append(text3.components(separatedBy: " "))
//         dataSource.append(["abcddddsfsdf", "sdfsdlfkjsdf", "sduiouioewr"])

        return dataSource
    }()

}
