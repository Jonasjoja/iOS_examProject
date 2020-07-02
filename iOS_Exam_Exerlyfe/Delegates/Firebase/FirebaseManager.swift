//
//  FirebaseManager.swift
//  iOS_Exam_Exerlyfe
//
//  Created by admin on 22/06/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import Foundation
import Firebase


class FirebaseManager{
    
    //Reference to firestore.
    private static let db = Firestore.firestore()
    //Store highscore
    static var highscore: Int = 0
    //Store video url
    static var videoUrl: URL? = nil
    
    //Collection reference
    private static let instructionsCollection = "Instructions"

    //Add data to firestore
   static func addData(userId : String, exerciseAndTime : String, highscore : Int, currentView: UIView) {
        //Will create a document in users collection named <exercise><timeInterval>
        db.collection(userId).document(exerciseAndTime)
            .setData(["Highscore" : highscore]) { error in //Error handling.
                if let error = error {
                    showToast(view: currentView, message: "Error! \(error)")
                } else {
                    showToast(view: currentView, message: "Submitted!")
                }
        }
    }
    
        //READ HIGHSCORE FROM DB

    static func readHighscoreFromDb(userId: String, exercise: String, vc:WorkoutViewController){
        //Reference to specific document, collection is created named after FB user id, document named after exercise name.
        let docRef = db.collection(userId).document(exercise + String(WorkoutViewController.timerIntervalPicked))
        
        docRef.getDocument() { (document, error) in
            print(45)
            if let document = document, document.exists { //if the document exists
                highscore = (document.get("Highscore") as! Int)
                vc.highscoreLabel.text = "Highscore: " + String(highscore) //Set here because here I actually have the data.
                
            } else if document!.exists == false{
                vc.highscoreLabel.text = "No Highscore Yet!"
            }
        }
        print(54)
    }
    
    //Gets video url from firebase
    static func getVideoUrl(exercise: String, vc:HowToViewController){
        let docRef = db.collection(instructionsCollection).document(exercise)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                videoUrl = URL(string: "https://www.youtube.com/embed/\((document.get("videoUrl") as! String))")
                vc.webView.load(URLRequest.init(url: videoUrl!))
                
            } else if document!.exists == false{
                vc.webView.isHidden = true
                vc.instructionLabel.text = "No Instruction Available"
            }
        }
    }
    
    static func getMuscleDescription(exercise: String, vc:MusclesViewController){
        
     let docRef = db.collection(instructionsCollection).document(exercise)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists{
                vc.descriptionLabel.text = (document.get("Description") as! String)
            } else if document!.exists == false{
                vc.descriptionLabel.text = "No Information Available"
            }
        }
    }
    
                    //TOAST MESSAGE
    //Constructing toast message to be displayed on successful submit
    static func showToast(view: UIView, message: String) {
        let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width/2 - 75, y: view.frame.size.height/2 + 20, width: 150, height: 35))
        toastLabel.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Avenir Next", size: 16)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
