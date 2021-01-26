/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class RecipeListViewController: UITableViewController {
  var recipes: [Recipe] = []
  var selectedRecipe: Recipe?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let seedRecipe = Recipe.loadDefaultRecipe() {
      recipes += seedRecipe
      recipes = recipes.sorted(by: { $0.name < $1.name })
    }
    
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showRecipe" {
      if let vc = segue.destination as? RecipeInstructionsViewController {
        vc.recipe = selectedRecipe
      }
    }
  }
  
  // MARK: - TableView Data Source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return recipes.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeCell.self), for: indexPath) as! RecipeCell
    let recipe = recipes[indexPath.item]
    cell.configureCell(with: recipe)
    return cell
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    selectedRecipe = recipes[indexPath.item]
    performSegue(withIdentifier: "showRecipe", sender: self)
  }
}
