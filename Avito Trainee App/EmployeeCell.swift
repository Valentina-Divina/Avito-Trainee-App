//
//  EmployeeCell.swift
//  Avito Trainee App
//
//  Created by Valya on 25.10.2022.
//

import UIKit

class EmployeeCell: UITableViewCell {
     let employeeName = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
     let employeePhoneNumber = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
     let employeeSkillsContainer = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    // MARK: - initialize
    private func initialize() {
        initLabel(targetLabel: employeeName, font: UIFont(name: "Helvetica", size: 30), center: center)
        initLabel(targetLabel: employeePhoneNumber, font: UIFont(name: "Helvetica", size: 30), center: center)
        
        employeeSkillsContainer.axis = .horizontal
        employeeSkillsContainer.distribution = .equalSpacing
        employeeSkillsContainer.spacing = 10
        employeeSkillsContainer.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(employeeSkillsContainer)
        
        employeeNameConstraint()
        employeeSkillsContainerConstraint()
        employeePhoneNumberConstraint()
        
    }
    
    // MARK: - initLabel
    private func initLabel(targetLabel: UILabel, font:UIFont?, center: CGPoint) {
        
        targetLabel.font = font
        targetLabel.textColor = .white
        targetLabel.center = center
        targetLabel.textAlignment = .center
        targetLabel.numberOfLines = 1
        targetLabel.lineBreakMode = .byTruncatingTail
        targetLabel.sizeToFit()
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(targetLabel)
    }
    
    // MARK: - Labels colors
    private let colors = [
        UIColor.init(red: 1/255, green: 51/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 20/255, green: 11/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 40/255, green: 51/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 50/255, green: 1/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 100/255, green: 51/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 150/255, green: 20/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 200/255, green: 51/255, blue: 3/255, alpha: 0.9),
        UIColor.init(red: 255/255, green: 51/255, blue: 3/255, alpha: 0.9),
        UIColor.init(red: 51/255, green: 51/255, blue: 153/255, alpha: 0.9),
        UIColor.init(red: 100/255, green: 150/255, blue: 153/255, alpha: 0.9)
    ]
    
    // MARK: - setSkills
    func setSkills(_ skills: [String]) {
        employeeSkillsContainer.subviews.forEach({ $0.removeFromSuperview() })
        for skill in skills {
            let skillLabel = UILabel()
            skillLabel.text = skill
            skillLabel.font = UIFont(name: "Helvetica", size: 22)
            skillLabel.textColor = .white
            
            skillLabel.layer.backgroundColor = colors[abs(skill.hash)%10].cgColor
            skillLabel.layer.cornerRadius = 5
            
            
            skillLabel.center = center
            skillLabel.textAlignment = .center
            skillLabel.numberOfLines = 1
            skillLabel.lineBreakMode = .byTruncatingTail
            skillLabel.sizeToFit()
            skillLabel.translatesAutoresizingMaskIntoConstraints = false
            employeeSkillsContainer.addArrangedSubview(skillLabel)
        }
        contentView.layoutIfNeeded()
    }
    
    // MARK: - employeeNameConstraint
    private func employeeNameConstraint() {
        NSLayoutConstraint.activate([
            employeeName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            employeeName.bottomAnchor.constraint(equalTo: employeeSkillsContainer.topAnchor),
            employeeName.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20)
        ])
    }
    
    // MARK: - employeeSkillsContainerConstraint
    private func employeeSkillsContainerConstraint() {
        NSLayoutConstraint.activate([
            employeeSkillsContainer.topAnchor.constraint(equalTo: employeeName.bottomAnchor),
            employeeSkillsContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            employeeSkillsContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            employeeSkillsContainer.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -20)
        ])
    }
    
    // MARK: - employeePhoneConstraint
    private func employeePhoneNumberConstraint() {
        NSLayoutConstraint.activate([
            employeePhoneNumber.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            employeePhoneNumber.bottomAnchor.constraint(equalTo: employeeSkillsContainer.topAnchor),
            employeePhoneNumber.rightAnchor.constraint(greaterThanOrEqualTo: contentView.rightAnchor, constant: -20),
            employeePhoneNumber.leftAnchor.constraint(greaterThanOrEqualTo: employeeName.rightAnchor)
        ])
    }
    
}
