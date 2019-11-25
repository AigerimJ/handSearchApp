//
//  HomeTableViewController.swift
//  SmartFingers
//
//  Created by DCLab on 11/21/19.
//  Copyright © 2019 Aigerim Janaliyeva. All rights reserved.
//

import Foundation
import UIKit

class HomeTableViewController: UIViewController, UINavigationBarDelegate {
    
    //MARK:- Variables
    let screenSize: CGRect = UIScreen.main.bounds
    let gradientOne = UIColor(red: 93/255, green: 96/255, blue: 130/255, alpha: 1)
    let gradientTwo = UIColor(red: 86/255, green: 89/255, blue: 122/255, alpha: 1)
    let gradientThree = UIColor(red: 62/255, green: 66/255, blue: 97/255, alpha: 1)
    let gradientFour = UIColor(red: 48/255, green: 52/255, blue: 83/255, alpha: 1)

    let image1 = UIImage(named: "satellite")
    let image2 = UIImage(named: "observatory")
    let image3 = UIImage(named: "space-ship")
    let image4 = UIImage(named: "comet")

    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    //MARK:- Methods:
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = gradientTwo
        setupTableView()
    }
    
    func setupTableView() {
        tableview.backgroundColor = gradientTwo
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(HomeCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableview)
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
        
    }
    override var prefersStatusBarHidden: Bool {
           return true
    }
}
// MARK: - UITableView Delegate
extension HomeTableViewController: UITableViewDataSource, UITableViewDelegate {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! HomeCell
//        cell.dayLabel.text = word.translation
        let cellBackground = [gradientOne, gradientTwo, gradientThree, gradientFour]
        let titles = ["Words", "Categories", "Hand Shape", "Favourites"]
        let images = [image1, image2, image3, image4]
        cell.nameLabel.text = titles[indexPath.row]
        cell.leftImageView.image = images[indexPath.row]
        cell.backgroundColor = cellBackground[indexPath.row]
        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let dictionaryByWordsVC = DictionaryByWordsVC()
//            let transition = CATransition()
//            transition.duration = 0.5
//            transition.type = CATransitionType.push
//            transition.subtype = CATransitionSubtype.fromRight
//            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//            view.window!.layer.add(transition, forKey: kCATransition)
            self.present(dictionaryByWordsVC, animated: true, completion: nil)
        }
        if indexPath.row == 1 {
            let categoryVC = CategoriesViewController()
            self.present(categoryVC, animated: true, completion: nil)
        }
        if indexPath.row == 2 {
            let signVC = HandShapeVC()//SignViewController()
            self.present(signVC, animated: true, completion: nil)
        }
        if indexPath.row == 3 {
            let signVC = FavouriteViewController()
            self.present(signVC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenSize.height/4
    }
    
}
