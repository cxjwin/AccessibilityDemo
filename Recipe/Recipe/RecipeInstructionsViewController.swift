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

class RecipeInstructionsViewController: UITableViewController {
  private var headerView: UIView!
  private var instructionViewModel: InstructionViewModel!
  var recipe: Recipe!
  var didLikeFood = true
  @IBOutlet var likeButton: UIButton!
  @IBOutlet var backButton: UIButton!
  @IBOutlet var dishImageView: UIImageView!
  @IBOutlet var dishLabel: UILabel!
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    assert(recipe != nil)
    
    backButton.accessibilityLabel = "back"
    backButton.accessibilityTraits = UIAccessibilityTraits.button
    
    isLikedFood(true)
    instructionViewModel = InstructionViewModel(recipe: recipe, type: .ingredient)
    setupRecipe()
    setupTableView()
    mockAccessibilityEelement()
  }
  
  // MARK: - Action Outlets
  
  @IBAction func likeButtonPressed(_ sender: AnyObject) {
    isLikedFood(!didLikeFood)
  }
  
  func isLikedFood(_ liked: Bool) {
    if liked {
      likeButton.setTitle("😍", for: .normal)
      likeButton.accessibilityLabel = "Like"
      likeButton.accessibilityTraits = UIAccessibilityTraits.button
      didLikeFood = true
    } else {
      likeButton.setTitle("😖", for: .normal)
      likeButton.accessibilityLabel = "Dislike"
      likeButton.accessibilityTraits = UIAccessibilityTraits.button
      didLikeFood = false
    }
  }
  
  @IBAction func toggleSegment(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 { // Ingredients
      instructionViewModel.type = .ingredient
    } else { //Instruction
      instructionViewModel.type = .cookingInstructions
    }
    tableView.reloadData()
  }
  
  @IBAction func tapBackButton(_ sender: AnyObject) {
    navigationController?.popViewController(animated: true)
  }
  
  // MARK: - TableView Data Source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return instructionViewModel.numberOfSections()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return instructionViewModel.numberOfItems()
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InstructionCell.self), for: indexPath) as! InstructionCell
    
    if let description = instructionViewModel.itemFor(indexPath.item) {
      cell.configure(description)
    }
    
    let strike = instructionViewModel.getStateFor(indexPath.item)
    cell.shouldStrikeThroughText(strike)
    
    return cell
  }
  
  // MARK: - TableView Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    instructionViewModel.selectItemFor(indexPath.item)
    let cell = tableView.cellForRow(at: indexPath) as! InstructionCell
    let strike = instructionViewModel.getStateFor(indexPath.item)
    cell.shouldStrikeThroughText(strike)
  }
}

// MARK: - Setup

extension RecipeInstructionsViewController {
  func setupRecipe() {
    dishImageView.image = recipe.photo
    dishLabel.text = recipe.name
  }
  
  func setupTableView() {
    tableView.estimatedRowHeight = 79
    tableView.rowHeight = UITableView.automaticDimension
  }
  
  // 创建一个 UIAccessibilityElement
  func mockAccessibilityEelement() {
    let dummyView = UIView.init(frame: CGRect.zero)
    dummyView.isUserInteractionEnabled = true
    dummyView.frame = CGRect.init(x: 0, y: 64, width: view.frame.width, height: 50)
    dummyView.backgroundColor = UIColor.red
    view.addSubview(dummyView)
    
    let ele = UIAccessibilityElement(accessibilityContainer: dummyView)
    ele.isAccessibilityElement = true
    ele.accessibilityIdentifier = "mock_id"
    ele.accessibilityLabel = "Label"
    ele.accessibilityValue = "Value"
    ele.accessibilityHint = "Hint"
    ele.accessibilityTraits = .button
    ele.accessibilityFrameInContainerSpace = dummyView.bounds
    
    dummyView.isAccessibilityElement = false
    dummyView.accessibilityElements = [ele]
  }
}
