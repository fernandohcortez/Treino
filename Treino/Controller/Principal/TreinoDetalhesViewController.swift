//
//  TreinoDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 07/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

protocol PauseResumeTimerTreinoDelegate {
    func pauseTimer()
    func stopTimer()
    func startOrResumeTimer()
}

class TreinoDetalhesViewController: BaseDetailsViewController {
    
    @IBOutlet weak private var nomeExercicioLabel: UILabel!
    @IBOutlet weak private var setsLabel: UILabel!
    @IBOutlet weak private var repeticoesLabel: UILabel!
    @IBOutlet weak private var imagemExercicioImageView: UIImageView!
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var finalizarTreinoButton: UIButton!
    
    @IBOutlet weak var pauseResumeTimerButton: UIButton!
    private var _exercicio : RotinaExercicios!
    private var _lastExercise : Bool = false
    
    private var _counterTimer: Int = 0
    private var _timerPaused: Bool = false
    
    var delegate : PauseResumeTimerTreinoDelegate?
    
    private var _rotina: Rotina!{
        get { return model as! Rotina}
    }
    
    private var _indexExercicioCorrente = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        updateDataScreen()
    }
    
    private func updateDataScreen () {
        
        nomeExercicioLabel.text = _exercicio.nomeExercicio
        setsLabel.text = "\(_exercicio.sets) Sets"
        repeticoesLabel.text = "\(_exercicio.reps) Repetições"
        
//        if _exercicio.nomeImagemExercicio.isEmpty {
//            imagemExercicioImageView.image = nil }
//        else {
//            imagemExercicioImageView.image = UIImage(named : _exercicio.nomeImagemExercicio)
//        }
        
        if _lastExercise {
            
            showFinalizarTreinoButton()
        }
    }
    
    private func configureComponents() {

        configureVisibilityFinalizarTreinoButton()
    }
    
    private func configureVisibilityFinalizarTreinoButton() {

        finalizarTreinoButton.isHidden = !_lastExercise
    }
    
    func finalizarTreino() {
        
        let message = _lastExercise ? "Deseja finalizar o treino?" : "Você não finalizou todos os exercícios. Deseja finalizar o treino mesmo assim?"
        
        Message.CreateQuestionYesNo(viewController: self, message: message, actionYes: { (action) in
            
            self.delegate?.stopTimer()
            
            self.salvarDadosBancoDados()
            
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func cancelarTreino() {
        
        Message.CreateQuestionYesNo(viewController: self, message: "Deseja abandonar o treino?", actionYes: { (action) in
            
            self.delegate?.stopTimer()
            
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    @IBAction func btnPauseResumeTimerPressed(_ sender: UIButton) {
        
        if _timerPaused {
            delegate?.startOrResumeTimer()
        } else {
            delegate?.pauseTimer()
        }
    }
    
    private func updateImageButtonPauseResumeTimer() {
        
        if _timerPaused {
            pauseResumeTimerButton.setImage(#imageLiteral(resourceName: "ResumeTimer"), for: .normal)
        } else {
            pauseResumeTimerButton.setImage(#imageLiteral(resourceName: "PauseTimer"), for: .normal)
        }
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
    
   private  func showFinalizarTreinoButton() {
        
        finalizarTreinoButton.isHidden = false
    }
    
    private func updateLabelTimer() {
        
        timerLabel.text = _counterTimer.fromSecondsToTimeString()
    }
    
    func updateTimer(counterTimer: Int, timerPaused: Bool) {
        
        _counterTimer = counterTimer
        
        _timerPaused = timerPaused
        
        updateLabelTimer()
        
        updateImageButtonPauseResumeTimer()
    }
    
    func setAsLastExercise() {
        
        _lastExercise = true
    }
    
    func setRotinaExerciciosModel(_ exercicio: RotinaExercicios) {
        
        _exercicio = exercicio
    }
}


