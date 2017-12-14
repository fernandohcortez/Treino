//
//  TreinoDetalhesPageViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 12/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class TreinoDetalhesPageViewController: UIPageViewController {
    
    private var _subViewControllers:[UIViewController] = [UIViewController]()
    
    private var _currentViewController: TreinoDetalhesViewController!
    private var _lastPendingViewController: TreinoDetalhesViewController!
    
    private var _counterTimer = 0
    private var _timer:Timer!
    private var _timerPaused:Bool = false
    
    //    required init?(coder: NSCoder) {
    //
    //        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    //    }
    
//    private var _lastViewController: Bool {
//        get {
//            return _subViewControllers.last! === _currentViewController
//        }
//    }
    
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
        
        _currentViewController.finalizarTreino()
    }
    
    @objc private func btnCancelarPressed(sender: UIBarButtonItem) {
        
        Message.CreateQuestionYesNo(viewController: self, message: "Deseja abandonar o treino?", actionYes: { (action) in
            
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func addTreinoDetalhesViewController(_ treinoDetalhesViewController: TreinoDetalhesViewController) {
        
        _subViewControllers.append(treinoDetalhesViewController)
    }
    
    private func setInitialPage() {
        
        if let firstPage = _subViewControllers.first as? TreinoDetalhesViewController {
            
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
            
            _currentViewController = firstPage
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

extension TreinoDetalhesPageViewController: PauseResumeTimerTreinoDelegate {
    
    private func initializeTimer() {
        
        _counterTimer = Int(0)
        
        startOrResumeTimer()
    }

    @objc private func updateTimer() {
        
        if !_timerPaused {
            
            _counterTimer += 1
            
            updateTimerViewController()
        }
    }
    
    private func updateTimerViewController() {
        
        _currentViewController.updateTimer(counterTimer: _counterTimer, timerPaused: _timerPaused)
    }
    
    func pauseTimer() {
        
        _timer.invalidate()
        
        _timerPaused = true
        
        updateTimerViewController()
    }
    
    func startOrResumeTimer() {
        
        _timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        _timerPaused = false
        
        //updateTimerViewController()
    }
    
    func stopTimer() {
        
        _timer.invalidate()
        
        _counterTimer = Int(0)
        
        _timerPaused = true
        
        updateTimerViewController()
    }
}
