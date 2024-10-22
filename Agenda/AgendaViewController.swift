//
//  AgendaViewController.swift
//  Agenda
//
//  Created by imac on 09/10/24.
//

import UIKit
import EventKit
import Contacts

class AgendaViewController: UIViewController {
    
    @IBOutlet weak var txfCorreo: UITextField!
    @IBOutlet weak var txfTelefono: UITextField!
    
    @IBOutlet weak var txvNotas: UITextView!
    var nombre:String!
    var lugar:String!
    var fecha:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imprimimos los valores que llegan desde la primer pantalla
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
        //valida el correo con la expresion regular del metodo validar correo y verificamos que el numero de telefono tenga minimo 10 digitos
        if validarCorreo(txfCorreo.text!) && txfTelefono.text!.count == 10 {
            agregarContactoLibreta()
        }
        else{
            //Muestra la alerta en la pantalla
            let alerta = UIAlertController(title: "ERROR", message: "El correo o el telefono son invalidos", preferredStyle: .alert)
            //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            alerta.addAction(ok)
            present(alerta, animated: true)
        }
    }
    
    @IBAction func OcultarTeclado() {
        view.endEditing(true)
    }
    
    func agendarNotificacion(){
        //Genera cuerpo notificación y le vamos asignando valores a la notificacion
        let cuerpoNotificacion = UNMutableNotificationContent()
        cuerpoNotificacion.title = "TIENES CITA EN UNA HORA"
        cuerpoNotificacion.body = "Cita con \(nombre!) en \(lugar!)"
        //numero de notificacion que aparecera
        cuerpoNotificacion.badge = 1
        
        // Setear el trigger
        //Creas el calendario y le dices que tipo de calendario
        let calendario = Calendar(identifier: .gregorian)
        //le decimos que datos queremos extraer del calerndario y a la fecha le restamos una hora para que le avise una hora antes de la cita
        let componentes = calendario.dateComponents([.year, .month, .day, .hour, .minute ], from: fecha!.addingTimeInterval(-3600))
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: componentes, repeats: false)
        
        //Solicitar agendar la notificación
        let request = UNNotificationRequest(identifier: "recordatorio", content: cuerpoNotificacion, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func agregarEvento(){
        //Agregar recordatorio a app de recordatorios
        let evento = EKEventStore()

        evento.requestAccess(to: .reminder) { grant, error in
        if grant
        {
            
            let recordatorio = EKReminder(eventStore: evento)
            recordatorio.title = "Cita con \(self.nombre!) "
            recordatorio.location = "En \(self.lugar!) "
            recordatorio.calendar = evento.defaultCalendarForNewReminders()
            
            DispatchQueue.main.async {
                recordatorio.notes = self.txvNotas.text
            }
            
            let alarma = EKAlarm(absoluteDate: self.fecha!)
            recordatorio.alarms = [ alarma ]
            
            do{
                try evento.save(recordatorio, commit:true)
                //para decirle que todo lo de adentro se ejecute en el hilo principal y no en el background, esto esta en el background porque hace lo de reminder en background
                DispatchQueue.main.async {
                    //Muestra la alerta en la pantalla
                    let alerta = UIAlertController(title: "EXITO!", message: "Se agrego el evento a la app reminder", preferredStyle: .alert)
                    //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
                    let ok = UIAlertAction(title: "Aceptar", style: .default)
                    alerta.addAction(ok)
                    self.present(alerta, animated: true)
                }
                
            }catch{
                DispatchQueue.main.async {
                    //Muestra la alerta en la pantalla
                    let alerta = UIAlertController(title: "ERROR!", message: "Se produjo un error", preferredStyle: .alert)
                    //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
                    let ok = UIAlertAction(title: "Aceptar", style: .default)
                    alerta.addAction(ok)
                    self.present(alerta, animated: true)
                    }
                }
            
        }
            else{
                DispatchQueue.main.async {
                    //Muestra la alerta en la pantalla
                    let alerta = UIAlertController(title: "ERROR!", message: "No tienes permiso de guardar en la app de reminder", preferredStyle: .alert)
                    //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
                    let ok = UIAlertAction(title: "Aceptar", style: .default)
                    alerta.addAction(ok)
                    self.present(alerta, animated: true)
                }
            }
        }
    }
    
    func agregarContactoLibreta(){
        // Agrega contacto a la libreta de contactos del dispositivo
        let contacto = CNMutableContact()
        contacto.givenName = nombre!
        contacto.familyName = "Apellido"
        contacto.organizationName = "UTT"
        
        
        let t1 = CNLabeledValue.init(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: txfTelefono.text!))
       
        let t2 = CNLabeledValue.init(label: CNLabelPhoneNumberHomeFax, value: CNPhoneNumber(stringValue: "1234566789"))
        contacto.phoneNumbers = [t1, t2]
        
        let correo = CNLabeledValue(label: CNLabelHome, value: txfCorreo.text! as NSString)
        let correo2 = CNLabeledValue(label: CNLabelWork, value: "hola@gmail.com" as NSString)
        contacto.emailAddresses = [correo, correo2 ]
        
        let guardarContacto = CNContactStore()
        let peticion = CNSaveRequest()

        peticion.add(contacto, toContainerWithIdentifier: nil)
        
        do{
            try guardarContacto.execute(peticion)
            
            //Muestra la alerta en la pantalla
            let alerta = UIAlertController(title: "EXITO!", message: "Se agrego el contacto a la libreta de contactos del dispositivo", preferredStyle: .alert)
            //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
            let ok = UIAlertAction(title: "Aceptar", style: .default)
            alerta.addAction(ok)
            present(alerta, animated: true)
            
        }catch{
            if error.localizedDescription == "Access Denied"{
                //Muestra la alerta en la pantalla
                let alerta = UIAlertController(title: "ERROR!", message: "Debes aceptar el permiso para guardar contactos, cambialo en la configuracion de la App", preferredStyle: .alert)
                //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
                let ok = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(ok)
                self.present(alerta, animated: true)
                
            }else{
                //Muestra la alerta en la pantalla
                let alerta = UIAlertController(title: "ERROR!", message: "Ocurrio un error al guardar el contacto, intentalo de nuevo", preferredStyle: .alert)
                //hace el boton OK y por default ya hace que se quite la notificacion, si agregamos el handler podriamos decirle que queremos que haga el boton cuando lo presionen
                let ok = UIAlertAction(title: "Aceptar", style: .default)
                alerta.addAction(ok)
                self.present(alerta, animated: true)
            }
        }
    }
    
    func validarCorreo(_ correo:String) -> Bool {
        //expresion regular que verifica que lo que escribe el usuario tenga el formato de un correo valido
        let expReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES%@", expReg)
        
        return emailPred.evaluate(with: correo)
    }
    
}
