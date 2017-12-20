//
//  ExercicioDetalhesViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import SVProgressHUD

protocol ExercicioDetalhesDelegate {
    func savedExercicio(exercicio: Exercicio)
}

class ExercicioDetalhesViewController: BaseDetailsViewController {

    var delegate : ExercicioDetalhesDelegate?
    
    @IBOutlet weak var nomeExercicioTextField: UITextField!
    @IBOutlet weak var tableViewParteCorpo: UITableView!
    @IBOutlet weak var imageExercicioImageView: UIImageView!
    
    private var _exercicio: Exercicio!{
        get { return model as! Exercicio}
    }
    
    private let _exercicioRef = Database.database().reference().child("Exercicios")
    
    private let _storageRef = Storage.storage().reference()

    private var _imageHasChangedByUser = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        configureComponents()
    }
    
    func configureComponents() {
        
        configureTableView()
        
        configureNavBarButtons()
        
        configureImageView()
        
        if viewState == .Adding {
            model = Exercicio()
        }
        
        updateDataScreen()
    }
    
    private func configureTableView() {
        
        tableViewParteCorpo.delegate = self
        tableViewParteCorpo.dataSource = self
    }
    
    private func configureNavBarButtons() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(btnSalvarPressed)
        )
    }
    
    private func configureImageView() {
        
        imageExercicioImageView.isUserInteractionEnabled = true
        
        imageExercicioImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagemExercicioTapped)))
    }
    
    @objc func imagemExercicioTapped() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToParteCorpo" {
            
            let exercicioParteCorpoVC = segue.destination as! ExercicioParteCorpoViewController
            
            exercicioParteCorpoVC.delegate = self
        }
    }
    
    func updateDataScreen () {
        
        nomeExercicioTextField.text = _exercicio.nomeExercicio
    }
    
    @objc func btnSalvarPressed(sender: UIBarButtonItem) {
        
        enableDisableComponents(enable: false)
        
        updateModelWithComponentsValue()
        
        checkIfExerciseNameDoesntExist {
            
            self.saveData()
        }
    }
    
    private func updateModelWithComponentsValue() {
        
        _exercicio.nomeExercicio = nomeExercicioTextField.text!
    }
    
    private func checkIfExerciseNameDoesntExist(actionSave: @escaping () -> Void) {
        
        _exercicioRef.queryOrdered(byChild: "nomeExercicio").queryEqual(toValue: _exercicio.nomeExercicio).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if !snapshot.exists() {
                actionSave()
            }
            else {
                
                self.enableDisableComponents(enable: true)

                Message.CreateAlert(viewController: self, message: "Um exercício com este nome já existe!")
            }
        })
    }

    private func saveData() {

        if (self._imageHasChangedByUser) {
            self.saveImageAndDataExercicio()
        }
        else {
            self.saveDataExercicio()
        }
    }
    
    private func saveImageAndDataExercicio() {
        
        if let uploadData = UIImagePNGRepresentation(imageExercicioImageView.image!) {
            
            let imageName = NSUUID().uuidString
            
            let storageImageRef = _storageRef.child(imageName)
            
            storageImageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                }
                else {
                    
                    if let urlDownload = metadata?.downloadURL()?.absoluteString {
                        self._exercicio.urlImagem = urlDownload
                    }
                    
                    self.saveDataExercicio()
                }
            })
        }
    }
    
    private func saveDataExercicio() {
        
        let exercicioRef = viewState == .Adding ? _exercicioRef.childByAutoId() : _exercicioRef.child(_exercicio.autoKey)
        
        exercicioRef.setValue(_exercicio.toJSON()) { (error, reference) in
            
            self.enableDisableComponents(enable: true)
            
            if let errorSaving = error {

                print(errorSaving)
            }
            else {
                
                print("Exercicio Updated!")
                
                if self.viewState == .Adding {
                    self._exercicio.autoKey = reference.key
                }
                
                self.delegate?.savedExercicio(exercicio: self._exercicio)

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func enableDisableComponents(enable: Bool) {
        
        self.navigationItem.rightBarButtonItem?.isEnabled = enable
        self.navigationItem.leftBarButtonItem?.isEnabled = enable
        self.nomeExercicioTextField.isEnabled = enable
        
        if enable {
            SVProgressHUD.dismiss()
        } else {
            SVProgressHUD.show()
        }
    }
    
    func recarregarTableViewParteCorpo() {
        
        tableViewParteCorpo.reloadData()
    }
}

extension ExercicioDetalhesViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "parteCorpoTableCell", for: indexPath)
        
        cell.textLabel?.text = "Parte Corpo"
        cell.detailTextLabel?.text = _exercicio.parteCorpo.isEmptyOrWhiteSpace ? ">" : "\(_exercicio.parteCorpo) >"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToParteCorpo", sender: nil)
        
        let detailTextLabel = tableView.cellForRow(at: indexPath)?.detailTextLabel!
        
        detailTextLabel?.text = _exercicio.parteCorpo
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ExercicioDetalhesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedPickerFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedPickerFromPicker = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedPickerFromPicker = originalImage
        }
        
        if let selectedImage = selectedPickerFromPicker {
            
            imageExercicioImageView.image = selectedImage
            
            _imageHasChangedByUser = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
}

extension ExercicioDetalhesViewController: ParteCorpoDelegate {
    
    func selectedParteCorpo(parteCorpo: String) {
        
        _exercicio.parteCorpo = parteCorpo
        
        recarregarTableViewParteCorpo()
    }
}
