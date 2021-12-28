//
//  Questions.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/18/21.
//

import Foundation
import UIKit


class Questions: Codable {
    var question: String
    var answer: String
    let dateCreated: Date
    let itemKey: String
    var image: ImageStore?
    var finishedLines = [Line]()
    
    //initalizes the cell data
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        self.image = nil
    }
    
    //gets the image & loading
    func loadImage() -> UIImage? {
        guard let temp = self.image else {return nil}
        return UIImage(data: temp.image)
    }
    
    //sets the image & assigning
    func assignImage(image: UIImage!) {
        if(image != nil){
            let i = ImageStore(image: image)
            self.image = i
        }
        else{
            self.image = nil
        }
    }
    
}
