//
//  ViewController.swift
//  HelpPlus
//
//  Created by rayhan on 7/25/17.
//  Copyright © 2017 rayhan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var list: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
       list.target = self.revealViewController()
        list.action = #selector(SWRevealViewController.revealToggle(_:))

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

