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
    
    @IBOutlet weak var tableViewExercises: UITableView!

    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
    private let _rotinaRef = Database.database().reference().child("Rotinas")
    
    private let _rotinaExercicioRef = Database.database().reference().child("RotinaExercicios")
    
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
        
        //configureHeightCellTableView()
    }
    
    func configureHeightCellTableView() {
        
        tableViewExercises.rowHeight = UITableViewAutomaticDimension
        tableViewExercises.estimatedRowHeight = 150.0
    }
    
    func recarregarTableView() {
        
        configureHeightCellTableView()
        
        tableViewExercises.reloadData()
    }
    
    func carregarModelTela () {
        
        nomeRotinaTextField.text = _rotina.nome
        observacoesTextField.text = _rotina.observacao
        arquivadoSwitch.isOn = _rotina.status == "Q"
        
        _rotinaExerciciosArray = _rotina.exercicios
        
        recarregarTableView()
        
//        addObserversRef()
    }
    
//    func addObserversRef() {
//
//        _rotinaExercicioRef.observe(.childAdded) { (snapShot) in
//
//            let rotinaExercicio = RotinaExercicios(JSONString: snapShot.value as! String)!
//
//            rotinaExercicio.autoKey = snapShot.key
//
//            self._rotinaExerciciosArray.append(rotinaExercicio)
//
//            self.recarregarTableView()
//        }
//
//        _rotinaExercicioRef.observe(.childRemoved) { (snapShot) in
//
//            self._rotinaExerciciosArray.remove({ $0.autoKey == snapShot.key })
//
//            self.recarregarTableView()
//        }
//    }
    
    @objc func btnSalvarPressed(sender: UIBarButtonItem) {
        
        arquivadoSwitch.endEditing(true)
        nomeRotinaTextField.isEnabled = false
        observacoesTextField.isEnabled = false
        
        _rotina.nome = nomeRotinaTextField.text!
        _rotina.observacao = observacoesTextField.text!
        _rotina.status = arquivadoSwitch.isOn ? "Q" : "A"
        _rotina.exercicios = _rotinaExerciciosArray
        
        salvarDadosBancoDados()
        
        navigationController?.popViewController(animated: true)
    }
    
    func salvarDadosBancoDados() {
        
        let rotinaRef = viewState == .Adding ? _rotinaRef.childByAutoId() : _rotinaRef.child(_rotina.autoKey)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToExercicios" {
            
            let ExercicioVC = segue.destination as! ExercicioViewController
            
            ExercicioVC.delegate = self;
        }
    }
}

extension RotinaDetalhesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _rotinaExerciciosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        cell.updateUI(rotinaExercicios: _rotinaExerciciosArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            _rotinaExerciciosArray.remove(at: indexPath.row)
            
            recarregarTableView()
        }
        
    }
}

extension RotinaDetalhesViewController : ExercicioDelegate {
    
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


