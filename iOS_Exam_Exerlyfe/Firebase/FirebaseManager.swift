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
    let db = Firestore.firestore()

    //Add data to firestore
    func addData(userId : String, exerciseAndTime : String, highscore : Int, currentView: UIView) {
        //Will create a document in users collection named <exercise><timeInterval>
        db.collection(userId).document(exerciseAndTime)
            .setData(["Highscore" : highscore]) { error in //Error handling.
                if let error = error {
                    self.showToast(view: currentView, message: "Error!")
                } else {
                    self.showToast(view: currentView, message: "Submitted!")
                }
        }
    }
    //Construction a toast message to be displayed on successful submit
    func showToast(view: UIView, message: String) {
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
