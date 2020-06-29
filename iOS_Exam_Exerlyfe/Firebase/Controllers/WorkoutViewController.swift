//
//  WorkoutViewController.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 22/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import Firebase

class WorkoutViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
                    //IBOUTLET VARS
    @IBOutlet weak var exerciseImage: UIImageView!
    
    @IBOutlet weak var exerciseName: UILabel!
    
    @IBOutlet weak var timerButtonsStackView: UIStackView!
    
    @IBOutlet weak var timeIntervalPick: UITextField!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var highscoreLabel: UILabel!
    
    @IBOutlet weak var submitHighscoreButton: UIButton!
    
    //Programatically constructing label
    let secondsLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = UIColor.white
        return label
    }()
    
                            //VARS/LETS
 
    
    //retrieving passed data here, have to cause segue is performed before viewDidLoad.
    var retrieveUserId:String! = ""//retrieve fb userid
    var retrieveExerciseName:String! = "" //exerciseName
    var retrieveExerciseImage:UIImage? = nil //Same for image
    //Timer
    var timer = Timer()
    var timerDisplayed = 0 //initial timer value
    //Circle progress view layers
    var shapeLayer: CAShapeLayer! //Layer for shape
    var pulsatingLayer: CAShapeLayer! //Layer for pulsating effect
    //Pickerview & timer intervals
    let timeIntervals = [5,30,60,120]

    static var timerIntervalPicked = 0 //to be set to what is picked, static cause it's used by firebase manager
    
    var pickerView = UIPickerView()
    
                        //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        //Assign datasource & delegate of pickerview
        pickerView.delegate = self
        pickerView.dataSource = self
        timeIntervalPick.inputView = pickerView //Assign textfield with pickerview.
        
        setExerciseNameAndImage() //Set label and imageview
        setUpCircleProgressBar() //Set up circle progressbar + label inside it.

        timerButtonsStackView.isHidden = true //Initially hidden, untill time is selected.
        submitHighscoreButton.isHidden = true
    }
    
    
                //FUNCS
    private func setExerciseNameAndImage() {
        //Setting IBOutlet's to the retrieved data from Choice...VC
        exerciseName.text = retrieveExerciseName
        exerciseImage.image = retrieveExerciseImage
        
    }
    //Create circle shape layer.
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        //Circular path
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true) //define path, 2*pi is full circle
        layer.path = circularPath.cgPath //expects a cgpath, sets the path created above
        layer.strokeColor = strokeColor.cgColor //specify stroke color
        layer.lineWidth = 20 //pixel width
        layer.lineCap = .round //smooth out the edges of the line
        layer.fillColor = fillColor.cgColor //fill color/middle of circle.
        layer.position = view.center
        return layer
    }
    
    //Handles filling the progress bar up in duration amount of seconds.
    func fillProgressCircle(duration:Int){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") //the stroke end set earlier
        
        //Animation values
        basicAnimation.toValue = 1 //to animate it
        basicAnimation.duration = CFTimeInterval(duration) //Duration of animation
        basicAnimation.fillMode = .forwards //remains filled in its final state
        basicAnimation.isRemovedOnCompletion = false //dont remove it when it's done
        shapeLayer.add(basicAnimation, forKey: "basicAnimiation")
    }
    
    //Set up progressbar/style it and add to view.
    private func setUpCircleProgressBar() {
                        // CIRCLE PROGRESSBAR
        //Pulsating layer styling
        pulsatingLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 0.1987235915), fillColor: #colorLiteral(red: 0.1585051715, green: 0.6766349673, blue: 0.7152240276, alpha: 0.4))
        view.layer.addSublayer(pulsatingLayer)
        //Track layer
        let trackLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.5), fillColor: .clear)
        view.layer.addSublayer(trackLayer)
        //Shape layer
        shapeLayer = createCircleShapeLayer(strokeColor: #colorLiteral(red: 0, green: 0.8376980634, blue: 0.09658340669, alpha: 1), fillColor: .clear)
        shapeLayer.strokeEnd = 0 //when to stop
        view.layer.addSublayer(shapeLayer) //add it to view.
        
        //Set label in center
        view.addSubview(secondsLabel)
        secondsLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        secondsLabel.center = view.center
    }
    //Creating the pulsating animation
    private func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale") //scale, constantly scaling up and down
        animation.toValue = 1.3 //will scale up to x
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut) //timing func, animation not linear, acceleration, decelaration
        animation.autoreverses = true //will reverse
        animation.repeatCount = Float.infinity //repeat forever
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
                        //PICKERVIEW
    
    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeIntervals.count //as many as elements in array
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(timeIntervals[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            timeIntervalPick.text = String(timeIntervals[row])
            timeIntervalPick.resignFirstResponder()
            timerButtonsStackView.isHidden = false //Show start/stop/reset when time is selected
        WorkoutViewController.timerIntervalPicked = timeIntervals[row] //Set var to what is picked.
        
        FirebaseManager.readHighscoreFromDb(userId: retrieveUserId, exercise: retrieveExerciseName, vc: self)
    }
    
    
                        // BUTTONS
    @IBAction func startButton(_ sender: UIButton) {
        //repeat every 1 second, target self, will repeat every second. selector is the objC func.
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ActionTimer), userInfo: nil, repeats: true)
        
        fillProgressCircle(duration: WorkoutViewController.timerIntervalPicked) ////time set to what is picked in pickerview
        //Start animating pulse
        animatePulsatingLayer()
        pulsatingLayer.isHidden = false //Show it when start.
        startButton.isHidden = true //Hide start button when pressed to avoid it running multiple times if pressed again
        
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        timer.invalidate() //first stop it
        timerDisplayed = 0 //set timer displayed to 0 again
        secondsLabel.text = "00" //set the label to 00 again too
        pulsatingLayer.isHidden = true //hide pulsating layer when stopped.
        startButton.isHidden = false //show start button after reset pressed.
        submitHighscoreButton.isHidden = true //hide it on reset
    }
    
    @IBAction func submitHighscoreButtonPressed(_ sender: UIButton) {
    }
    
    //Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "woutToHighscore" {
        //Store viewcontroller
        let destinationVC = segue.destination as! HighscoreViewController //casting and force unwrap cause I know it's there.
        //Passing data
        destinationVC.retrieveUserId = retrieveUserId
            destinationVC.retrieveDocName = retrieveExerciseName + String(WorkoutViewController.timerIntervalPicked)
            destinationVC.setHowManyReps = Array(FirebaseManager.highscore...300) //pass an array from highscore to 300.
        }
    }
    
    
    //Object C function to handle timer
    @objc func ActionTimer(){
        timerDisplayed += 1 //add one to timerdisplayed every second.
        secondsLabel.text = String(timerDisplayed) //setting the label to the time, casting cause label text is always a string.
        
        //stop timer and change label text when time picked is hit.
        //and present option to submit a highscore.
        if timerDisplayed == WorkoutViewController.timerIntervalPicked {
            timer.invalidate()
            secondsLabel.text = "DONE!"
            submitHighscoreButton.isHidden = false //Show it when time's up
        }
        
    }
    
   
}
