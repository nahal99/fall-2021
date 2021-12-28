//
//  FillBlankController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/16/21.
//

import UIKit

class FillBlankController: UIViewController {
    

    @IBOutlet weak var field: UITextField!
    @IBOutlet weak var choosenLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myNextButton: UIButton!
    @IBOutlet var imageView: UIImageView!


    var currentIndex: Int = 0
    
    @IBAction func showsNextQuestion(_ sender: UIButton){
        currentIndex += 1
        if(currentIndex == QuestionStore.sharedInstance.fib.count - 1){
            sender.isEnabled = false
        }
        let question: String = QuestionStore.sharedInstance.fib[currentIndex].question
        questionLabel.text = question
        choosenLabel.text = ""
        myButton.isEnabled = true
        if(QuestionStore.sharedInstance.fib[currentIndex].image != nil){
            imageView.image = QuestionStore.sharedInstance.fib[currentIndex].loadImage()
        }
        else
        {
            imageView.image=nil
        }
    }
    @IBAction func submitQuestion(_ textField: UITextField){
        let myAnswer = field.text
        if(myAnswer == QuestionStore.sharedInstance.fib[currentIndex].answer){
            choosenLabel.text = "CORRECT"
            choosenLabel.textColor = UIColor.green
            trackScore.sharedInstance.correctAnswers += 1
        }
        else{
            choosenLabel.text = "INCORRECT"
            choosenLabel.textColor = UIColor.red
            trackScore.sharedInstance.incorrectAnswers += 1

        }
        myButton.isEnabled = false
        field.text?.removeAll()
    }
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        field.resignFirstResponder()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = QuestionStore.sharedInstance.fib[currentIndex].question
        choosenLabel.text = ""
        imageView.image = QuestionStore.sharedInstance.fib[currentIndex].loadImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //resets if moved or deleted
        if(trackScore.sharedInstance.indexCounter == 0){
            super.viewWillAppear(animated)
            currentIndex = 0
            questionLabel.text = QuestionStore.sharedInstance.fib[currentIndex].question
            choosenLabel.text = ""
            myButton.isEnabled = true
            myNextButton.isEnabled = true
 
        }
        //resets if add function called & edited cell called
        if(QuestionStore.sharedInstance.isEdited == true){
            super.viewWillAppear(animated)
            currentIndex = 0
            questionLabel.text = QuestionStore.sharedInstance.fib[currentIndex].question
            choosenLabel.text = ""
            myButton.isEnabled = true
            myNextButton.isEnabled = true
            imageView.image = nil

        }
        
    }
}


