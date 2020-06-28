//
//  Exercises.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 22/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import UIKit

//Simple model class to be used to create objects of to fill tableview.
class Exercise {
    var image : UIImage
    var exerciseName : String
    
    
    //Init method
    init(image : UIImage, exerciseName : String) {
        self.image = image
        self.exerciseName = exerciseName
    }
   
}
