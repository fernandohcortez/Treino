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
    
    var exercicio : RotinaExercicios!
    var lastExercise : Bool = false
    
    private var _counterTimer = 0
    private var _timer:Timer!
    
    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
//    private var _lastExercise: Bool{
//        get {
//            return _indexExercicioCorrente == _rotina.exercicios.count-1
//        }
//    }
    
    private var _indexExercicioCorrente = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureComponents()
        
        carregarModelTela()
        
        initializeTimer()
        
        startTimer()
    }
    
    func carregarModelTela () {
        
//        if _rotina.exercicios.isEmpty {
//            return;
//        }

            nomeExercicioLabel.text = exercicio.nomeExercicio
            setsLabel.text = "\(exercicio.sets) Sets"
            repeticoesLabel.text = "\(exercicio.reps) Repetições"
            
            if exercicio.nomeImagemExercicio.isEmpty {
                imagemExercicioImageView.image = nil }
            else {
                imagemExercicioImageView.image = UIImage(named : exercicio.nomeImagemExercicio)
            }
        
        
//        if _rotina.exercicios.indices.contains(_indexExercicioCorrente) {
//
//            let exercicio = _rotina.exercicios[_indexExercicioCorrente]
//
//            nomeExercicioLabel.text = exercicio.nomeExercicio
//            setsLabel.text = "\(exercicio.sets) Sets"
//            repeticoesLabel.text = "\(exercicio.reps) Repetições"
//
//            if _rotina.exercicios.first?.nomeImagemExercicio == nil {
//                imagemExercicioImageView.image = nil }
//            else {
//                imagemExercicioImageView.image = UIImage(named : exercicio.nomeImagemExercicio)
//            }
//        }
    }
    
    private func configureComponents() {
        
        configureTopButtons()
    }
    
    private func configureTopButtons() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnFinalizarPressed)
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancelarPressed)
        )
    }
    
    @objc private func btnFinalizarPressed(sender: UIBarButtonItem) {
        
        finalizarTreino()
    }
    
    func finalizarTreino() {
        
        let message = lastExercise ? "Deseja finalizar o treino?" : "Você não finalizou todos os exercícios. Deseja finalizar o treino mesmo assim?"
        
        Message.CreateQuestionYesNo(viewController: self, message: message, actionYes: { (action) in
            
            self.salvarDadosBancoDados()
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc private func btnCancelarPressed(sender: UIBarButtonItem) {
        
        Message.CreateQuestionYesNo(viewController: self, message: "Deseja abandonar o treino?", actionYes: { (action) in
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    
    
    private func salvarDadosBancoDados() {
        
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
    
    @IBAction private func btnFinalizarTreinoPressed(_ sender: UIButton) {
        
        finalizarTreino()
    }
}

extension TreinoDetalhesViewController {
    
    private func initializeTimer() {
        
        _counterTimer = Int(0)
        
        updateLabelTimer()
    }
    
    private func updateLabelTimer() {
        
        timerLabel.text = _counterTimer.fromSecondsToTimeString()
        
        _counterTimer += 1
    }
    
    private func startTimer() {
        
        //btnStartStop.setImage(#imageLiteral(resourceName: "Stop"), for: .normal)
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        
        //btnStartStop.setImage(#imageLiteral(resourceName: "Start"), for: .normal)
        
        _timer.invalidate()
        
        initializeTimer()
    }
    
    @objc private func updateTimer() {
        
        if _counterTimer > 0 {
            updateLabelTimer()
        } else {
            stopTimer()
        }
    }
}
