//
//  ViewController.swift
//  Avito Trainee App
//
//  Created by Valya on 24.10.2022.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private let companyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private let repository = Repository.shared
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var backgroundImageView: UIImageView? = nil
    private let refreshControl = UIRefreshControl()
    
    private var company: Company = Company(name: "", employees: []) {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        assignBackground()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(red: 0.0, green: 0.34, blue: 0.75, alpha: 0.2)
        self.tableView.register(EmployeeCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = true
        
        view.addSubview(tableView)
        
        constraintsTableView()
        observeRotation()
        
        companyContsraints()
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        
        getCompany()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    // MARK: - assignbackground
    private func assignBackground(){
        let background = UIImage(named: "background_svg")
        
        backgroundImageView = UIImageView(frame: view.bounds)
        
        if let backgroundIV = backgroundImageView {
            backgroundIV.contentMode =  UIView.ContentMode.scaleAspectFill
            backgroundIV.clipsToBounds = false
            backgroundIV.image = background
            backgroundIV.center = view.center
            view.addSubview(backgroundIV)
            self.view.sendSubviewToBack(backgroundIV)
        }
    }
    
    // MARK: - observeRotation
    private func observeRotation() {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationChanged(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
    }
    
    // MARK: - initLabel
    private func initLabel(targetLabel: UILabel, text: String, font:UIFont?, center: CGPoint) {
        targetLabel.font = font
        targetLabel.textColor = .white
        targetLabel.textAlignment = .center
        targetLabel.numberOfLines = 2
        targetLabel.text = text
        targetLabel.lineBreakMode = .byTruncatingTail
        targetLabel.sizeToFit()
        targetLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(targetLabel)
    }
    
    // MARK: - constraintsTableView
    private func constraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
        ])
        
        print(view.safeAreaInsets.top)
        print(view.layoutGuides)
    }
    
    // MARK: - companyContsraints
    private func companyContsraints() {
        initLabel(targetLabel: companyLabel, text: "Авито", font: UIFont(name: "Helvetica", size: 40), center: self.view.center)
        
        NSLayoutConstraint.activate([
            companyLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            companyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            companyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            companyLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor)
        ])
    }
    
    // MARK: - getCompany
    private func getCompany() {
        repository.getCompany(completion: { [weak self] data in
            if let unwrappedData = data {
                
                let covertedEmploees = unwrappedData.company?.employees.map({ emp in
                    Employee(
                        name: emp.name,
                        phoneNumber: emp.phoneNumber,
                        skills: Array(emp.skills)
                    )
                }) ?? []
                
                let sortedEmploees = covertedEmploees.sorted(by: { first, second in
                    return first.name < second.name
                })
                
                let converted = Company(
                    name: unwrappedData.company?.name ?? "",
                    employees: sortedEmploees
                )
                
                self?.company = converted
                self?.companyLabel.text = converted.name
            } else {
                
            }
            self?.refreshControl.endRefreshing()
            
        }) { [weak self] err in
            self?.refreshControl.endRefreshing()
            self?.alertError(error: err)
        }
    }
    
    // MARK: - alertError
    private func alertError(error: Error) {
        let alert = UIAlertController(
            title: "Something went wrong \u{1F622}",
            message: error.localizedDescription,
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry",
                                      style: .default,
                                      handler: { action in
            self.getCompany()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - refreshControl
    @objc func refresh(_ sender: AnyObject) {
        self.getCompany()
    }
    
    //MARK: - orientationChanged
    @objc func orientationChanged(notification : NSNotification) {
        backgroundImageView?.frame = view.bounds
    }
}

// MARK: - TableViewDelegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            return self.company.employees.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! EmployeeCell
        cell.employeeName.text = self.company.employees[indexPath.row].name
        cell.employeePhoneNumber.text = self.company.employees[indexPath.row].phoneNumber
        cell.setSkills(self.company.employees[indexPath.row].skills)
        cell.textLabel?.textColor = .black
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}

// MARK: - UI models

struct Company {
    let name: String
    let employees: [Employee]
}

struct Employee {
    let name: String
    let phoneNumber: String
    let skills: [String]
}
