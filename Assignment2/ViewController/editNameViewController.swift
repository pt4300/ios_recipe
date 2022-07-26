//
//  editNameViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit

class editNameViewController: UIViewController {

    var meal:Meal?
    weak var editeNameDelegate:editNameDelegate?
    
    @IBOutlet weak var name: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let meal = self.meal{
            name.placeholder = meal.name
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func saveEditName(_ sender: Any) {
        if let delegate = editeNameDelegate,let name = name.text {
            
            if delegate.editName(name: name) && name != ""{
                navigationController?.popViewController(animated: true)
                
            }
            else{
            displayMessage(title: "Warning", message: "Please input valid name")
            }
        }
    }
    
    
    func displayMessage(title:String,message:String){
        let alterController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alterController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alterController,animated: true,completion: nil)
    }
    
}
