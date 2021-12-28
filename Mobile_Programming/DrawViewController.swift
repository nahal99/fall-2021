//
//  DrawViewController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/30/21.
//

import Foundation
import UIKit

class DrawViewController: UIViewController{
    
    @IBOutlet var draw: DrawView!
    
    var isEmpty = false
    
    var questions: Questions!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(isEmpty == false){
            draw.finishedLines = questions.finishedLines
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //clear first responded if keyboard is not dismissed yet
        guard let IMG: UIImage = draw.takeScreenshot() else{return}
        let finishedLines = draw.finishedLines
        
        if(isEmpty == false){
            questions.assignImage(image: IMG)
            questions.finishedLines = finishedLines
        }
        else{
            QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count-1].assignImage(image: IMG)
            QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count-1].finishedLines = finishedLines
            QuestionStore.sharedInstance.drawAcessed = true
        }
    }
    
}
    
