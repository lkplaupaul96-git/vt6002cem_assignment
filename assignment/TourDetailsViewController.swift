//
//  TourDetailsViewController.swift
//  assignment
//
//  Created by Paul Lau on 13/1/2022.
//

import UIKit
import CoreData

class TourDetailsViewController: UITableViewController, UINavigationControllerDelegate {
    
    var tour: TourDetail
    var selectedIdx: Int = -1
    
    var imagePicker: UIImagePickerController!
    var managedObjectContext : NSManagedObjectContext? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate.persistentContainer.viewContext;
        }
    return nil; }
    
    init(tour: TourDetail) {
        self.tour = tour
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Take Photo", style: .done, target: self, action:  #selector(takePhoto))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action:  #selector(closeTourDetailsView))
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.title = tour.title
    }
    
    @objc func closeTourDetailsView() {
        NotificationCenter.default.post(name: Notification.Name("clearTour"), object: nil)
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tour.tourPoints.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell_\(indexPath.row)")

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell_\(indexPath.row)")
        }
        
        cell!.textLabel?.text = tour.tourPoints[indexPath.row].title

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name("moveToPoint"), object: tour.tourPoints[indexPath.row].coord)
        self.selectedIdx = indexPath.row
    }
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
}

extension TourDetailsViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        
        let pngImage = selectedImage.pngData()
        if let context = self.managedObjectContext {
            if let newTourPhoto = NSEntityDescription.insertNewObject(forEntityName: "TourPhoto", into: context) as? TourPhoto {
                newTourPhoto.title = selectedIdx == -1 ? tour.title : tour.tourPoints[selectedIdx].title
                newTourPhoto.date = Date()
                newTourPhoto.imageData = pngImage
                newTourPhoto.point = Int32(selectedIdx)
                newTourPhoto.tourId = tour.id
            }
            do {
                try context.save();
            } catch  {
                print("can't save");
            }
        }
    }
}
