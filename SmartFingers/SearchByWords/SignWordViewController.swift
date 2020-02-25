//
//  SignWordViewController.swift
//  SmartFingers
//
//  Created by DCLab on 9/19/19.
//  Copyright © 2019 Aigerim Janaliyeva. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreData


class SignWordViewController: UIViewController, UINavigationBarDelegate {
    
    var navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55))
    var navItem = UINavigationItem()
    var text = ""
    var tapped = false
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    let filledImage = UIImage(named: "star_filled")
    let unfilledImage = UIImage(named: "star_unfilled")
    var starTapped = false
    
    var word: Word?
    
    lazy var errorImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "fatal-error")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    var descriptionTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Text"
        label.textColor = UIColor(r: 87, g: 69, b: 93)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(r: 180, g: 199, b: 231)
        return label
    }()
    
    var favouritesLabel: UILabel = {
        let label = UILabel()
        label.text = "Add to Favourites"
        label.textColor = UIColor(r: 247, g: 208, b: 111)
        label.textAlignment = .center
//        label.layer.cornerRadius = 10
//        label.layer.masksToBounds = true
        label.font = UIFont.italicSystemFont(ofSize: 18) //.systemFont(ofSize: 18)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    var addToFavourites: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupNavBar()
        setVideo()
    }
    
    func setupNavBar() {
        let height: CGFloat = 55
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self
//        navbar.appe
//        var navigationBarAppearace = navbar.compactAppearance
//        navigationBarAppearace.colo .tintColor = UIColor(red: 62/255, green: 66/255, blue: 97/255, alpha: 1)
//        navigationBarAppearace.barTintColor = UIColor(red: 62/255, green: 66/255, blue: 97/255, alpha: 1)
        if #available(iOS 13.0, *) {
            let coloredAppearance = UINavigationBarAppearance()
            coloredAppearance.configureWithOpaqueBackground()
            coloredAppearance.backgroundColor = UIColor(r: 48, g: 52, b: 83)//rgb(69, 70, 85)
            coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(red: 255/255, green: 247/255, blue: 214/255, alpha: 1)]
            coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 255/255, green: 247/255, blue: 214/255, alpha: 1)]
                   
            navbar.standardAppearance = coloredAppearance
            navbar.scrollEdgeAppearance = coloredAppearance
        } else {
            // Fallback on earlier versions
        }
        
//        navbar.barTintColor = UIColor(r: 69, g: 70, b: 85) //(red: 62/255, green: 66/255, blue: 97/255, alpha: 1)rgb(69, 70, 85)
//        navItem.title.
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navItem.leftBarButtonItem?.tintColor = UIColor(red: 255/255, green: 247/255, blue: 214/255, alpha: 1)
        navbar.items = [navItem]
//        navItem.title = word?.translation
        descriptionTextLabel.text = word?.translation
        view.addSubview(navbar)
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: self.view.topAnchor),
//            navbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            navbar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
//            navbar.heightAnchor.constraint(equalToConstant: 60),
            navbar.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])

        
        self.view.frame = CGRect(x: 0, y: height, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))
    }
    
    func setVideo(){
        guard let videoName = word?.video else { return }
        guard let path = Bundle.main.path(forResource: videoName, ofType:"mp4", inDirectory: "Videos") else {
            print("video not found")
            self.view.addSubview(errorImageView)
            errorImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            errorImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
            errorImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            errorImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 25).isActive = true
            errorImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -25).isActive = true
            errorImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
//            errorImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            return
        }
        addStarImage()
        player = AVPlayer(url: URL(fileURLWithPath: path))
        playerLayer = AVPlayerLayer(player: player)
        //        playerLayer.frame = CGRect(x: (self.view.bounds.width-100)/2, y: (self.view.bounds.height-100)/2, width: self.view.bounds.width-20, height: self.view.bounds.height/3) // CGRect(origin: self.view.bounds.origin, size: CGSize(width: 100, height: 100))
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        playerLayer.frame = CGRect(x: 0, y: 110, width: self.view.bounds.width, height: 240)
        self.view.layer.addSublayer(playerLayer)
        player.play()
        play()
        
    }
    
    
    func pause() {
        player.pause()
    }
    
    func play() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            self?.player.seek(to: CMTime.zero)
            self?.player.play()
        }
    }
    
    
    @objc func back(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpView(){
        self.view.backgroundColor = UIColor(r: 86, g: 89, b: 122)
        
        guard let isFavorite = word?.favourite else { return }
        starTapped = isFavorite
        print("\(starTapped)")

        let gesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(tapGestureRecognizer:)))
        addToFavourites.addGestureRecognizer(gesture)
        addToFavourites.isUserInteractionEnabled = true
        
        [descriptionTextLabel].forEach(self.view.addSubview)
        descriptionTextLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        descriptionTextLabel.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        descriptionTextLabel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true

        descriptionTextLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        descriptionTextLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40).isActive = true
        

        
        
    }
    
    func addStarImage(){
        [addToFavourites,favouritesLabel].forEach(self.view.addSubview)

        //check is it in array:
        // download array and />
        if starTapped {
            addToFavourites.image = filledImage
        } else {
            addToFavourites.image = unfilledImage
        }
        
        addToFavourites.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: self.view.frame.width/4).isActive = true
        addToFavourites.bottomAnchor.constraint(equalTo: descriptionTextLabel.topAnchor, constant: -45).isActive = true //-65
//                addToFavourites.centerYAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        addToFavourites.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addToFavourites.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        favouritesLabel.centerYAnchor.constraint(equalTo: self.addToFavourites.centerYAnchor).isActive = true
        favouritesLabel.leftAnchor.constraint(equalTo: descriptionTextLabel.leftAnchor).isActive = true
        favouritesLabel.rightAnchor.constraint(equalTo: addToFavourites.leftAnchor).isActive = true
        favouritesLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
    func setImageFavourite() {
        if starTapped {
            addToFavourites.image = unfilledImage
            starTapped = false
            print("zz:\(starTapped)")
        } else {
            addToFavourites.image = filledImage
            starTapped = true
        }
        update()
    }
    
    func update() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        print("1")
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
        print("2")
        let predicate = NSPredicate(format: "id == %i", word!.id)
        fetchRequest.predicate = predicate
        do {
            let words = try managedContext.fetch(fetchRequest)
            print("3")
            print("\(words.count)")
            if words.count == 1 {
                let wordObject = words.first as! Word
                wordObject.favourite = starTapped
                do {
                    print("4")
                    try managedContext.save()
                } catch {
                    print(error)
                }
            }
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    @objc func starTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if tappedImage == addToFavourites {
            setImageFavourite()
        }
    }
    
    
    
    
}

