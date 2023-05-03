//
//  FavorisViewController.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import UIKit

class FavorisViewController: UIViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var tableFavoriteRecipe: UITableView!
    //MARK: -Properties
    private let favoriteModel = FavoriteModel()
    private var favoriteRecipes = [Recipe]()
    
    //MARK: -Override
    override func viewDidLoad() {
        super.viewDidLoad()
        tableFavoriteRecipe.dataSource = self
        tableFavoriteRecipe.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchFavorites()
        alertAddFavorite()
    }
    
    func alertAddFavorite () {
        if favoriteRecipes.count == 0 {
            displayAlert(title: "Error: Aucune recette favorite!", message: "Pour ajouter une recette comme favoris, veuillez cliquer sur l'étoile dans la page de la recette", preferredStyle: .alert)
        } else {
            tableFavoriteRecipe.reloadData()
        }
    }
    func fetchFavorites() {
        favoriteModel.fetchFavorites { [weak self] recipes in
            self?.favoriteRecipes = recipes
            self?.tableFavoriteRecipe.reloadData()
        }
    }
    
}

extension FavorisViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PresentCellFavoris") as? PresentTableViewCell else {
            return UITableViewCell()
        }
        let recipe = self.favoriteRecipes[indexPath.row]
        cell.configure(recipe: recipe)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailRecipeFav") as? RecipeDetailViewController {
            vc.recipe = self.favoriteRecipes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
extension FavorisViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118.0
    }
}


