//
//  DictionaryByWordsVC.swift
//  SmartFingers
//
//  Created by Aigerim on 9/16/19.
//  Copyright © 2019 Aigerim Janaliyeva. All rights reserved.
//

import Foundation
import UIKit

class DictionaryByWordsVC: UIViewController, UINavigationBarDelegate, KeyboardDelegate {
    
    //MARK:- Variables
    var allWords = [Footballer]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredFootballer = [Footballer]()
    
    var navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
    var navItem = UINavigationItem()
    lazy var searchBar: UISearchBar = UISearchBar()
    let keyboardView = SignKeyboardView()
    var signPressed = false
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    //MARK:- Methods:
    @objc func back(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func signToLetter(_ sender: UIButton) {
        print("\n === signToLetter pressed~ === ")
        if !signPressed {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                //Frame Option 1:
                self.keyboardView.frame = CGRect(x: self.keyboardView.frame.origin.x, y: self.screenSize.height - self.screenSize.width, width: self.keyboardView.frame.width, height: self.keyboardView.frame.height)
                //Frame Option 2:
                //self.myView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 4)
                self.keyboardView.backgroundColor = .blue
                
            }, completion: nil)
            signPressed = true
            
        } else {
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                //Frame Option 1:
                self.keyboardView.frame = CGRect(x: self.keyboardView.frame.origin.x, y: self.screenSize.height, width: self.keyboardView.frame.width, height: self.keyboardView.frame.height)
                //Frame Option 2:
                //self.myView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 4)
                self.keyboardView.backgroundColor = .blue
                
            }, completion: nil)
            signPressed = false
        }
    }
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTableView()
        self.hideKeyboardWhenTappedAround()
    }
    
    func setupNavBar() {
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Sign", style: .plain, target: self, action: #selector(signToLetter))
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navItem.titleView = searchBar
        
        navbar.items = [navItem]
        view.addSubview(navbar)
        
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: self.view.topAnchor),
            navbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            navbar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navbar.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
        self.view.frame = CGRect(x: 0, y: 75, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - 75))
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        //your code here....
        print("SEARCHIng...")
        filteredFootballer = allPlayers.filter { footballer in
            let isMatchingSearchText = footballer.name.lowercased().contains(textSearched.lowercased())// || textSearched.lowercased().count == 0
            //            print(isMatchingSearchText)
            if !isMatchingSearchText {
                filteredFootballer = [Footballer(name: "none", league: "")]
                tableview.reloadData()
            }
            return isMatchingSearchText
        }
        tableview.reloadData()
    }
    
    func didPressButton(button: LetterButton) {
        guard let letter = button.letter else {
            return
        }
        searchBar.text! += letter
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(NameCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableview)
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -screenSize.width),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
        
        keyboardView.delegate = self
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        NSLayoutConstraint.activate([
            //             keyboardView.topAnchor.constraint(equalTo: tableview.bottomAnchor),
            keyboardView.topAnchor.constraint(equalTo: self.view.bottomAnchor),
            //             keyboardView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            keyboardView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            keyboardView.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
    }
    

    
}
// MARK: - UISearchResultsUpdating Delegate
extension DictionaryByWordsVC: UISearchBarDelegate {
    
}
// MARK: - UITableView Delegate 
extension DictionaryByWordsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredFootballer.count > 0 {
            if filteredFootballer[0].name == "none" {
                return 0
            }
            return filteredFootballer.count
        }
        return allPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 2
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! NameCell
        let candy: Footballer
        if filteredFootballer.isEmpty {
            candy = allPlayers[indexPath.row]
        } else {
            candy = filteredFootballer[indexPath.row]
        }
        cell.dayLabel.text = candy.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let destination = SignWordViewController()
        let name: String
        if filteredFootballer.isEmpty {
            name = allPlayers[indexPath.row].name
        } else {
            name = filteredFootballer[indexPath.row].name
        }
        destination.navItem.title = name //tableView.cellForRow(at: indexPath)?.textLabel!.text
        self.present(destination, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}

