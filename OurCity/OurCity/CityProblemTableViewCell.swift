//
//  CityProblemTableViewCell.swift
//  OurCity
//
//  Created by user195143 on 12/17/21.
//

import UIKit

class CityProblemTableViewCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureWith(problem:Problem){
        labelName.text = problem.name

        let dateFormat = DateFormatter()
        
        // Get date in EN format
        dateFormat.dateFormat = "yyyy-MM-dd"
        let date = dateFormat.date(from: problem.date!)
        
        // Get date in PT format
        dateFormat.dateFormat = "dd/MM/yyyy"
        labelDate.text = dateFormat.string(from: date!)
    }
}
