//
//  CityProblemViewController.swift
//  OurCity
//
//  Created by user195143 on 12/17/21.
//

import UIKit
import AVKit

class CityProblemViewController: UIViewController {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocalization: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var textViewProblemDescription: UITextView!

    var problem:Problem?
    var trailer: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cityProblemFormViewController = segue.destination as? CityProblemFormViewController {
            cityProblemFormViewController.problem = problem
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareScreen()
    }
    
    func prepareScreen(){
        if let problem = problem {
            if let photo = problem.photo {
                imageViewPhoto.image = UIImage(data: photo)
            }
            labelName.text = problem.name
            labelLocalization.text = problem.localization
            textViewProblemDescription.text = problem.problemDescription
            
            let dateFormat = DateFormatter()
            
            // Get date in EN format
            dateFormat.dateFormat = "yyyy-MM-dd"
            let date = dateFormat.date(from: problem.date!)
            
            // Get date in PT format
            dateFormat.dateFormat = "dd/MM/yyyy"
            labelDate.text = dateFormat.string(from: date!)
        }
    }
}

