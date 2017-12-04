//
//  ExercicioDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase

protocol ExercicioDetalhesDelegate {
    
    func savedExercicio()
    
}

class ExercicioDetalhesViewController: BaseDetailsViewController, UITableViewDataSource, UITableViewDelegate, ParteCorpoDelegate {

    var delegate : ExercicioDetalhesDelegate?
    
    @IBOutlet weak var nomeExercicioTextField: UITextField!
    @IBOutlet weak var tableViewParteCorpo: UITableView!
    
    private var _exercicio: Exercicio!{
        get { return model as! Exercicio}
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureComponents()
        
    }
    
    func configureComponents() {
        
        configureTableView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(btnSalvarPressed)
        )
        
        if viewState == .Adding {
            
            model = Exercicio()
        }
        
        carregarModelTela()
    }
    
    func configureTableView() {
        
        tableViewParteCorpo.delegate = self
        tableViewParteCorpo.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "parteCorpoTableCell", for: indexPath)
        
        cell.textLabel?.text = "Parte Corpo"
        cell.detailTextLabel?.text = _exercicio.parteCorpo.isEmptyOrWhiteSpace ? ">" : "\(_exercicio.parteCorpo) >"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToParteCorpo", sender: nil)
        
        let detailTextLabel = tableView.cellForRow(at: indexPath)?.detailTextLabel!
        
        detailTextLabel?.text = _exercicio.parteCorpo
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToParteCorpo" {
            
            let exercicioParteCorpoVC = segue.destination as! ExercicioParteCorpoViewController
            
            exercicioParteCorpoVC.delegate = self
        }
        
    }
    
    func carregarModelTela () {
        
        nomeExercicioTextField.text = _exercicio.nomeExercicio
    }
    
    @objc func btnSalvarPressed(sender: UIBarButtonItem) {
        
        nomeExercicioTextField.isEnabled = false
        
        _exercicio.nomeExercicio = nomeExercicioTextField.text!
        
        let exercicioRef = Database.database().reference().child("Exercicios")
        
        if viewState == .Adding {
            
            exercicioRef.childByAutoId().setValue(_exercicio.toJSONString()) {
                (error, reference) in
                
                if let errorSaving = error {
                    print(errorSaving)
                }
                else {
                    print("Exercicio Added!")
                    
                    self.nomeExercicioTextField.isEnabled = true
                }
            }
        }
        else if viewState == .Editing {
            
            let exercicioKeyRef =  exercicioRef.child(_exercicio.autoKey)
            
            exercicioKeyRef.setValue(_exercicio.toJSONString()) { (error, reference) in
                
                if let errorSaving = error {
                    print(errorSaving)
                }
                else {
                    print("Exercicio Edited!")
                    
                    self.nomeExercicioTextField.isEnabled = true
                }
            }
        }
        
        delegate?.savedExercicio()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func selectedParteCorpo(parteCorpo: String) {
        
        _exercicio.parteCorpo = parteCorpo
        
        recarregarTableViewParteCorpo()
    }
    
    func recarregarTableViewParteCorpo() {
        
        tableViewParteCorpo.reloadData()
    }
}
