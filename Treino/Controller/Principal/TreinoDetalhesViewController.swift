//
//  TreinoDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 07/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

protocol ExercicioTreinoDelegate {
    func finalizarTreinoButtonPressed()
    func pauseTimerButtonPressed()
    func stopTimerButtonPressed()
    func startOrResumeTimerButtonPressed()
}

class TreinoDetalhesViewController: BaseDetailsViewController {
    
    @IBOutlet weak private var nomeExercicioLabel: UILabel!
    @IBOutlet weak private var setsLabel: UILabel!
    @IBOutlet weak private var repeticoesLabel: UILabel!
    @IBOutlet weak private var imagemExercicioImageView: UIImageView!
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var finalizarTreinoButton: UIButton!
    
    @IBOutlet weak var pauseResumeTimerButton: UIButton!
    private var _lastExercise : Bool = false
    
    private var _counterTimer: Int = 0
    private var _timerPaused: Bool = false
    
    var delegate : ExercicioTreinoDelegate?

    private var _exercicio: RotinaExercicios!{
        get { return model as! RotinaExercicios}
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
        
        if let url = _exercicio.urlImagem {
            downloadImageAndUpdateImageView(imageUrl: url)
        }
    
        if _lastExercise {
            showFinalizarTreinoButton()
        }
    }
    
    private func downloadImageAndUpdateImageView(imageUrl: String) {
        
        if let url = URL(string: imageUrl) {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.imagemExercicioImageView.image = UIImage(data: data!)
                }
                
            }).resume()
        }
    }
    
    private func configureComponents() {
        configureVisibilityFinalizarTreinoButton()
    }
    
    private func configureVisibilityFinalizarTreinoButton() {
        finalizarTreinoButton.isHidden = !_lastExercise
    }
    
//    func finalizarTreino() {
//        
//        let message = _lastExercise ? "Deseja finalizar o treino?" : "Você não finalizou todos os exercícios. Deseja finalizar o treino mesmo assim?"
//        
//        Message.CreateQuestionYesNo(viewController: self, message: message, actionYes: { (action) in
//            
//            self.delegate?.stopTimer()
//            
//            self.saveDataTreino()
//            
//            self.navigationController?.popToRootViewController(animated: true)
//        })
//    }
//    
//    func cancelarTreino() {
//        
//        Message.CreateQuestionYesNo(viewController: self, message: "Deseja abandonar o treino?", actionYes: { (action) in
//            
//            self.delegate?.stopTimer()
//            
//            self.navigationController?.popToRootViewController(animated: true)
//        })
//    }
    
    @IBAction func btnPauseResumeTimerPressed(_ sender: UIButton) {
        
        if _timerPaused {
            delegate?.startOrResumeTimerButtonPressed()
        } else {
            delegate?.pauseTimerButtonPressed()
        }
    }
    
    private func updateImageButtonPauseResumeTimer() {
        
        if _timerPaused {
            pauseResumeTimerButton.setImage(#imageLiteral(resourceName: "ResumeTimer"), for: .normal)
        } else {
            pauseResumeTimerButton.setImage(#imageLiteral(resourceName: "PauseTimer"), for: .normal)
        }
    }
    
//    private func saveDataTreino() {
//
//
//        _treinoRef.childByAutoId().setValue(_treino.toJSON()) { (error, reference) in
//
//            self.enableDisableComponents(enable: true)
//
//            if let errorSaving = error {
//
//                print(errorSaving)
//            }
//            else {
//
//                print("Exercicio Updated!")
//
//                if self.viewState == .Adding {
//                    self._exercicio.autoKey = reference.key
//                }
//
//                self.delegate?.savedExercicio(exercicio: self._exercicio, viewState: self.viewState)
//
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//    }

    
    @IBAction private func btnFinalizarTreinoPressed(_ sender: UIButton) {
        delegate?.finalizarTreinoButtonPressed()
    }
    
    private  func showFinalizarTreinoButton() {
        finalizarTreinoButton.isHidden = false
    }
    
    private func updateLabelTimer() {
        timerLabel.text = _counterTimer.fromSecondsToHoursMinutesSecondsString()
    }
    
    func updateTimer(counterTimer: Int, timerPaused: Bool) {
        
        _counterTimer = counterTimer
        
        _timerPaused = timerPaused
        
        updateLabelTimer()
        
        updateImageButtonPauseResumeTimer()
    }
    
    func isLastExercise() -> Bool {
        return _lastExercise
    }
    
    func setAsLastExercise() {
        _lastExercise = true
    }
}


