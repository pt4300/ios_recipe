//
//  ingredientDetailViewController.swift
//  Assignment2
//
//  Created by Yuting Yu on 11/4/21.
//

import UIKit

class ingredientDetailViewController: UIViewController {

    var ingredientDetail:String?
    
    @IBOutlet weak var detail: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let passedDetail = ingredientDetail{
            detail.text = passedDetail
        }
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
