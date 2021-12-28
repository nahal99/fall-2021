//
//  ViewController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/16/21.
//

import UIKit

class MultipleChoiceController: UIViewController {
    
    var pickerIndex: Int = 0
    var currentIndex: Int = 0
    
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var choosenLabel: UILabel!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myNextButton: UIButton!


    
    @IBAction func showsNextQuestion(_ sender: UIButton){
        currentIndex += 1
        if(currentIndex == questions.count-1){
            sender.isEnabled = false
        }
        let question: String = questions[currentIndex]
        questionLabel.text = question
        choosenLabel.text = ""
        myButton.isEnabled = true

    }
    
    @IBAction func submitQuestion(_ sender: UIButton){
        let myAnswer = answer[currentIndex]
        if(myAnswer == pickerIndex){
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
    }
    
    
    let answer: [Int] = [
        2, 1, 0
    ]
    let questions: [String] = [
        "What is 2+0 = ?",
        "What is 5+5 = ?",
        "What is 1+4 = ?"
    ]
    let pickerData: [String] = [
        "5",
        "10",
        "2",
        "8"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = questions[currentIndex]
        choosenLabel.text = ""
        self.picker.delegate = self
        self.picker.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //resets if moved or deleted
        if(trackScore.sharedInstance.indexCounterMCQ == 0){
            super.viewWillAppear(animated)
            currentIndex = 0
            questionLabel.text = questions[currentIndex]
            choosenLabel.text = ""
            myButton.isEnabled = true
            myNextButton.isEnabled = true
        }
        //resets if add function called & edit cell called
        if(QuestionStore.sharedInstance.isEdited == true){
            super.viewWillAppear(animated)
            currentIndex = 0
            questionLabel.text = questions[currentIndex]
            choosenLabel.text = ""
            myButton.isEnabled = true
            myNextButton.isEnabled = true
        }
        
    }
    
}

extension MultipleChoiceController: UIPickerViewDataSource{
    //number of columns (hour/min would have 2)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
}

extension MultipleChoiceController: UIPickerViewDelegate{
    //inputs value for each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //detects when the user selects
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerIndex = row
    }
}



