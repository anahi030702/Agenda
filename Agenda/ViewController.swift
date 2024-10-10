//
//  ViewController.swift
//  Agenda
//
//  Created by imac on 08/10/24.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txfNombre: UITextField!
    @IBOutlet weak var txfLugar: UITextField!
    @IBOutlet weak var dpkFecha: UIDatePicker!
    @IBOutlet weak var btnSiguiente: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dpkFecha.minimumDate = Date().addingTimeInterval(3600)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if txfNombre == textField{
            txfLugar.becomeFirstResponder()
        }else{
            txfLugar.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txfNombre.text!.count > 1 && txfLugar.text!.count > 1{
            btnSiguiente.isEnabled = true
        }else{
            btnSiguiente.isEnabled = false
        }
    }
    


}

