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
        
        //agrega la fecha actual como fecha minima para el date picker de la pantalla y que no se puedan elegir fechas o horas anteriores
        dpkFecha.minimumDate = Date().addingTimeInterval(3600)
    }
    
    //con este metodo se manda los valores a la otra vista por medio del segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! AgendaViewController
        vc.nombre = txfNombre.text
        vc.lugar = txfLugar.text
        vc.fecha = dpkFecha.date
        
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

