//
//  HowToViewController.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 28/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import WebKit

class HowToViewController: UIViewController {
    
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.getVideoUrl(exercise: ChoiceTableViewController.exerciseChosen, vc: self)
        
    }
}
