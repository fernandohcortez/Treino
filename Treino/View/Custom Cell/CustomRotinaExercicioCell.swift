//
//  CustomRotinaExercicioCell.swift
//  Treino
//
//  Created by Fernando Cortez on 03/12/17.
//  Copyright © 2017 Fernando Cortez. All rights reserved.
//

import UIKit

class CustomRotinaExercicioCell: UITableViewCell {

    @IBOutlet weak var imageViewFotoExercicio: UIImageView!
    @IBOutlet weak var labelNomeExercicio: UILabel!
    @IBOutlet weak var labelSets: UILabel!
    @IBOutlet weak var labelReps: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateUI(withRotinaExercicios: RotinaExercicios) {
        
        labelNomeExercicio.text = withRotinaExercicios.nomeExercicio
        labelSets.text = "\(withRotinaExercicios.sets) Sets"
        labelReps.text = "\(withRotinaExercicios.reps) Repetições"
        
        imageViewFotoExercicio.loadImageUsingCache(withImageUrlString: withRotinaExercicios.urlImagem)
    }
    
    func updateUI(withExercicio: Exercicio) {
        
        labelNomeExercicio.text = withExercicio.nomeExercicio
        labelSets.text = ""
        labelReps.text = withExercicio.parteCorpo.isEmptyOrWhiteSpace ? "Nenhum" : withExercicio.parteCorpo
        
        imageViewFotoExercicio.loadImageUsingCache(withImageUrlString: withExercicio.urlImagem)
    }
}
