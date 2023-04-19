//
//  RechercheViewController.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import UIKit

class ResearchViewController: UIViewController {
    //MARK: -Properties
    var searchModel = SearchModel ()
    
    
    @IBOutlet weak var tableView : UITableView!
    
    //MARK: -Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        searchModel.getRecipe { result in
            switch result {
            case .success(let value):
                print (value)
                self.tableView.reloadData()
            case .failure(let error):
                print (error)
                
            }
        }
        
    }
    
}

extension ResearchViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchModel.recipes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PresentCell" , for: indexPath) as? PresentTableViewCell else {
            return UITableViewCell()
        }
        let recipe = self.searchModel.recipes[indexPath.row]
        cell.configure(recipe: recipe)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "detailRecipe") as? RecipeDetailViewController {
            vc.recipe = self.searchModel.recipes[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
