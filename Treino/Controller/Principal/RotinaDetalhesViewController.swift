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

class RotinaDetalhesViewController: BaseDetailsViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var arquivadoLabel: UILabel!
    @IBOutlet weak var arquivadoSwitch: UISwitch!
    @IBOutlet weak var nomeRotinaTextField: UITextField!
    @IBOutlet weak var observacoesTextField: UITextField!
    
    @IBOutlet weak var tableViewExercises: UITableView!

    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
    private var _rotinaExerciciosArray : [RotinaExercicios] = [RotinaExercicios]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureComponents()

        carregarModelTela()
    }
    
    func configureComponents() {
        
        configureTableView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(btnSalvarPressed)
        )
        
        if viewState == .Adding {
            
            model = Rotina()
            
            arquivadoSwitch.isHidden = true
            arquivadoLabel.isHidden = true
        }
    }
    
    func configureTableView() {
        
        tableViewExercises.delegate = self
        tableViewExercises.dataSource = self
        
        tableViewExercises.register(UINib(nibName : "CustomRotinaExercicioCell", bundle : nil), forCellReuseIdentifier: "customRotinaExercicioCell")
        
        tableViewExercises.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    func configureHeightCellTableView() {
        
        tableViewExercises.rowHeight = UITableViewAutomaticDimension
        tableViewExercises.estimatedRowHeight = 150.0
    }
    
    func recarregarTableView() {
        
        tableViewExercises.reloadData()
    }
    
    func carregarModelTela () {
        
        nomeRotinaTextField.text = _rotina.nome
        observacoesTextField.text = _rotina.observacao
        arquivadoSwitch.isOn = _rotina.status == "Q"
        
        carregarExercicios()
    }
    
    func carregarExercicios() {
        
        let rotinaExercicioDB = Database.database().reference().child("RotinaExercicios")
        
        rotinaExercicioDB.observe(.childAdded) { (snapShot) in
            
            let rotinaExercicio = RotinaExercicios(JSONString: snapShot.value as! String)!
            
            rotinaExercicio.autoKey = snapShot.key
            
            self._rotinaExerciciosArray.append(rotinaExercicio)
            
            self.configureHeightCellTableView()
            
            self.recarregarTableView()
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _rotinaExerciciosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        cell.updateUI(rotinaExercicios: _rotinaExerciciosArray[indexPath.row])
        
        return cell
        
    }
}
