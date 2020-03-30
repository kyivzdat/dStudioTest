//
//  ClassTVCell.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 29.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit

class ClassTVCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var teacherLabel: UILabel!
    
    func fillWith(nameOfCourse name: String?, teacherName teacher: String?) {
        nameLabel.text = name ?? "-"
        teacherLabel.text = "Teacher: " + (teacher ?? "-")
    }

}
