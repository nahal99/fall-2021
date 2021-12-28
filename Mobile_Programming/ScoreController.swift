//
//  ScoreController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/16/21.
//

import UIKit

class ScoreController: UIViewController {
    
    var overall: Int = QuestionStore.sharedInstance.fib.count + 3
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var currenScore: UILabel!
    
    @IBAction func showResults(_ sender: UIButton!){
        
        resultLabel.text = "Correct Questions: \(trackScore.sharedInstance.correctAnswers)"
        
        if(trackScore.sharedInstance.correctAnswers > trackScore.sharedInstance.incorrectAnswers){
            self.view.backgroundColor = UIColor.green
        }
        if(trackScore.sharedInstance.correctAnswers < trackScore.sharedInstance.incorrectAnswers){
            self.view.backgroundColor = UIColor.red
        }
        if(trackScore.sharedInstance.correctAnswers == trackScore.sharedInstance.incorrectAnswers){
            self.view.backgroundColor = UIColor.white
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //resets if add function called & edit cell called
        if(QuestionStore.sharedInstance.isEdited == true){
            super.viewWillAppear(animated)
            resultLabel.text = ""
            trackScore.sharedInstance.reset()
        }

    }
    
    
}

class trackScore {
    static let sharedInstance = trackScore()
    var correctAnswers: Int = 0
    var incorrectAnswers: Int = 0
    var indexCounterMCQ: Int = 0
    var indexCounter: Int = 0
    var scoreReset: Int = 0

    func reset(){
        correctAnswers = 0
        incorrectAnswers = 0
        scoreReset = 0
        indexCounterMCQ = 0
        indexCounter = 0
    }
    
}
