//
//  BaseDetailsViewController.swift
//  Treino
//
//  Created by Fernando Cortez on 02/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class BaseDetailsViewController: UIViewController {

    enum ViewState {
        case Adding
        case Editing
    }
    
    var viewState : ViewState!
    
    private var _model: BaseModel?
    var model: BaseModel?{
        get { return _model}
        set { _model = newValue}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if model == nil {
            viewState = .Adding
        }
        else {
            viewState = .Editing
        }
    }
    
    

}
