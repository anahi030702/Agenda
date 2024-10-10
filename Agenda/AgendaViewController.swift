//
//  AgendaViewController.swift
//  Agenda
//
//  Created by imac on 09/10/24.
//

import UIKit

class AgendaViewController: UIViewController {

    @IBOutlet weak var txfCorreo: UITextField!
    @IBOutlet weak var txfTelefono: UITextField!
    
    @IBOutlet weak var txvNotas: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
   
    @IBAction func Regresar() {
        dismiss(animated: true)
    }
    
    @IBAction func AgendarCita() {
    }
    
    @IBAction func AgregarContacto() {
    }
    
    @IBAction func OcultarTeclado() {
        view.endEditing(true)
    }
}
