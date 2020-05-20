//
//  addMovieViewController.swift
//  InstaMovies
//
//  Created by Lobna on 5/20/20.
//  Copyright © 2020 Lobna. All rights reserved.
//

import UIKit

class addMovieViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var releaseDateTextField: UITextField!
    @IBOutlet weak var overviewTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    var savedMovie = SavedMovie()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Movies.plist")
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       // Try to find next responder
       if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
          nextField.becomeFirstResponder()
       } else {
          // Not found, so remove keyboard.
          textField.resignFirstResponder()
       }
       // Do not add a line break
       return false
    }
    
    @IBAction func addedMovieBtn(_ sender: UIBarButtonItem) {
        if titleTextField.text != "" && releaseDateTextField.text != "" && overviewTextField.text != ""{
            savedMovie.title = titleTextField.text!
            savedMovie.date = releaseDateTextField.text!
            savedMovie.overview = overviewTextField.text!
//            saveMovie(movie: savedMovie)
            guard let image = posterImage.image else {
                if let navController = self.navigationController {
                        navController.popViewController(animated: true)
                    }
                return }
            saveMovieData(image: image)
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "You need to enter all data", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectImageBtn(_ sender: UIButton) {
        self.presentImagePicker(controller: imagePicker, source: .photoLibrary)
    }
    
    func presentImagePicker(controller: UIImagePickerController , source: UIImagePickerController.SourceType) {
        controller.delegate = self
        controller.sourceType = source
        self.present(controller, animated: true)
    }
    
    func saveMovie(movie: SavedMovie){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(movie)
//            data.appen
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding data \(error)")
        }
    }
    
    //MARK: - save movie data
    func saveMovieData(image: UIImage) {
        
        let encoder = PropertyListEncoder()
        guard let imageData = image.jpegData(compressionQuality: 1) else { return }
        savedMovie.image = imageData
        do {
            let data = try encoder.encode(savedMovie)
            try data.write(to: dataFilePath!)
        } catch let error {
            print("error saving file with error", error)
        }

    }

//    func loadImageFromDiskWith(fileName: String) -> UIImage? {
//
//      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
//
//        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
//        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
//
//        if let dirPath = paths.first {
//            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
//            let image = UIImage(contentsOfFile: imageUrl.path)
//            return image
//
//        }
//
//        return nil
//    }

}
// MARK: - Image Picker Controller
extension addMovieViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return self.imagePickerControllerDidCancel(picker)
        }
        
        self.posterImage.image = image
        
        picker.dismiss(animated: true) {
            picker.delegate = nil
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            picker.delegate = nil
        }
    }
    
}

