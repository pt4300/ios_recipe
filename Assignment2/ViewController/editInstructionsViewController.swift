//
//  editInstructionsViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit

class editInstructionsViewController: UIViewController {

    var meal:Meal?
    weak var editInstrucitonDelegate:editInstructionDelegate?
    @IBOutlet weak var instruction: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let meal = self.meal{
            instruction.text = meal.instruction
        }

        
    
        
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func saveInstruction(_ sender: Any) {
        if let delegate = editInstrucitonDelegate, let meal = self.meal,let instruction = self.instruction.text{
            if delegate.editInstruction(instruction: instruction){
                navigationController?.popViewController(animated: true)
            }
            else{
                displayMessage(title: "Warning", message: "Please input valid instruction")
            }
       
            
        }
    }

    func displayMessage(title:String,message:String){
        let alterController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alterController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alterController,animated: true,completion: nil)
    }

}
