//
//  Message.swift
//  Treino
//
//  Created by Fernando Cortez on 07/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import Foundation
import UIKit

public class Message
{
    public static func CreateAlert(viewController: UIViewController, message:String, actionOk: ((UIAlertAction) -> Swift.Void)? = nil)
    {
        let alert = UIAlertController(title: "Aviso", message: message, preferredStyle:UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: actionOk))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    public static func CreateQuestionYesNo(viewController: UIViewController, message:String, actionYes: ((UIAlertAction) -> Swift.Void)? = nil, actionNo: ((UIAlertAction) -> Swift.Void)? = nil)
    {
        let question = UIAlertController(title: "Pergunta", message: message, preferredStyle:UIAlertControllerStyle.alert)
        
        question.addAction(UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler:  actionYes))
        
        question.addAction(UIAlertAction(title: "Não", style: UIAlertActionStyle.default, handler: actionNo))
        
        viewController.present(question, animated: true, completion: nil)
    }
}
