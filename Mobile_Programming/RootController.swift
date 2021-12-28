//
//  RootController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/29/21.
//

import Foundation
import UIKit

class RootController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionStore.sharedInstance.load()
    }

    
}
