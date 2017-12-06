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

class RotinaDetalhesViewController: BaseDetailsViewController, UITableViewDelegate, UITableViewDataSource, ExercicioDelegate {

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
        
        salvarDadosBancoDados()
        
        navigationController?.popViewController(animated: true)
    }
    
    func salvarDadosBancoDados() {
        
        var rotinaRef = Database.database().reference().child("Rotinas")
        
        rotinaRef = viewState == .Adding ? rotinaRef.childByAutoId() : rotinaRef.child(_rotina.autoKey)
        
        rotinaRef.runTransactionBlock(
            { (currentData) -> TransactionResult in
                
                currentData.value = self._rotina.toJSON()
                
                return .success(withValue: currentData)
                
        })  { (error, completion, snapshot) in
            
            if let errorSaving = error {
                print(errorSaving.localizedDescription)
            }
            else if completion {
                
                print("Rotina Updated!")
                
                self._rotina.autoKey = (snapshot?.key)!;
                
                self.arquivadoSwitch.endEditing(false)
                self.nomeRotinaTextField.isEnabled = true
                self.observacoesTextField.isEnabled = true
            }
        }
    }

//    func salvarDadosBancoDados() {
//
//        let rotinaRef = Database.database().reference().child("Rotinas")
//
//        if viewState == .Adding {
//
//            let rotinaAutoIdRef = rotinaRef.childByAutoId()
//
//            rotinaAutoIdRef.runTransactionBlock(
//                { (currentData) -> TransactionResult in
//
//                    currentData.value = self._rotina.toJSON()
//
//                    return .success(withValue: currentData)
//
//            })  { (error, completion, snapshot) in
//
//                if let errorSaving = error {
//                    print(errorSaving.localizedDescription)
//                }
//                else if completion {
//
//                    print("Rotina Added!")
//
//                    self._rotina.autoKey = (snapshot?.key)!;
//
//                    self.arquivadoSwitch.endEditing(false)
//                    self.nomeRotinaTextField.isEnabled = true
//                    self.observacoesTextField.isEnabled = true
//                }
//            }
//        }
//        else if viewState == .Editing {
//
//            let rotinaIdRef =  rotinaRef.child(_rotina.autoKey)
//
//            rotinaIdRef.runTransactionBlock(
//                { (currentData) -> TransactionResult in
//
//                    currentData.value = self._rotina.toJSON()
//
//                    return .success(withValue: currentData)
//
//            })  { (error, completion, snapshot) in
//
//                if let errorSaving = error {
//                    print(errorSaving.localizedDescription)
//                }
//                else if completion {
//
//                    print("Rotina Updated!")
//
//                    self.arquivadoSwitch.endEditing(false)
//                    self.nomeRotinaTextField.isEnabled = true
//                    self.observacoesTextField.isEnabled = true
//                }
//            }
//
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _rotinaExerciciosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        cell.updateUI(rotinaExercicios: _rotinaExerciciosArray[indexPath.row])
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToExercicios" {
            
            let ExercicioVC = segue.destination as! ExercicioViewController
            
            ExercicioVC.delegate = self;
            
        }
    }
    
    func selectedExercicio(exercicioArray: [Exercicio]) {
        
        for exercicio in exercicioArray {
            
            let rotinaExercicio : RotinaExercicios = RotinaExercicios()
            rotinaExercicio.nomeExercicio = exercicio.nomeExercicio
            rotinaExercicio.nomeImagemExercicio = exercicio.nomeImagemExercicio
            
            _rotinaExerciciosArray.append(rotinaExercicio)
        }
        
        recarregarTableView()
    }
}
