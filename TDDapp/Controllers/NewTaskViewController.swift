//
//  NewTaskViewController.swift
//  TDDapp
//
//  Created by Дарья on 23.02.2021.
//

import UIKit
import CoreLocation

class NewTaskViewController: UIViewController {
    
    var taskManager: TaskManager!
    var geocoder: CLGeocoder!

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        return df
    }
    
    @IBAction func save(){
        let titleString = titleTF.text
        let locationString = locationTF.text
        let date = dateFormatter.date(from: dateTF.text!)
        let descriptionString = descriptionTF.text
        let addressString = addressTF.text
        
        geocoder.geocodeAddressString(addressString!) { [unowned self] (placemarks, error) in
            let placemark = placemarks?.first
            let coordinate = placemark?.location?.coordinate
            let location = Location(title: locationString!, coordinate: coordinate)
            let task = TaskModel(title: titleString!, description: descriptionString, date: date, location: location)
            self.taskManager.add(task)
        }
    }
}
