//
//  RotinaDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 01/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import ObjectMapper

class RotinaDetalhesViewController: UIViewController {

    @IBOutlet weak var arquivadoSwitch: UISwitch!
    @IBOutlet weak var nomeRotinaTextField: UITextField!
    @IBOutlet weak var observacoesTextField: UITextField!
    
    var rotina : Rotina?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(btnSalvarPressed)
        )
    }
    
    @objc func btnSalvarPressed(sender: UIBarButtonItem) {
        
        arquivadoSwitch.endEditing(true)
        nomeRotinaTextField.isEnabled = false
        observacoesTextField.isEnabled = false
        
        rotina = Rotina()
        
        rotina?.nome = nomeRotinaTextField.text!
        rotina?.observacao = nomeRotinaTextField.text!
        
        if arquivadoSwitch.isOn {
            rotina?.status = "Q"
        }
        else {
            rotina?.status = "A"
        }
        
        //let valor = [
          //
            //"NomeRotina": trimmedComment,
            //"Date": todaysDate
            
        //]
        
        let rotinaDB = Database.database().reference().child("Rotinas")
        
        rotinaDB.childByAutoId().setValue(rotina!.toJSONString()) {
            (error, reference) in
            
            if let errorSaving = error {
                print(errorSaving)
            }
            else {
                print("Rotina Saved!")
                
                self.arquivadoSwitch.endEditing(false)
                self.nomeRotinaTextField.isEnabled = true
                self.observacoesTextField.isEnabled = true
            }
        }
        
    }
}
