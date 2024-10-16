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
    var nombre:String!
    var lugar:String!
    var fecha:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Nombre\(nombre!) \n lugar:\(lugar!) \n fecha:\(fecha!)")
        
    }
    
    
    @IBAction func Regresar() {
        dismiss(animated: true)
    }
    
    @IBAction func AgendarCita() {
        agendarNotificacion()
        agregarEvento()
    }
    
    @IBAction func AgregarContacto() {
    }
    
    @IBAction func OcultarTeclado() {
        view.endEditing(true)
    }
    
    func agendarNotificacion(){
        
    }
    
    func agregarEvento(){
        
    }
    
    func agregarContactoLibreta(){
        
    }
    
    func validarCorreo(_ correo:String) -> Bool {
        let expReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES%@", expReg)
        
        return emailPred.evaluate(with: correo)
    }
    
}
