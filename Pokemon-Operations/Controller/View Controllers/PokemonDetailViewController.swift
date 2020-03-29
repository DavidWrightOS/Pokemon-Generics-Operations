//
//  PokemonDetailViewController.swift
//  Pokemon-Operations
//
//  Created by David Wright on 3/23/20.
//

import UIKit

class PokemonDetailViewController: UIViewController {

    // MARK: - Properties

    var apiController: APIController?
    var pokemonResult: PokemonResult? {
        didSet {
            fetchDetails()
        }
    }
    var pokemonQueue = OperationQueue()
    
    // MARK: - Outlets

    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var abilitiesLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func fetchDetails() {
        guard let pokemon = pokemonResult, let apiController = apiController else { return }
        apiController.fetchPokemon(for: pokemon.url) { result in
            switch result {
            case .success(let pokemon):
                self.updateViews(with: pokemon)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateViews(with pokemon: Pokemon) {
        
        // Version 1 - Without Operation and Queues
        
//        guard let apiController = apiController else { return }
//        heightLabel.text = "\(pokemon.height)"
//        weightLabel.text = "\(pokemon.weight)"
//        abilitiesLabel.text = "\(pokemon.abilities)"
//        typesLabel.text = "\(pokemon.types)"
//
//        // Fetch and display image
//        apiController.fetchImage(for: pokemon.imageURL) { result in
//            switch result {
//            case .success(let image):
//                self.pokemonImageView.image = image
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        // Version 2 - Using Operations
        
        guard let apiController = apiController else { return }
        let imageFetchOperation = ImageFetchOperation(apiController: apiController, url: pokemon.imageURL)
        let completionOperation = BlockOperation {
            guard let image = imageFetchOperation.image else { return }
            self.pokemonImageView.image = image
            self.heightLabel.text = "\(pokemon.height)"
            self.weightLabel.text = "\(pokemon.weight)"
            self.abilitiesLabel.text = "\(pokemon.abilities)"
            self.typesLabel.text = "\(pokemon.types)"
        }
        
        completionOperation.addDependency(imageFetchOperation)
        pokemonQueue.addOperation(imageFetchOperation)
        OperationQueue.main.addOperation(completionOperation)
    }
}
