//
//  HistoricoDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 10/01/18.
//  Copyright © 2018 Fernando Cortez. All rights reserved.
//

import UIKit

class HistoricoDetalhesViewController: BaseDetailsViewController {

    @IBOutlet weak var nomeRotinaLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var horaInicioLabel: UILabel!
    @IBOutlet weak var duracaoLabel: UILabel!
    @IBOutlet weak var observacaoLabel: UILabel!
    @IBOutlet weak var horaFinalLabel: UILabel!
    @IBOutlet weak var exerciciosTableView: UITableView!
    
    private var _rotinaExerciciosArray : [RotinaExercicios]?
    
    private var _treino: Treino!{
        get { return model as! Treino}
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureComponents()
        
        carregarModelTela()
    }

    private func configureComponents() {
        
        _rotinaExerciciosArray = _treino.rotina?.exercicios
        
        configureTableView()
    }
    
    private func configureTableView() {
        
        exerciciosTableView.delegate = self
        exerciciosTableView.dataSource = self
        
        exerciciosTableView.register(UINib(nibName : "CustomRotinaExercicioCell", bundle : nil), forCellReuseIdentifier: "customRotinaExercicioCell")
        
        exerciciosTableView.separatorStyle = .none
    }
    
    private func reloadTableView() {
        
        configureHeightCellTableView()
        
        exerciciosTableView.reloadData()
    }
    
    private func configureHeightCellTableView() {
        
        exerciciosTableView.rowHeight = UITableViewAutomaticDimension
        exerciciosTableView.estimatedRowHeight = 150.0
    }
    
    
    private func carregarModelTela () {
        
        nomeRotinaLabel.text = _treino.rotina?.nome
        observacaoLabel.text = _treino.observacao == "" ? "Sem observações" : _treino.observacao
        
        dataLabel.text = "Executado em \(DateFormatter.localizedString(from: _treino.dataHoraInicio, dateStyle: .medium, timeStyle: .none))"
        
        horaInicioLabel.text = "Iniciado as \(DateFormatter.localizedString(from: _treino.dataHoraInicio, dateStyle: .none, timeStyle: .medium))"
        
        if let dataFinal = _treino.dataHoraTermino {
            horaFinalLabel.text = "Finalizado as \(DateFormatter.localizedString(from: dataFinal, dateStyle: .none, timeStyle: .medium))"
        } else {
            horaFinalLabel.text = "Não Finalizado"
        }
        
        duracaoLabel.text = "Tempo Treino : \(_treino.duracao)"
        
        reloadTableView()
    }
}

extension HistoricoDetalhesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let exercicios = _rotinaExerciciosArray {
            return exercicios.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        if let exercicios = _rotinaExerciciosArray {
            cell.updateUI(withRotinaExercicios: exercicios[indexPath.row])
        }
        
        return cell
    }
}
