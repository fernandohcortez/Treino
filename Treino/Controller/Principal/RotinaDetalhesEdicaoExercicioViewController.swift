//
//  RotinaDetalhesEdicaoExercicioViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 14/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

protocol ExerciseEditingDelegate {
    func savedEditingExercise (rotinaExercicio : RotinaExercicios)
}

class RotinaDetalhesEdicaoExercicioViewController: BaseDetailsViewController {

    @IBOutlet weak var nomeExercicioLabel: UILabel!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    let buttonCommaKeyPad = UIButton(type: UIButtonType.custom)
    
    var delegate : ExerciseEditingDelegate?
    
    private var _rotinaExercicio: RotinaExercicios!{
        get { return model as! RotinaExercicios}
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        configureComponents()

        updateDataScreen()
    }
    
    private func configureComponents() {
        
        repsTextField.delegate = self
        
        configureNavBarButtons()
        
        configureButtonCommaKeyPad()
    }
    
    private func configureNavBarButtons() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancelarPressed)
        )
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(btnSalvarPressed)
        )
    }
    
    @objc func btnSalvarPressed(sender: UIBarButtonItem) {
        
        _rotinaExercicio.sets = Int(setsTextField.text!)!
        _rotinaExercicio.reps = repsTextField.text!
        
        delegate?.savedEditingExercise(rotinaExercicio: _rotinaExercicio)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCancelarPressed(sender: UIBarButtonItem) {
        
       navigationController?.popViewController(animated: true)
    }
    
    func updateDataScreen () {
        
        nomeExercicioLabel.text = _rotinaExercicio.nomeExercicio
        setsTextField.text = String(_rotinaExercicio.sets)
        repsTextField.text = _rotinaExercicio.reps
    }
}

// Add extra button comma to a keypad
extension RotinaDetalhesEdicaoExercicioViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    @objc func keyboardWillShow(_ note : Notification) -> Void {
        
        DispatchQueue.main.async { () in
            
            self.buttonCommaKeyPad.isHidden = false
            let keyBoardWindow = UIApplication.shared.windows.last
            self.buttonCommaKeyPad.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
            keyBoardWindow?.addSubview(self.buttonCommaKeyPad)
            keyBoardWindow?.bringSubview(toFront: self.buttonCommaKeyPad)
            UIView.animate(withDuration: (((note.userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
            }, completion: { (complete) in
                print("Complete")
            })
        }
    }
    
    private func configureButtonCommaKeyPad() {
        
        buttonCommaKeyPad.setTitle(",", for: UIControlState())
        buttonCommaKeyPad.setTitleColor(UIColor.black, for: UIControlState())
        buttonCommaKeyPad.frame = CGRect(x: 0, y: 163, width: 106, height: 53)
        buttonCommaKeyPad.adjustsImageWhenHighlighted = false
        buttonCommaKeyPad.addTarget(self, action: #selector(self.btnCommaKeyPadPressed(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func btnCommaKeyPadPressed(_ sender : UIButton) {
        
        repsTextField.text = repsTextField.text!+","
    }
}
