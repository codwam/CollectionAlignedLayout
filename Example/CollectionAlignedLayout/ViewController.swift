//
//  ViewController.swift
//  CollectionAlignedLayout
//
//  Created by codwam on 05/28/2017.
//  Copyright (c) 2017 codwam. All rights reserved.
//

import UIKit
import CollectionAlignedLayout

class ViewController: UIViewController {
        
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let debugItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(debugTapped(_:)))
        self.navigationItem.rightBarButtonItem = debugItem
        
        segmentedControl.selectedSegmentIndex = layout?.horizontalAlignment.rawValue ?? 0
    }
    
    @objc
    fileprivate func debugTapped(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func onSegmentValueChanged(_ sender: UISegmentedControl) {
        guard let align = HorizontalAlignment(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        layout?.horizontalAlignment = align
        layout?.invalidateLayout()
        collectionView?.reloadData()
    }
    
    // MARK: - Private
    
    var collectionView: UICollectionView?  {
        guard let vc = self.children.first as? CollectionViewController else {
            return nil
        }
        return vc.collectionView
    }
    
    var layout: CollectionAlignedLayout?  {
        guard let layout = collectionView?.collectionViewLayout as? CollectionAlignedLayout else {
            return nil
        }
        return layout
    }
}

