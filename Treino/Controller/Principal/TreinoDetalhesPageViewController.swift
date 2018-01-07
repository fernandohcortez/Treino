//
//  TreinoDetalhesPageViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 12/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TreinoDetalhesPageViewController: UIPageViewController {
    
    private var _subViewControllers:[UIViewController] = [UIViewController]()
    
    private var _currentViewController: TreinoDetalhesViewController!
    private var _lastPendingViewController: TreinoDetalhesViewController!
    
    private var _counterTimer = 0
    private var _timer:Timer!
    private var _timerPaused:Bool = false
    
    private var _treino : Treino!
    
    private let _treinoRef = Database.database().reference().child("Treinos")
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    func startTreino(from rotina: Rotina) {
        
        createTreino(from: rotina)
        
        createPagesForAllExercises()
    }
    
    private func createTreino(from rotina: Rotina) {
        
        _treino = Treino()
        _treino.rotina = rotina
    }
    
    private func createPagesForAllExercises() {
        
        if let rotina = _treino.rotina {

            for exercicio in rotina.exercicios {
                createPage(to: exercicio)
            }
        }
    }
    
    private func createPage(to exercicio : RotinaExercicios) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let treinoDetalhesVC = storyboard.instantiateViewController(withIdentifier :"treinoDetalhesViewController") as! TreinoDetalhesViewController
        
        treinoDetalhesVC.delegate = self
        
        treinoDetalhesVC.model = exercicio
        
        if exercicio === _treino.rotina!.exercicios.last! {
            treinoDetalhesVC.setAsLastExercise()
        }
        
        addTreinoDetalhesViewController(treinoDetalhesVC)
    }
    
    func registerBackgroundTask() {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskInvalid)
    }
    
    func endBackgroundTask() {
        
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskInvalid
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self

        configureButtons()
        
        setInitialPage()
        
        initializeTimer()
    }
    
    private func configureButtons() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnFinalizarPressed)
        )
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancelarPressed)
        )
    }

    @objc private func btnFinalizarPressed(sender: UIBarButtonItem) {
        finalizarTreino()
    }
    
    private func finalizarTreino() {
        
        let treinoFinalizado = _currentViewController.isLastExercise()
        
        let message = treinoFinalizado ? "Deseja finalizar o treino?" : "Você não finalizou todos os exercícios. Deseja finalizar o treino mesmo assim?"
        
        Message.CreateQuestionYesNo(viewController: self, message: message, actionYes: { (action) in
            
            self.endTreino(finalizado: treinoFinalizado)
        })
    }
    
    @objc private func btnCancelarPressed(sender: UIBarButtonItem) {
        cancelarTreino()
    }
    
    private func cancelarTreino() {
        
        Message.CreateQuestionYesNo(viewController: self, message: "Deseja abandonar o treino?", actionYes: { (action) in
            
            self.endTreino(finalizado: false)
        })
    }
    
    private func endTreino(finalizado: Bool) {
        
        setTreinoAsEnded(finalizado: finalizado)
        
        stopTimerButtonPressed()
        
        saveDataTreino()
    }
    
    private func setTreinoAsEnded(finalizado: Bool) {
        
        _treino.finalizado = finalizado
        _treino.timer = _counterTimer.fromSecondsToHoursMinutesSecondsString()
        _treino.dataHoraTermino = Date()
    }
    
    private func saveDataTreino() {

        enableDisableComponents(enable: false)
        
        _treinoRef.childByAutoId().setValue(_treino.toJSON()) { (error, reference) in
            
            self.enableDisableComponents(enable: true)
            
            if let error = error {
                Message.CreateAlert(viewController: self, message: error.localizedDescription)
            }
            else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func enableDisableComponents(enable: Bool) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
        self.navigationItem.leftBarButtonItem?.isEnabled = enable
        
        if enable {
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.show()
        }
    }
    
    private func addTreinoDetalhesViewController(_ treinoDetalhesViewController: TreinoDetalhesViewController) {
        _subViewControllers.append(treinoDetalhesViewController)
    }
    
    private func setInitialPage() {
        
        if let firstPage = _subViewControllers.first as? TreinoDetalhesViewController {
            
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
            
            _currentViewController = firstPage
        }
    }
    
    private func initializeTimer() {
        
        _counterTimer = Int(0)
        
        startOrResumeTimerButtonPressed()
    }
    
    @objc private func updateTimer() {
        
        if !_timerPaused {
            
            _counterTimer += 1
            
            updateTimerViewController()
        }
    }
    
    private func updateTimerViewController() {
        
        switch UIApplication.shared.applicationState {
        case .active:
            _currentViewController.updateTimer(counterTimer: _counterTimer, timerPaused: _timerPaused)
        case .background:
            print("Background time remaining = \(UIApplication.shared.backgroundTimeRemaining) seconds")
        case .inactive:
            break
        }
    }
}

extension TreinoDetalhesPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return _subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = _subViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        
        return _subViewControllers[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = _subViewControllers.index(of: viewController) ?? 0
        if currentIndex >= _subViewControllers.count-1 {
            return nil
        }
        
        return _subViewControllers[currentIndex+1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            _currentViewController = _lastPendingViewController
            
            updateTimerViewController()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let viewController = pendingViewControllers[0] as? TreinoDetalhesViewController {
            
            _lastPendingViewController = viewController
        }
    }
}

extension TreinoDetalhesPageViewController: ExercicioTreinoDelegate {
    
    func finalizarTreinoButtonPressed() {
        finalizarTreino()
    }
    
    func pauseTimerButtonPressed() {
        
        endBackgroundTask()
        
        _timer.invalidate()
        
        _timerPaused = true
        
        updateTimerViewController()
    }
    
    func startOrResumeTimerButtonPressed() {
        
        registerBackgroundTask()
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        _timerPaused = false
    }
    
    func stopTimerButtonPressed() {
        
        endBackgroundTask()
        
        _timer.invalidate()
        
        _counterTimer = Int(0)
        
        _timerPaused = true
        
        updateTimerViewController()
    }
}
