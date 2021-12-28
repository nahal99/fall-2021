//
//  ListQuestionController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/18/21.
//

import UIKit

class ListQuestionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        //toggle&set the boolean value "isEditing"
        self.tableView.isEditing = !self.tableView.isEditing
        if(self.tableView.isEditing){
            sender.title = "Done"
        }
        else{
            sender.title = "Edit"
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    //reloads tableview data
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }
    
    //injects the selected question from cell into segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the triggered segue is "showQuestion" segue
        switch segue.identifier{
            case "showQuestion":
            //figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row{
                //get item with that row passed in
                let item = QuestionStore.sharedInstance.fib[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.questions = item
                
            }
        case "showNewQuestion":
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.isEmpty = true


        default:
            preconditionFailure("Unexpected segue identifier.")
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionStore.sharedInstance.fib.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //creates cell description
        let one_question = QuestionStore.sharedInstance.fib[indexPath.row]
        //creates instant of UITableViewCell with QuestionCell appearance
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as! QuestionsCell
        cell.setQuestion(question: one_question)
        
        return cell
    }
    
    //allows you to move around the cells
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObjTemp = QuestionStore.sharedInstance.fib[sourceIndexPath.row]
        //removes it from one locations and inserts in another
        QuestionStore.sharedInstance.fib.remove(at: sourceIndexPath.row)
        QuestionStore.sharedInstance.fib.insert(movedObjTemp, at: destinationIndexPath.row)
        trackScore.sharedInstance.reset()
        QuestionStore.sharedInstance.save()

    }
    
    //allows you to delete cell
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            //remove item from the array
            QuestionStore.sharedInstance.fib.remove(at: indexPath.row)
//            //removes the item's image from the image store
//            ImageStore.sharedInstance.deleteImage(forkey: QuestionStore.sharedInstance.fib[indexPath.row].itemKey)
            //delete from table view with animation
            tableView.deleteRows(at: [indexPath], with: .automatic)
            trackScore.sharedInstance.reset()
            QuestionStore.sharedInstance.save()

        }
    }

}



