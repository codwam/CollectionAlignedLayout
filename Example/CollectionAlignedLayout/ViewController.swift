//
//  ViewController.swift
//  CollectionAlignedLayout
//
//  Created by codwam on 05/28/2017.
//  Copyright (c) 2017 codwam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        if self.navigationController!.viewControllers.count == 1 {
            let debugItem = UIBarButtonItem(title: "Debug", style: .plain, target: self, action: #selector(debugTapped(_:)))
            self.navigationItem.leftBarButtonItem = debugItem
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    fileprivate func debugTapped(_ sender: Any) {
        let viewController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController")
        navigationController?.pushViewController(viewController, animated: true)
    }

}

