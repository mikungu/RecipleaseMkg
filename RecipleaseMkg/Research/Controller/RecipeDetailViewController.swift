//
//  RecipeDetailViewController.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 16/03/23.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    //MARK: -Outlets
    
    @IBOutlet weak var imageRecipe: UIImageView!
    
    @IBOutlet weak var titleRecipe: UILabel!
    
    @IBOutlet weak var noteYieldLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBOutlet weak var getDirectionButton: UIButton!
    
    //MARK: -Properties
    var recipe: Recipe?
    
    //MARK: -Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let imageUrl = recipe?.image {
            imageRecipe.downloaded(from: imageUrl)
        } else {
            imageRecipe.image = UIImage(named: "frying.pan")
        }
        titleRecipe.text = recipe?.label
        noteYieldLabel.text = " \(recipe?.yield ?? 0) p"
        timeLabel.text = " \(recipe?.totalTime ?? 0) min"
        
        labelAccessibility()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let isRecipeFavorite = self.checkIfFavorite()
        self.favoriteButton.tintColor = .white
        if isRecipeFavorite {
            self.favoriteButton.tintColor = .orange
        }
    }
    
    //MARK: -Actions
    
    @IBAction func makeFavorite(_ sender: Any) {
        guard let recipe = recipe else { return }
        let isFavorite = FavoriteModel.shared.checkIfFavorite(recipeName: recipe.label)
        if isFavorite {
            FavoriteModel.shared.deleteFromFavorite(recipeName: recipe.label)
            self.favoriteButton.tintColor = .white
            
        } else {
            FavoriteModel.shared.addFavorite(recipe: recipe)
            self.favoriteButton.tintColor = .orange
        }
    }
    
    
    @IBAction func GetDirectionButton(_ sender: Any) {
        buttonIsClicked()
    }
    
    //MARK: -Publics
    func checkIfFavorite() -> Bool {
            guard let recipeName = self.recipe?.label else { return false }
            return FavoriteModel.shared.checkIfFavorite(recipeName: recipeName)
        }
        
        func deleteFromFavorite() {
            guard let recipeName = self.recipe?.label else { return }
            FavoriteModel.shared.deleteFromFavorite(recipeName: recipeName)
        }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            UIApplication.shared.open(url)
        }
    }
    func buttonIsClicked() {
        open(scheme: recipe?.url ?? "" )
    }
    
    func labelAccessibility () {
        titleRecipe.isAccessibilityElement = true
        titleRecipe.accessibilityHint = " recipe title "
        
        noteYieldLabel.isAccessibilityElement = true
        noteYieldLabel.accessibilityHint = " the note that has the recipe so far "
        
        timeLabel.isAccessibilityElement = true
        timeLabel.accessibilityHint = " the indicative time of cooking "
        
        getDirectionButton.isAccessibilityElement = true
        getDirectionButton.accessibilityHint = " redarection to the web page explaining how to make the recipe "
    }
    
}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipe?.ingredientLines.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = "- " + (recipe?.ingredientLines[indexPath.row] ?? "")
        
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont (name: "Chalkduster", size: 18)
        return cell
    }
    
}

