//
//  ExercicioViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase

protocol ExercicioDelegate {
    func selectedExercicio(exercicioArray : [Exercicio])
}

class ExercicioViewController: UIViewController {

    @IBOutlet weak var tableViewExercicio: UITableView!
    @IBOutlet weak var newExerciseButton: UIButton!
    
    var delegate : ExercicioDelegate?
    
    private let _exercicioRef = Database.database().reference().child("Exercicios")

    private var _exercicioArray : [Exercicio] = [Exercicio]()
    
    private var _editMode : Bool = false
    
    private enum ScreenMode {
        case Editing
        case Selecting
    }
    
    private var _screenMode: ScreenMode = .Selecting
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        configureScreenAsSelectingMode()
        
        addObserversRef()
    }
    
    func setNavBarButtonAsDone() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDonePressed)
        )
    }
    
    private func setNavBarButtonAsEdit() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditPressed)
        )
    }
    
    private func showOrHideBackButton(show: Bool) {
        
        self.navigationItem.hidesBackButton = !show;
    }
    
    private func enableOrDisableNewExerciseButton(enable: Bool) {
        
        newExerciseButton.isEnabled = enable;
    }
    
    @objc private func btnDonePressed(sender: UIBarButtonItem) {
        
        if _screenMode == .Selecting {
            
            if let indexPathArraySelectedExercicios = tableViewExercicio.indexPathsForSelectedRows {
                
                var selectedExerciciosArray : [Exercicio] = [Exercicio]()
                
                for indexPath in indexPathArraySelectedExercicios {
                    selectedExerciciosArray.append(_exercicioArray[indexPath.row])
                }
                
                delegate?.selectedExercicio(exercicioArray: selectedExerciciosArray)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        else if _screenMode == .Editing {
            
            configureScreenAsSelectingMode()
        }
    }
    
    @objc private func btnEditPressed(sender: UIBarButtonItem) {
        
        configureScreenAsEditingMode()
    }
    
    private func configureScreenAsEditingMode() {
        
        _screenMode = .Editing
        
        showOrHideBackButton(show: false)
        
        enableOrDisableNewExerciseButton(enable: false)
        
        setNavBarButtonAsDone()
        
        tableViewExercicio.allowsMultipleSelection = false
        
        tableViewExercicio.allowsSelectionDuringEditing = true
        
        tableViewExercicio.setEditing(true, animated: true)
    }
    
    private func configureScreenAsSelectingMode() {
        
        _screenMode = .Selecting
        
        showOrHideBackButton(show: true)
        
        enableOrDisableNewExerciseButton(enable: true)
        
        setNavBarButtonAsEdit()
        
        tableViewExercicio.allowsMultipleSelection = true
        
        tableViewExercicio.allowsSelectionDuringEditing = false
        
        tableViewExercicio.setEditing(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let exercicioDetalhesVC = segue.destination as! ExercicioDetalhesViewController
        
        if segue.identifier == "goToExercicioDetalhes"
        {
            exercicioDetalhesVC.delegate = self
            
            if let exercicio = sender as? Exercicio {
                exercicioDetalhesVC.model = exercicio
            }
        }
    }
    
    func addObserversRef() {
			
        _exercicioRef.observe(.childAdded) { (snapShot) in
            
            if let jsonArray = snapShot.value as? [String : AnyObject] {
                
                let exercicio = Exercicio(JSON: jsonArray)!
                
                exercicio.autoKey = snapShot.key
                
                self._exercicioArray.append(exercicio)
                
                self._exercicioArray.sort{$0.nomeExercicio < $1.nomeExercicio}
            }
            
            self.recarregarTableView()
        }
        
        _exercicioRef.observe(.childRemoved) { (snapShot) in
            
            self._exercicioArray.remove({ $0.autoKey == snapShot.key })
            
            self.recarregarTableView()
        }
    }
    
    private func configureTableView() {
        
        tableViewExercicio.delegate = self
        tableViewExercicio.dataSource = self
        
        tableViewExercicio.register(UINib(nibName : "CustomRotinaExercicioCell", bundle : nil), forCellReuseIdentifier: "customRotinaExercicioCell")
        
        tableViewExercicio.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    func configureHeightCellTableView() {
        
        tableViewExercicio.rowHeight = UITableViewAutomaticDimension
        tableViewExercicio.estimatedRowHeight = 150.0
    }
    
    func recarregarTableView() {
        
        tableViewExercicio.reloadData()
        
        configureHeightCellTableView()
    }
    
    @IBAction func btnNovoExercicioPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToExercicioDetalhes", sender: nil)
    }
}

extension ExercicioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return _exercicioArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        cell.updateUI(withExercicio: _exercicioArray[indexPath.row])
        
        cell.accessoryType = cell.isSelected ? .checkmark : .none
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        if _screenMode == .Selecting {
            setNavBarButtonAsDone()
        } else {
            performSegue(withIdentifier: "goToExercicioDetalhes", sender: _exercicioArray[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if _screenMode == .Editing {
            return
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        let anyRowSelected = tableViewExercicio.indexPathsForSelectedRows != nil
        
        if anyRowSelected {
            setNavBarButtonAsDone()
        } else {
            setNavBarButtonAsEdit()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let exercicioKeyRef = _exercicioRef.child(_exercicioArray[indexPath.row].autoKey)
            
            exercicioKeyRef.removeValue() {
                (error, reference)  in
                
                if let errorRemoving = error {
                    print(errorRemoving)
                }
                else {
                    print("Exercicio Removed!")
                }
            }
        }
    }
}

extension ExercicioViewController: ExercicioDetalhesDelegate {
    
    func savedExercicio() {
        recarregarTableView()
    }
}

