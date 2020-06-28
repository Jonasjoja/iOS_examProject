//
//  ExerciseTableViewCell.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 22/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    //Image outlet
    @IBOutlet weak var exerciseImage: UIImageView!
    //Exercise name label
    @IBOutlet weak var exerciseName: UILabel!
    
    
    //is put in here to encapsulate
    //set func to populate the cells of tableview.
       func setExercise(exercise : Exercise){
        exerciseImage.image = exercise.image
        exerciseName.text = exercise.exerciseName
       }
}
