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
    
    private var _exercicioArray = [Exercicio]()
    
    private var _exercicioByParteCorpoArray = [ExercicioByParteCorpo]()
    
    private var _editMode : Bool = false
    
    private enum ScreenMode {
        case Editing
        case Selecting
    }
    
    private var _screenMode: ScreenMode = .Selecting
    
    private var _indexExercisedRecentlyAdded: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureTableView()
        
        configureScreenAsSelectingMode()
        
        retrieveAllExercises()
    }
    
    private func setNavBarButtonAsDone() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(btnDonePressed))
    }
    
    private func setNavBarButtonAsEdit() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEditPressed))
    }
    
    private func showOrHideBackButton(show: Bool) {
        
        self.navigationItem.hidesBackButton = !show;
    }
    
    private func enableOrDisableNewExerciseButton(enable: Bool) {
        
        newExerciseButton.isEnabled = enable;
    }
    
    @objc private func btnDonePressed(sender: UIBarButtonItem) {
        
        if _screenMode == .Selecting {
            
            let selectedExericisesArray = _exercicioArray.filter{$0.selected}.sorted{$0.nomeExercicio < $1.nomeExercicio}
            
            delegate?.selectedExercicio(exercicioArray: selectedExericisesArray)
            
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
    
    private func retrieveAllExercises() {
        
        _exercicioRef.observeSingleEvent(of: .value) { (snapShot) in
            
            if let jsonDictExercicios = snapShot.value as? [String : AnyObject] {
                
                for jsonExercicio in jsonDictExercicios {
                    
                    if let jsonDictExercicio = jsonExercicio.value as? [String : AnyObject] {
                        
                        let exercicio = Exercicio(JSON: jsonDictExercicio)!
                        
                        exercicio.autoKey = jsonExercicio.key
                        
                        self._exercicioArray.append(exercicio)
                    }
                }
                
                self.reloadDataTableView()
            }
        }
    }
    
    private func configureTableView() {
        
        tableViewExercicio.delegate = self
        tableViewExercicio.dataSource = self
        
        tableViewExercicio.register(UINib(nibName : "CustomRotinaExercicioCell", bundle : nil), forCellReuseIdentifier: "customRotinaExercicioCell")
        
        tableViewExercicio.separatorStyle = .none
        
        configureHeightCellTableView()
    }
    
    private func configureHeightCellTableView() {
        
        tableViewExercicio.rowHeight = UITableViewAutomaticDimension
        tableViewExercicio.estimatedRowHeight = 150.0
    }
    
    private func populateArrayGroupedByParteCorpo() {
        
        _exercicioByParteCorpoArray.removeAll()
        
        let partesCorpo = Set<String>(_exercicioArray.map{$0.parteCorpo}).sorted{$0 < $1}
        
        for parte in partesCorpo {
            
            let exercicios = _exercicioArray.filter {$0.parteCorpo == parte}.sorted {$0.nomeExercicio < $1.nomeExercicio}
            
            _exercicioByParteCorpoArray.append(ExercicioByParteCorpo(parteCorpo: parte, exercicios: exercicios))
        }
    }
    
    private func reloadDataTableView() {
        
        populateArrayGroupedByParteCorpo()
        
        tableViewExercicio.reloadData()
        
        configureHeightCellTableView()
    }
    
    @IBAction func btnNovoExercicioPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToExercicioDetalhes", sender: nil)
    }
}

extension ExercicioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return _exercicioByParteCorpoArray[section].parteCorpo
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return _exercicioByParteCorpoArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return _exercicioByParteCorpoArray[section].exercicios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRotinaExercicioCell", for : indexPath) as! CustomRotinaExercicioCell
        
        let exercicio = _exercicioByParteCorpoArray[indexPath.section].exercicios[indexPath.row]
        
        cell.updateUI(withExercicio: exercicio)
        
        cell.accessoryType = exercicio.selected ? .checkmark : .none
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        let exercicio = _exercicioByParteCorpoArray[indexPath.section].exercicios[indexPath.row]
        
        exercicio.selected = true
        
        if _screenMode == .Selecting {
            setNavBarButtonAsDone()
        } else {
            performSegue(withIdentifier: "goToExercicioDetalhes", sender: exercicio)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if _screenMode == .Editing {
            return
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        
        let exercicio = _exercicioByParteCorpoArray[indexPath.section].exercicios[indexPath.row]
        
        exercicio.selected = false
        
        let anyRowSelected = tableViewExercicio.indexPathsForSelectedRows != nil
        
        if anyRowSelected {
            setNavBarButtonAsDone()
        } else {
            setNavBarButtonAsEdit()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let exercicio = _exercicioByParteCorpoArray[indexPath.section].exercicios[indexPath.row]
            
            let exercicioKeyRef = _exercicioRef.child(exercicio.autoKey)
            
            exercicioKeyRef.removeValue() {
                (error, reference)  in
                
                if let errorRemoving = error {
                    print(errorRemoving)
                }
                else {
                    
                    self._exercicioArray.remove { $0.autoKey == exercicio.autoKey}
                    
                    self.reloadDataTableView()
                }
            }
        }
    }
}

extension ExercicioViewController: ExercicioDetalhesDelegate {
    
    func savedExercicio(exercicio: Exercicio, viewState: BaseDetailsViewController.ViewState) {
        
        if viewState == .Editing {
            _exercicioArray.remove { $0.autoKey == exercicio.autoKey}
        }
        else if viewState == .Adding {
            
            exercicio.selected = true
            
            setNavBarButtonAsDone()
        }
        
        _exercicioArray.append(exercicio)
        
        reloadDataTableView()
    }
}

