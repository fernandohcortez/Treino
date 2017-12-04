//
//  ExercicioViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase

class ExercicioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExercicioDetalhesDelegate {

    @IBOutlet weak var tableViewExercicio: UITableView!
    
    private var _exercicioArray : [Exercicio] = [Exercicio]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        configureAddButton()
        
        carregarExercicios()

    }
    
    func configureAddButton() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnIncluirPressed)
        )
    }
    
    @objc func btnIncluirPressed(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToExercicioDetalhes", sender: nil)
    }
    
    //MARK : tableViewRotina Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _exercicioArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        cell.updateUI(exercicio: _exercicioArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToExercicioDetalhes", sender: _exercicioArray[indexPath.row])
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
    }
    
    func configureTableView() {
        
        tableViewExercicio.delegate = self
        tableViewExercicio.dataSource = self
        
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
}
