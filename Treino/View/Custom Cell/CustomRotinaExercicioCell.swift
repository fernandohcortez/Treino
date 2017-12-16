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
    
    private func downloadImageAndUpdateImageView(imageUrl: String) {

        if let url = URL(string: imageUrl) {
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    self.imageViewFotoExercicio.image = UIImage(data: data!)
                }
                
            }).resume()
        }
    }
    
    func updateUI(rotinaExercicios: RotinaExercicios) {
        
        labelNomeExercicio.text = rotinaExercicios.nomeExercicio
        labelSets.text = "\(rotinaExercicios.sets) Sets"
        labelReps.text = "\(rotinaExercicios.reps) Repetições"
        
        if let url = rotinaExercicios.urlImagem {
            downloadImageAndUpdateImageView(imageUrl: url)
        }
    }
    
    func updateUI(exercicio: Exercicio) {
        
        labelNomeExercicio.text = exercicio.nomeExercicio
        labelSets.text = ""
        labelReps.text = exercicio.parteCorpo.isEmptyOrWhiteSpace ? "Nenhum >" : "\(exercicio.parteCorpo) >"

        if let url = exercicio.urlImagem {
            downloadImageAndUpdateImageView(imageUrl: url)
        }
    }
}
