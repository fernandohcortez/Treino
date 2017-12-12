//
//  TreinoDetalhesPageViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 12/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class TreinoDetalhesPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var subViewControllers:[UIViewController] = [UIViewController]()
    
    private var _currentViewController: TreinoDetalhesViewController!
    
    //private var _currentViewController = -1
    
    private var _lastViewController: Bool {
        get {
            return subViewControllers.last! === _currentViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        configureSwipeGestureScreen()

        setInitialPage()
    }
    
    private func setInitialPage() {
        
        if let firstPage = subViewControllers.first {
            
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func movePage(direction: UIPageViewControllerNavigationDirection) {
        
        let nextIndexViewController = subViewControllers.index(of: _currentViewController)! + 1
        
        if nextIndexViewController > subViewControllers.count+1 {
            return
        }
        
        setViewControllers([subViewControllers[nextIndexViewController]], direction: direction, animated: true, completion: nil)
    }
    
//    required init?(coder: NSCoder) {
//
//        super.init(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
//    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        
        _currentViewController = subViewControllers[currentIndex-1] as! TreinoDetalhesViewController
        
        return subViewControllers[currentIndex-1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = subViewControllers.index(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count-1 {
            return nil
        }
        
        _currentViewController = subViewControllers[currentIndex+1] as! TreinoDetalhesViewController
        
        return subViewControllers[currentIndex+1]
    }
    
    private func configureSwipeGestureScreen() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToNextExercise))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeToPreviousExercise))
        swipeDown.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func swipeToNextExercise(sender: UIBarButtonItem) {
        
        moveExercise(direction: .next)
    }
    
    @objc private func swipeToPreviousExercise(sender: UIBarButtonItem) {
        
        moveExercise(direction: .previous)
    }
    
    private enum Direction {
        case previous
        case next
    }
    
    private func moveExercise(direction: Direction) {
        
        if _lastViewController {
            
            if direction == .next {
                
                _currentViewController.finalizarTreino()
                return
            }
        }
        
        if direction == .next {
            movePage(direction: .forward)
        } else if direction == .previous {
            movePage(direction: .reverse)
        }
        
        _currentViewController.carregarModelTela()
    }
}
