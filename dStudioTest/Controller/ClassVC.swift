//
//  ViewController.swift
//  dStudioTest
//
//  Created by Vladyslav Palamarchuk on 29.03.2020.
//  Copyright © 2020 Vladyslav Palamarchuk. All rights reserved.
//

import UIKit

class ClassVC: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var teacherPickerView: UIPickerView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.systemBlue
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        return indicator
    }()
    
    private var allClasses:     [ClassModel] = []
    private var printClasses:   [ClassModel] = []
    private var teachers:       [String] = ["No teachers"]
    
    private let networking = Networking()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstSetup()
        getClasses()
    }
    
    private func firstSetup() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        
        teacherPickerView.delegate = self
        teacherPickerView.dataSource = self
    }
    
    private func getClasses() {
        
        activityIndicator.show(parentVC: self)
        
        networking.getClasses() { classes in
            guard let classes = classes else { return }
            
            self.allClasses = classes
            self.printClasses = classes
            self.teachers = self.getTeacherList(classes)
            
            self.tableView.reloadData()
            self.teacherPickerView.reloadAllComponents()
            self.activityIndicator.hide()
        }
    }
    
    private func getTeacherList(_ classes: [ClassModel]) -> [String] {
        
        var setList: Set<String> = []
        
        for cls in classes {
            
            guard let teacherName = cls.teacher?.name else { continue }
            setList.insert(teacherName)
        }
        
        var result = setList.sorted()
        if result.isEmpty {
            result = ["No teachers"]
        } else {
            result.insert("All teachers", at: 0)
        }
        
        return result
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let dvc = segue.destination as? DetailTVC,
            let selectedClass = sender as? ClassModel
            else { return }
        
        dvc.info = selectedClass
    }
}

// MARK: - UITableViewDataSource
extension ClassVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Classes"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        printClasses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "classCell", for: indexPath) as? ClassTVCell
            else { return UITableViewCell() }
        
        let currentClass = printClasses[indexPath.row]
        cell.fillWith(nameOfCourse: currentClass.name, teacherName: currentClass.teacher?.name)
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ClassVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedClass = printClasses[indexPath.row]
        performSegue(withIdentifier: "segueToDetailVC", sender: selectedClass)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UIPickerViewDataSource
extension ClassVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        teachers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        teachers[row]
    }
    
}

// MARK: - UIPickerViewDelegate
extension ClassVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if teachers[row] == "All teachers" {
            printClasses = allClasses
        } else {
            let teacher = teachers[row]
            selectionClassesBy(teacher)
        }
        tableView.reloadData()
    }
    
    private func selectionClassesBy(_ teacher: String) {
        printClasses = []
        for cls in allClasses {
            guard cls.teacher?.name == teacher else { continue }
            
            printClasses.append(cls)
        }
    }
}
