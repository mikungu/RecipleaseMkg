//
//  IngredientViewController.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import UIKit

class IngredientViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var ingredientField: UITextField!
    
    @IBOutlet weak var ingredientSavedField: UITextView!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: - Properties
    private let ingredientModel = IngredientModel.shared
    var searchModel = SearchModel ()
    
    //MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getIngredientsPlus()
        
        buttonsAccessibily()
    }
    
    //MARK: - Actions
    
    @IBAction func dismissKeyBoard(_ sender: UITapGestureRecognizer) {
        ingredientField.resignFirstResponder()
    }
    
    @IBAction func addButton(_ sender: Any) {
        addIngredient()
    }
    
    @IBAction func clearButton(_ sender: Any) {
        ingredientSavedField.text = nil
        ingredientModel.deleteIngredient(callback: { ingredients in
            //var ingredientText = ingredients
        })
    }
    
    @IBAction func searchForRecipe(_ sender: Any) {
        
        if ingredientSavedField.hasText == false {
            displayAlert(title: "Oups, Aucun ingredient saisi!", message: "Veuillez entrer un ingredient!", preferredStyle: .alert)
        }else {
            
            performSegue(withIdentifier: "ShowRecipeList", sender: nil)
        }
        
    }
    
    func buttonsAccessibily () {
        addButton.isAccessibilityElement = true
        addButton.accessibilityHint = "Adding ingredients to the list"
        
        clearButton.isAccessibilityElement = true
        clearButton.accessibilityHint = "Clear the list of ingredients"
        
        searchButton.isAccessibilityElement = true
        searchButton.accessibilityHint = "Search the recipes of the ingredients entered"
    }
    
    //MARK: - Private
    private func getIngredientsPlus () {
        ingredientModel.getIngredient(callback: {[weak self] ingredients in
            var ingredientText = ""
            for ingredient in ingredients {
                if let name = ingredient.name {
                    ingredientText += name + "\n \n"
                }
            }
            self?.ingredientSavedField.text = ingredientText
        })
    }
    
}

extension IngredientViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        addIngredient()
        return true
    }
    
    private func addIngredient() {
        guard
            let ingredientName = ingredientField.text,
            var ingredient = ingredientSavedField.text
        else { return }
        ingredientModel.saveIngredient(named: ingredientName, callback: {[weak self] ingredients in
            ingredient += ingredientName + "\n"
            self?.ingredientSavedField.text = ingredient
            self?.ingredientField.text = ""
        })
    }
    
}
