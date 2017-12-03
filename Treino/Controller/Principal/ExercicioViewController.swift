//
//  ExercicioViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class ExercicioViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableViewExercicio: UITableView!
    
    private var _ExercicioArray : [Exercicio] = [Exercicio]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        carregarExercicios()

    }

    override func viewDidAppear(_ animated: Bool) {
        
        configureAddButton()
    }
    
    func configureAddButton() {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btnIncluirPressed)
        )
    }
    
    @objc func btnIncluirPressed(sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToRotinaDetalhes", sender: nil)
    }
    
    //MARK : tableViewRotina Events
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _ExercicioArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customExercicioCell", for : indexPath) as! CustomExercicioCell
        
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
        
        tableViewExercicio.register(UINib(nibName : "CustomExercicioCell", bundle : nil), forCellReuseIdentifier: "customExercicioCell")
        
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


}
