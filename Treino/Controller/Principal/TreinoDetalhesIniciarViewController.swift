//
//  TreinoDetalhesIniciarViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 14/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class TreinoDetalhesIniciarViewController: BaseDetailsViewController {

    @IBOutlet weak var nomeRotinaLabel: UILabel!
    @IBOutlet weak var observacaoRotinaLabel: UILabel!
    @IBOutlet weak var rotinaExerciciosTableView: UITableView!
    
    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureComponents()
        
        updateDataScreen()
    }
    
    private func configureComponents() {
        
        configureTableView()
    }
    
    func configureTableView() {
        
        rotinaExerciciosTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        rotinaExerciciosTableView.delegate = self
        rotinaExerciciosTableView.dataSource = self
    }
    
    private func updateDataScreen() {
        
        nomeRotinaLabel.text = _rotina.nome
        observacaoRotinaLabel.text = _rotina.observacao
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToTreinoDetalhes"
        {
            let treinoDetalhesPageVC = segue.destination as! TreinoDetalhesPageViewController
            
            for exercicio in _rotina.exercicios {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let treinoDetalhesVC = storyboard.instantiateViewController(withIdentifier :"treinoDetalhesViewController") as! TreinoDetalhesViewController
                
                treinoDetalhesVC.delegate = treinoDetalhesPageVC
                
                treinoDetalhesVC.model = _rotina
                
                treinoDetalhesVC.setRotinaExerciciosModel(exercicio)
                
                if exercicio === _rotina.exercicios.last! {
                    treinoDetalhesVC.setAsLastExercise()
                }
                
                treinoDetalhesPageVC.addTreinoDetalhesViewController(treinoDetalhesVC)
            }
        }
    }
}

extension TreinoDetalhesIniciarViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _rotina.exercicios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath)
        
        cell.textLabel?.text = _rotina.exercicios[indexPath.row].nomeExercicio
        
        return cell
    }
}
