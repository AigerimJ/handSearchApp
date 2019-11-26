//
//  HandShapeVC.swift
//  SmartFingers
//
//  Created by DCLab on 11/7/19.
//  Copyright © 2019 Aigerim Janaliyeva. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import CoreData

class HandShapeVC: UIViewController, UINavigationBarDelegate, UINavigationControllerDelegate {
    
    //MARK:- Variables
    /*Tasks:
     - video in cell
     - add plus cell if empty collectionView
     - CoreData add
     - Change overall design:
     - remove fingerSpelling
     - change favourites icon to fingerHeart
     - change background color -> gradient
     - Animation for icons
     - position of save icon below the video
     - 
     */
    
    var navbar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 75))
    var navItem = UINavigationItem()
    let screenSize: CGRect = UIScreen.main.bounds
    
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HandShapeImageCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
//    fileprivate let data = [
//        CustomData(title: "The Islands!", url: "wiki", backgroundImage: #imageLiteral(resourceName: "sample1")),
//        CustomData(title: "Sample", url: "wiki", backgroundImage: #imageLiteral(resourceName: "sample1")),
//        CustomData(title: "Sample", url: "wiki", backgroundImage: #imageLiteral(resourceName: "sample3")),
//        CustomData(title: "Sample Views!", url: "wiki", backgroundImage: #imageLiteral(resourceName: "sample1")),
//        CustomData(title: "Sample", url: "wiki", backgroundImage: #imageLiteral(resourceName: "sample1")),
//    ]
    
    var handshapes = [Shape]()
    
    let searchLimit = 5
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor.white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor.white
        return tv
    }()
    
    private let persistentContainer = NSPersistentContainer(name: "SmartFingers")
    lazy var fetchedResultsController: NSFetchedResultsController<Word> = {
        
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "translation", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    var predicateSigns = [[Int]]()
    
    var wasLaunched = false
    
    //MARK:- Methods:
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setUpViews()
        
        persistentContainer.loadPersistentStores { (NSPersistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let error = error as NSError
                    print("\(error), \(error.localizedDescription)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !wasLaunched {
            openCameraView()
            wasLaunched = true
        }
    }
    
    @objc func back(_ sender: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeCamera(_ sender: UIButton){
        if handshapes.count < searchLimit {
           openCameraView()
        }
    }
    
    func openCameraView(){
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraDevice = .front
        vc.delegate = self
        present(vc, animated: true)
    }
        

    func setUpViews() {
        
        //NavigationBar:
        navbar.backgroundColor = UIColor.white
        navbar.delegate = self
        navItem.title = "HandShape Recognition"
        navItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        let cameraItem = UIBarButtonItem(title: "Camera", style: .plain, target: self, action: #selector(changeCamera))
//        navItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "flip2"), style: .plain, target: self, action: #selector(changeCamera))
        //UIBarButtonItem(title: "Change camera", style: .plain, target: self, action: #selector(changeCamera))//#selector(signToLetter))
//        UIBarButtonItem(image: UIImage(named: "camera_flip"), style: .plain, target: self, action: #selector(changeCamera))
        
//        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        negativeSpacer.width = 50
//
//        navItem.rightBarButtonItems = [negativeSpacer, cameraItem]
        navItem.rightBarButtonItem = cameraItem
        
        navbar.items = [navItem]
        view.addSubview(navbar)
        NSLayoutConstraint.activate([
            navbar.topAnchor.constraint(equalTo: self.view.topAnchor),
            navbar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            navbar.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            navbar.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        self.view.frame = CGRect(x: 0, y: 75, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - 75))
        
        
        //CollectionView:
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 75).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width/3).isActive = true
        
        //TableView:
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(HandShapeVideoCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
        
        
    }
    
    func showActionSheet(controller: UIViewController, indexPath: IndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            print("User click Delete button")


            self.handshapes.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
            self.newFetch()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    
    func newFetch() {
        var predicate: NSPredicate?
        if handshapes.count == 0 {
            predicate = nil
        } else {
            var predicates = [NSPredicate]()
            for shape in handshapes {
                guard shape.status == .accepted else { continue }
                guard let signs = shape.signs else { continue }
//                let localPredicate = NSPredicate(format: "(ANY handshapes.id == %i) OR (ANY handshapes.id == %i) OR (ANY handshapes.id == %i)", signs[0], signs[1], signs[2])
                let localPredicate = NSPredicate(format: "(ANY handshapes.id == %i) OR (ANY handshapes.id == %i)", signs[0], signs[1])
                predicates.append(localPredicate)
            }
            print("test:\(predicates.count)")
            print("test1")
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            print(predicate.debugDescription)
            print("test2")
        }
        
        
        fetchedResultsController.fetchRequest.predicate = predicate
        
        do {
            print("test3")
            try fetchedResultsController.performFetch()
            print("test4")
            tableview.reloadData()
            print("test5")
        } catch {
            let error = error as NSError
            print("\(error), \(error.localizedDescription)")
        }
    }
}


// MARK: - UICollectionView Delegate
extension HandShapeVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/3)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return handshapes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HandShapeImageCell
        cell.data = self.handshapes[indexPath.item]
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        showActionSheet(controller: self, indexPath: indexPath)
        
//        performSegue(withIdentifier: "showDetail", sender: cell)
    }
    
//    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
//      sampleData.remove(at: indexPath.row)
//      collectionView.deleteItems(at: [indexPath])
//    }
    
}

// MARK: - UITableView Delegate
extension HandShapeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let words = fetchedResultsController.fetchedObjects else { return 0}
        return words.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! HandShapeVideoCell
        let word = fetchedResultsController.object(at: indexPath)
        cell.word = word
        cell.deployWord()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        let destination = SignWordViewController()
        let word = fetchedResultsController.object(at: indexPath)
        print(word.translation ?? "no word")
        destination.word = word
        self.present(destination, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UIImagePickerController Delegate
extension HandShapeVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("error, image not returned")
            return
        }
        
        guard let imageToSend = recizeImage(image: image, percentage: 0.3) else { fatalError("Couldn't recize an image")}
        let uuid = UUID()
        
        handshapes.append(Shape(image: imageToSend, id: uuid, signs: nil, status: .loading))
        collectionView.reloadData()
        
        
        let handShapeRequest = HandShapeRequest()
        handShapeRequest.getHandShape(image: imageToSend) { [weak self] (result: [Int]?) in
            DispatchQueue.main.async {
                if let result = result {
                    print(result)
                    print(uuid.uuidString)
                    
                    if let index = self?.handshapes.firstIndex(where: { (shape) -> Bool in
                        return shape.id == uuid
                    }) {
                        self?.handshapes[index].signs = result
                        self?.handshapes[index].status = .accepted
                        self?.collectionView.reloadData()
                    }
                    
                    self?.newFetch()
                    
                } else {
                    if let presentedVC = self?.presentedViewController as? UIAlertController {
                        presentedVC.dismiss(animated: true, completion: nil)
                    }
                    
                    if let index = self?.handshapes.firstIndex(where: { (shape) -> Bool in
                        return shape.id == uuid
                    }) {
                        // Add deletion shake
                        let indexPath = IndexPath(row: index, section: 0)
                        self?.collectionView.cellForItem(at: indexPath)
                        
                        self?.handshapes.remove(at: index)
                        self?.collectionView.deleteItems(at: [indexPath])
                    }
                }
            }
        }
    }
    
    
    func recizeImage(image: UIImage, percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: image.size.width * percentage, height: image.size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: image.imageRendererFormat).image { _ in
            image.draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}

extension HandShapeVC: NSFetchedResultsControllerDelegate {}

struct Shape {
    var image: UIImage
    var id: UUID
    var signs: [Int]?
    var status: shapeStatus
    
}

enum shapeStatus {
    case loading
    case accepted
    case failed
}
