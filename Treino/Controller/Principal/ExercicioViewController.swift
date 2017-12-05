//
//  ExercicioViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase

protocol ExercicioDelegate {
    
    func selectedExercicio(exercicioArray : [Exercicio])
}

class ExercicioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExercicioDetalhesDelegate {

    @IBOutlet weak var tableViewExercicio: UITableView!

    var delegate : ExercicioDelegate?
    
    private var _exercicioArray : [Exercicio] = [Exercicio]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        configureDoneButton()
        
        carregarExercicios()

    }
    
    func configureDoneButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDonePressed)
        )
    }
    
    @objc func btnDonePressed(sender: UIBarButtonItem) {
        
        let indexPathArraySelectedExercicios = tableViewExercicio.indexPathsForSelectedRows
        
        var selectedExerciciosArray : [Exercicio] = [Exercicio]()
        
        for indexPath in indexPathArraySelectedExercicios! {
            selectedExerciciosArray.append(_exercicioArray[indexPath.row])
        }
        
        delegate?.selectedExercicio(exercicioArray: selectedExerciciosArray)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK : tableViewRotina Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _exercicioArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        cell.updateUI(exercicio: _exercicioArray[indexPath.row])
        
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let exercicioRef = Database.database().reference().child("Exercicios")
            
            let exercicioKeyRef = exercicioRef.child(_exercicioArray[indexPath.row].autoKey)
            
            exercicioKeyRef.removeValue() {
                (error, reference)  in
                
                if let errorRemoving = error {
                    print(errorRemoving)
                }
                else {
                    print("Exercicio Removed!")
                    
                    //self._exercicioArray.remove(at: indexPath.row)
                    
                    //tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let exercicioDetalhesVC = segue.destination as! ExercicioDetalhesViewController
        
        if segue.identifier == "goToExercicioDetalhes"
        {
            exercicioDetalhesVC.delegate = self
            
            if let exercicio = sender as? Exercicio {
                exercicioDetalhesVC.model = exercicio
            }
        }
    }
    
    func carregarExercicios() {
        
        let exercicioDB = Database.database().reference().child("Exercicios")
        
        exercicioDB.observe(.childAdded) { (snapShot) in
            
            let exercicio = Exercicio(JSONString: snapShot.value as! String)!
            
            exercicio.autoKey = snapShot.key
            
            self._exercicioArray.append(exercicio)
            
            self.configureHeightCellTableView()
            
            self.recarregarTableView()
        }
        
        exercicioDB.observe(.childRemoved) { (snapShot) in
                        
            //self._exercicioArray = self._exercicioArray.filter( { $0.autoKey == snapShot.key })
            
            self._exercicioArray.remove({ $0.autoKey == snapShot.key })
            
            self.configureHeightCellTableView()
            
            self.recarregarTableView()
        }
    }
    
    func configureTableView() {
        
        tableViewExercicio.delegate = self
        tableViewExercicio.dataSource = self
        
        tableViewExercicio.allowsMultipleSelection = true
        
        tableViewExercicio.register(UINib(nibName : "CustomRotinaExercicioCell", bundle : nil), forCellReuseIdentifier: "customRotinaExercicioCell")
        
        tableViewExercicio.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    func configureHeightCellTableView() {
        
        tableViewExercicio.rowHeight = UITableViewAutomaticDimension
        tableViewExercicio.estimatedRowHeight = 150.0
    }
    
    func recarregarTableView() {
        
        tableViewExercicio.reloadData()
    }
    
    func savedExercicio() {
        
        recarregarTableView()
    }
    
    @IBAction func btnNovoExercicioPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToExercicioDetalhes", sender: nil)
    }
}