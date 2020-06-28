//
//  ChoiceTableViewController.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 22/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ChoiceTableViewController: UITableViewController {
    
    //Create array for data
    var exercises : [Exercise] = [] //Empty array of type fighter class
    var exerciseChosen: String = "" //to be set to the chosen exercise and passed
    var exerciseChosenImg: UIImage? = nil
    var retrieveUserId: String = "" //to be userId retrieved from VC, to be passed on further

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting the background
        let bgView = UIImageView(frame: tableView.bounds)
        bgView.image = UIImage(named: "2")
        tableView.backgroundView = bgView
        
        exercises = createArray() //fill the array with func
    }
    
    func createArray() -> [Exercise] { //func is gonna create the exercise object and throw it into temp array
        //then return that temp array, which is to be assigned to the "exercises" array
        var tempExercises : [Exercise] = []
        
        //Create exercises..
        let exercise1 = Exercise(image: #imageLiteral(resourceName: "org copy"), exerciseName: "Pushup")
        let exercise2 = Exercise(image: #imageLiteral(resourceName: "crunch"), exerciseName: "Crunch")
        let exercise3 = Exercise(image: #imageLiteral(resourceName: "lunge"), exerciseName: "Lunge")
        let exercise4 = Exercise(image: #imageLiteral(resourceName: "sidelunge"), exerciseName: "Side Lunge")
        let exercise5 = Exercise(image: #imageLiteral(resourceName: "run"), exerciseName: "Run")
        let exercise6 = Exercise(image: #imageLiteral(resourceName: "dumbellCurl"), exerciseName: "Dumbell Curl")
        let exercise7 = Exercise(image: #imageLiteral(resourceName: "barbellCurl"), exerciseName: "Barbell Curl")
           
        //append to temp array
        tempExercises.append(exercise1)
        tempExercises.append(exercise2)
        tempExercises.append(exercise3)
        tempExercises.append(exercise4)
        tempExercises.append(exercise5)
        tempExercises.append(exercise6)
        tempExercises.append(exercise7)
        
            
        
        //return temp array
        return tempExercises
       }
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // as many rows in section as the length of exercise array.
        return exercises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell
        let exercise = exercises[indexPath.row] //whatever is at that row
         
         //making sure I get custom cell
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! ExerciseTableViewCell

         //setting it by calling method in the ExerciseTableViewCell class
         cell.setExercise(exercise: exercise) // pass in exercise
         
        return cell //return the cell.
    }


    // MARK: - Navigation
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        exerciseChosen = exercises[indexPath.row].exerciseName //sets var to the exercise name of clicked row.
        exerciseChosenImg = exercises[indexPath.row].image //same for image
        
        // Perform segue created in storyboard.
        self.performSegue(withIdentifier: "workoutSegue", sender: self)
        
    }
    
    //Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Store viewcontroller
        let destinationVC = segue.destination as! WorkoutViewController //casting and force unwrap cause I know it's there.
        destinationVC.retrieveExerciseName = exerciseChosen //Passing the data here, through variable set in didSelectRow
        destinationVC.retrieveExerciseImage = exerciseChosenImg //same for image
        destinationVC.retrieveUserId = retrieveUserId //passing on userId further
    }

}
