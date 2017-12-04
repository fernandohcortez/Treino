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
    
    func updateUI(rotinaExercicios: RotinaExercicios) {
        
        labelNomeExercicio.text = rotinaExercicios.nomeExercicio
        labelSets.text = "\(rotinaExercicios.sets) Sets"
        labelReps.text = "\(rotinaExercicios.reps) Repetições"
        imageViewFotoExercicio.image = rotinaExercicios.nomeImagemExercicio.isEmptyOrWhiteSpace ? nil : UIImage(named: rotinaExercicios.nomeImagemExercicio)

    }
    
    func updateUI(exercicio: Exercicio) {
        
        labelNomeExercicio.text = exercicio.nomeExercicio
        labelSets.text = ""
        labelReps.text = exercicio.parteCorpo.isEmptyOrWhiteSpace ? "Nenhum >" : "\(exercicio.parteCorpo) >"
        imageViewFotoExercicio.image = exercicio.nomeImagemExercicio.isEmptyOrWhiteSpace ? nil : UIImage(named: exercicio.nomeImagemExercicio)
        
    }
}
