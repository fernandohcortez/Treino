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

class RotinaDetalhesViewController: BaseDetailsViewController {

    @IBOutlet weak var arquivadoLabel: UILabel!
    @IBOutlet weak var arquivadoSwitch: UISwitch!
    @IBOutlet weak var nomeRotinaTextField: UITextField!
    @IBOutlet weak var observacoesTextField: UITextField!
    
    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureSaveButton()
        
        if viewState == .Adding {
            
            model = Rotina()
            
            arquivadoSwitch.isHidden = true
        }

        carregarModelTela()
    }
    
    func carregarModelTela () {
        
        nomeRotinaTextField.text = _rotina.nome
        observacoesTextField.text = _rotina.observacao
        
        let arquivado = _rotina.status == "Q"
        arquivadoSwitch.isOn = arquivado
        arquivadoLabel.isHidden = !arquivado
    }
    
    func configureSaveButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(btnSalvarPressed)
        )
    }
    
    @objc func btnSalvarPressed(sender: UIBarButtonItem) {
        
        arquivadoSwitch.endEditing(true)
        nomeRotinaTextField.isEnabled = false
        observacoesTextField.isEnabled = false
        
        _rotina.nome = nomeRotinaTextField.text!
        _rotina.observacao = observacoesTextField.text!
        
        _rotina.status = arquivadoSwitch.isOn ? "Q" : "A"
        
        let rotinaRef = Database.database().reference().child("Rotinas")
        
        if viewState == .Adding {
            
            rotinaRef.childByAutoId().setValue(_rotina.toJSONString()) {
                (error, reference) in
                
                if let errorSaving = error {
                    print(errorSaving)
                }
                else {
                    print("Rotina Added!")
                    
                    self.arquivadoSwitch.endEditing(false)
                    self.nomeRotinaTextField.isEnabled = true
                    self.observacoesTextField.isEnabled = true
                }
            }
        }
        else if viewState == .Editing {
        
            let rotinaKeyRef =  rotinaRef.child(_rotina.autoKey)
            
            rotinaKeyRef.setValue(_rotina.toJSONString()) { (error, reference) in
                
                if let errorSaving = error {
                    print(errorSaving)
                }
                else {
                    print("Rotina Edited!")
                    
                    self.arquivadoSwitch.endEditing(false)
                    self.nomeRotinaTextField.isEnabled = true
                    self.observacoesTextField.isEnabled = true
                }
            }
        }
    }
}
