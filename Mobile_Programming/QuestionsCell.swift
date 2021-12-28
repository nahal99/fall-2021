//
//  QuestionsCell.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/18/21.
//

import UIKit

class QuestionsCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    func setQuestion(question: Questions){
        questionLabel.text = question.question
        answerLabel.text = question.answer
    }

}
