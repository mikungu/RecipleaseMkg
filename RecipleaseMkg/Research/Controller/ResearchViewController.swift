//
//  RechercheViewController.swift
//  RecipleaseMkg
//
//  Created by Mikungu Giresse on 02/03/23.
//

import UIKit

class ResearchViewController: UIViewController {
    //MARK: -Properties
    var searchModel = SearchModel (httpClient: APIService())
    
    @IBOutlet weak var indicatorActivity: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView : UITableView!
    
    //MARK: -Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // indicatorActivity.isHidden = false
        self.tableView.tableFooterView = createSpinnerFooter ()

        tableView.dataSource = self
        tableView.delegate = self
        
        searchModel.getRecipe { result in
            self.tableView.tableFooterView = nil

          //  self.indicatorActivity.isHidden = true
            switch result {
            case .success(let value):
                print (value)
                self.tableView.reloadData()
            case .failure(let error):
                print (error)
                self.displayAlert(title: "Error", message: "There is a \(error). \n Please check your network", preferredStyle: .alert)
                
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
    
    //Do a pagination
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == searchModel.recipes.count - 1 {
            
            self.tableView.tableFooterView = createSpinnerFooter ()
            
            searchModel.getRecipe { result in
                self.tableView.tableFooterView = nil
                switch result {
                case .success(let value):
                    print (value)
                    self.searchModel.recipes += [value]
                    self.tableView.reloadData()
                case .failure(let error):
                    print (error)
                    
                }
            }
        }
    }
    
    @objc func loadTable() {
        self.tableView.reloadData()
    }
    private func createSpinnerFooter () -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.color = .white
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}
