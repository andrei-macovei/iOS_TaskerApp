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
    
    var createdAt: Date!
    var name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let df = DateFormatter()
        df.dateFormat = "hh:mm dd-MM-yyyy"
        dateLabel.text = "Created at: \(df.string(from: createdAt))"
        nameLabel.text = name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
