//
//  MusclesViewController.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 29/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class MusclesViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseManager.getMuscleDescription(exercise: ChoiceTableViewController.exerciseChosen, vc: self)
    }
    


}
