//
//  HighscoreViewController.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 25/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Firebase

class HighscoreViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    @IBOutlet weak var howManyReps: UITextField!
    
    @IBOutlet weak var previousHighscoreLabel: UILabel!
    
    @IBOutlet weak var submitButton: UIButton!
    
    let fbMan = FirebaseManager() //instance of FirebaseManager class
    
    //Retrieving data through from performed segue.
    var retrieveDocName: String = "" // Is a combination of exerciseName + time interval picked. This is to follow set up DB convention.
    var retrieveUserId: String = ""
    var setHowManyReps = [0] //will be a list of highscore ... 300, retrieved from workout vc
   
    //Var to store picked no. of reps
    var pickedNumberOfReps = 0
    
    //pickerView
    var pickerView = UIPickerView()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign picker view delegate to this class.
        pickerView.delegate = self
        pickerView.dataSource = self
        howManyReps.inputView = pickerView //Assign textfield with pickerview.
        
        submitButton.isHidden = true //Hide submit button initially
        //Sets label to show previous highscore, which will always be index 0 of array.
        previousHighscoreLabel.text = "Previous: \(setHowManyReps[0])"
        
        print(setHowManyReps)
        print(retrieveUserId)
        print(retrieveDocName)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        //Upload highscore to firebase.
        fbMan.addData(userId: retrieveUserId, exerciseAndTime: retrieveDocName, highscore: pickedNumberOfReps, currentView: self.view)
    
    }
    
                //PICKERVIEW
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (setHowManyReps).count //sets amount of rows based on how many elements in array.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return String(setHowManyReps[row]) //sets the row titles to the numbers.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        howManyReps.text = String(setHowManyReps[row]) //Sets label to show how many reps picked
        howManyReps.resignFirstResponder() //resign it
        
        pickedNumberOfReps = setHowManyReps[row] //To have int val of reps picked, this can then be uploaded to firebase.
        submitButton.isHidden = false //Show submit button when reps picked.
    }

}
