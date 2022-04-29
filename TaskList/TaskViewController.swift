//
//  TaskViewController.swift
//  TaskList
//
//  Created by user215932 on 4/28/22.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var createdAt: Date!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let df = DateFormatter()
        df.dateFormat = "hh:mm dd-MM-yyyy"
        dateLabel.text = "Created at: \(df.string(from: createdAt))"
        nameLabel.text = name
    }
    
    @IBAction func didTapAddMedia(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func didTapShare(){
        let vc = UIActivityViewController(activityItems: [nameLabel.text!, imageView.image as Any], applicationActivities: nil)
        present(vc, animated: true)
    }

}

extension TaskViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            imageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
