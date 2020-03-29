//
//  PokemonListTableViewController.swift
//  Pokemon-Operations
//
//  Created by Chad Rutherford on 3/23/20.
//

import UIKit

class PokemonListTableViewController: UITableViewController {

    // MARK: - Properties

    let apiController = APIController()
    var pokemon = [PokemonResult]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiController.fetchAllPokemon { result in
            switch result {
            case .success(let pokemon):
                self.pokemon = pokemon
                self.tableView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
	
	// MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Segues.showPokemonDetailSegue:
            guard let pokemonDetailVC = segue.destination as? PokemonDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            pokemonDetailVC.apiController = apiController
            let seguePokemon = pokemon[indexPath.row]
            pokemonDetailVC.pokemonResult = seguePokemon
        default:
            break
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PokemonCell.reuseID, for: indexPath) as? PokemonCell else { return UITableViewCell() }
        let aPokemon = pokemon[indexPath.row]
        cell.pokemon = aPokemon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.showPokemonDetailSegue, sender: self)
    }
}
