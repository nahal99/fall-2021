//
//  DetailViewController.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/23/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var questionField: UITextField!
    @IBOutlet var answerField: UITextField!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var isEmpty = false
    
    var questions: Questions! {
        didSet{
            //shows a new title when you click on cell
            navigationItem.title = questions.question
        }
    }
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    //dismisses the keyboard upon tapping return using Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //dismissing keyboard upon tapping the background view
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    //adding image picker controller creation tells it camera, photolibrary,etc
    func imagePicker(for sourceType: UIImagePickerController.SourceType) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        return imagePicker
    }


    @IBAction func choosePhotoSource(_ sender: UIBarButtonItem){
        //creating an alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ _ in
            let imagePicker = self.imagePicker(for: .camera)
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)

        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){ _ in
            let imagePicker = self.imagePicker(for: .photoLibrary)
            imagePicker.modalPresentationStyle = .popover
            imagePicker.popoverPresentationController?.barButtonItem = sender
            self.present(imagePicker, animated: true, completion: nil)
        }
        alertController.addAction(photoLibraryAction)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: UIBarButtonItem) {
        if(isEmpty == false){
            imageView.image = nil
            questions.assignImage(image: imageView.image)
        }
        else{
            imageView.image = nil
            QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count-1].assignImage(image: imageView.image)
        }
        QuestionStore.sharedInstance.isEdited = true
        
    }
    

    //accessing the selected image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //get picked image from info dictionary
        let image = info[.originalImage] as! UIImage
        //put that image on the screen in image view
        imageView.image = image
        //take image picker off the screen - you must call this dismiss method
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //if the text is present already do this
        if(isEmpty == false){
            questionField.text = questions.question
            answerField.text = questions.answer
            dateLabel.text = dateFormatter.string(from: questions.dateCreated)
            imageView.image = questions.loadImage()
        }
        if(QuestionStore.sharedInstance.drawAcessed == true){
            imageView.image = QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count - 1].loadImage()
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //clear first responded if keyboard is not dismissed yet
        view.endEditing(true)
        
        //Saves edit made to an item in fill in blank
        if(isEmpty == false){
            questions.question = questionField.text ?? ""
            questions.answer = answerField.text ?? ""
            QuestionStore.sharedInstance.isEdited = true
            questions.assignImage(image: imageView.image)
        }
        //Saves an added item to question and answer array
        else{
            let newQ = questionField.text ?? ""
            let newA = answerField.text ?? ""
            QuestionStore.sharedInstance.fib.append(Questions(question: "", answer: ""))
            QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count-1].question = newQ
            QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count-1].answer = newA
            QuestionStore.sharedInstance.fib[QuestionStore.sharedInstance.fib.count-1].assignImage(image: imageView.image)
            
            if(QuestionStore.sharedInstance.drawAcessed == true){
                QuestionStore.sharedInstance.fib.removeLast()
                QuestionStore.sharedInstance.drawAcessed = false
                
                for i in 0..<QuestionStore.sharedInstance.fib.count{
                    if(QuestionStore.sharedInstance.fib[i].question == "" || QuestionStore.sharedInstance.fib[i].answer == ""){
                        QuestionStore.sharedInstance.fib.remove(at: i)
                    }
                }
            }
            QuestionStore.sharedInstance.isEdited = true
        }
        
        QuestionStore.sharedInstance.save()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the triggered segue is "showQuestion" segue
        switch segue.identifier{
        case "draw":
            let drawViewController = segue.destination as! DrawViewController
            drawViewController.questions = questions
            drawViewController.isEmpty = isEmpty

        default:
            preconditionFailure("Unexpected segue identifier.")
            
        }
    }
    
}
