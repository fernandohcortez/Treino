//
//  TreinoDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 07/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class TreinoDetalhesViewController: BaseDetailsViewController {
    
    @IBOutlet weak var nomeExercicioLabel: UILabel!
    @IBOutlet weak var setsLabel: UILabel!
    @IBOutlet weak var repeticoesLabel: UILabel!
    @IBOutlet weak var imagemExercicioImageView: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var proximoExercicioButton: UIButton!
    
    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
    private var _indexExercicioCorrente = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureComponents()
        
        carregarModelTela()
    }
    
    func carregarModelTela () {
        
        if _rotina.exercicios.isEmpty {
            return;
        }
        
        if _rotina.exercicios.indices.contains(_indexExercicioCorrente) {
            
            let exercicio = _rotina.exercicios[_indexExercicioCorrente]
            
            nomeExercicioLabel.text = exercicio.nomeExercicio
            setsLabel.text = "\(exercicio.sets) Sets"
            repeticoesLabel.text = "\(exercicio.reps) Repetições"
            
            if _rotina.exercicios.first?.nomeImagemExercicio == nil {
                imagemExercicioImageView.image = nil }
            else {
                imagemExercicioImageView.image = UIImage(named : exercicio.nomeImagemExercicio)
            }
        }
        
        let ultimoExercicio = _indexExercicioCorrente == _rotina.exercicios.count-1
        
        proximoExercicioButton.isHidden = ultimoExercicio
    }
    
    func configureComponents() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnFinalizarPressed)
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancelarPressed)
        )
    }
    
    @objc func btnFinalizarPressed(sender: UIBarButtonItem) {
        
        finalizarTreino()
    }
    
    func finalizarTreino() {
        
        Message.CreateQuestionYesNo(viewController: self, message: "Deseja finalizar o treino?", actionYes: { (action) in
            
            //        arquivadoSwitch.endEditing(true)
            //        nomeRotinaTextField.isEnabled = false
            //        observacoesTextField.isEnabled = false
            //
            //        _rotina.nome = nomeRotinaTextField.text!
            //        _rotina.observacao = observacoesTextField.text!
            //        _rotina.status = arquivadoSwitch.isOn ? "Q" : "A"
            //        _rotina.exercicios = _rotinaExerciciosArray
            
            self.salvarDadosBancoDados()
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc func btnCancelarPressed(sender: UIBarButtonItem) {
        
        Message.CreateQuestionYesNo(viewController: self, message: "Deseja abandonar o treino?", actionYes: { (action) in
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func salvarDadosBancoDados() {
        
//        let rotinaRef = viewState == .Adding ? _rotinaRef.childByAutoId() : _rotinaRef.child(_rotina.autoKey)
//
//        rotinaRef.runTransactionBlock(
//            { (currentData) -> TransactionResult in
//
//                currentData.value = self._rotina.toJSON()
//
//                return .success(withValue: currentData)
//
//        })  { (error, completion, snapshot) in
//
//            if let errorSaving = error {
//                print(errorSaving.localizedDescription)
//            }
//            else if completion {
//
//                print("Rotina Updated!")
//
//                self._rotina.autoKey = (snapshot?.key)!;
//
//                self.arquivadoSwitch.endEditing(false)
//                self.nomeRotinaTextField.isEnabled = true
//                self.observacoesTextField.isEnabled = true
//            }
//        }
    }
    
    @IBAction func btnFinalizarTreinoPressed(_ sender: UIButton) {
        
        finalizarTreino()
    }
    
    @IBAction func btnProximoExercicioPressed(_ sender: UIButton) {
        
        _indexExercicioCorrente+=1
        
        carregarModelTela()
    }
}
