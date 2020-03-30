//
//  DetailTVC.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 29.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit

class DetailTVC: UITableViewController {

    @IBOutlet private weak var titleLabel:           UILabel!
    @IBOutlet private weak var typeLabel:            UILabel!
    @IBOutlet private weak var lvlOfDifficultyLabel: UILabel!
    @IBOutlet private weak var descriptionLabel:     UILabel!
    @IBOutlet private weak var teacherLabel:         UILabel!
    @IBOutlet private weak var teacherImageView:     UIImageView!
    @IBOutlet private weak var phoneLabel:           UILabel!
    @IBOutlet private weak var emailLabel:           UILabel!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.center = self.teacherImageView.center
        self.teacherImageView.addSubview(indicator)
        return indicator
    }()

    var info: ClassModel!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        fillView()
        navigationItem.title = info.name
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getTeacherImage(info.classPhotos.first?.image)
    }
    
    // MARK: - fillView
    private func fillView() {
        activityIndicator.startAnimating()
        
        titleLabel.text = info.name
        typeLabel.text = info.type
        lvlOfDifficultyLabel.text = String(info.levelOfDifficulty) + "/5"
        descriptionLabel.text = info.info
        teacherLabel.text = info.teacher?.name ?? "-"
        phoneLabel.text = info.teacher?.phoneNumber ?? "-"
        emailLabel.text = info.teacher?.email
    }
    
    // MARK: getTeacherImage
    private func getTeacherImage(_ link: String?) {
        
        guard let url = URL(string: link ?? "") else {
            activityIndicator.stopAnimating()
            teacherImageView.image = #imageLiteral(resourceName: "noImage")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
                
                guard let data = data else {
                    self.teacherImageView.image = #imageLiteral(resourceName: "noImage")
                    return
                }
                
                self.teacherImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
