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

class AmpDetailsViewController: UIViewController {
  let dataSource: [Amp] = Amp.all
  var selectedIndex = 0 {
    didSet {
      onSelectedIndexUpdate()
    }
  }

  @IBOutlet weak var previousButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var ratingButton: UIButton!
  @IBOutlet weak var heroImageView: UIImageView!
  @IBOutlet weak var brandLabel: UILabel!
  @IBOutlet weak var modelLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var ratingKnob: Knob!
  @IBOutlet weak var ratingLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    // Setup Accessibility
    accessibilityElements = [brandLabel, ratingLabel, descriptionLabel, ratingButton, nextButton, previousButton].compactMap { $0 }
    
    let next = UIAccessibilityCustomAction(name: "Next amp", target: self, selector: #selector(nextAmpAction))
    let previous = UIAccessibilityCustomAction(name: "Previous amp", target: self, selector: #selector(previousAmpAction))
    let rate = UIAccessibilityCustomAction(name: "Add rating", target: self, selector: #selector(rateAmpAction))
    accessibilityCustomActions = [rate, next, previous]

    ratingKnob.lineWidth = 4
    ratingKnob.pointerLength = 8
    onSelectedIndexUpdate()
  }

  func onSelectedIndexUpdate() {
    let amp = ampData(atIndex: selectedIndex)

    ratingKnob.setValue(Float(amp.rating), animated: true)
    ratingLabel.text = "\(amp.rating)"
    ratingLabel.accessibilityLabel = "Average rating is \(amp.rating) out of 11"
    brandLabel.text = amp.brand
    brandLabel.accessibilityLabel = "\(amp.brand) \(amp.model)"
    modelLabel.text = amp.model
    descriptionLabel.text = amp.description
    heroImageView.image = UIImage(named: "amp-\(amp.id)")

    previousButton.isEnabled = selectedIndex != 0
    nextButton.isEnabled = selectedIndex != dataSource.endIndex - 1

    UIAccessibility.post(notification: .screenChanged, argument: brandLabel)
  }

  func ampData(atIndex: Int)  -> Amp {
    let index = max(min(atIndex, dataSource.endIndex - 1), dataSource.startIndex)
    return dataSource[index]
  }

  @IBAction func nextTapped(_ sender: UIButton) {
    selectedIndex = min(selectedIndex + 1, dataSource.endIndex - 1)
  }

  @IBAction func previousTapped(_ sender: UIButton) {
    selectedIndex = max(selectedIndex - 1, dataSource.startIndex)
  }

  @IBAction func unwindToCancelAddRating(_ unwindSegue: UIStoryboardSegue) {
    
  }

  @IBAction func unwindToAddRating(_ unwindSegue: UIStoryboardSegue) {
    if let sourceViewController = unwindSegue.source as? AddRatingViewController {
      let _ = sourceViewController.rating
      // This is where you'd do something with the rating, like post it to a remote API
    }
  }

  @objc func nextAmpAction() -> Bool {
    guard selectedIndex != dataSource.endIndex - 1 else { return false }
    selectedIndex = min(selectedIndex + 1, dataSource.endIndex - 1)
    return true
  }

  @objc func previousAmpAction() -> Bool {
    guard selectedIndex != 0 else { return false }
    selectedIndex = max(selectedIndex - 1, dataSource.startIndex)
    return true
  }

  @objc func rateAmpAction() -> Bool {
    performSegue(withIdentifier: "AddRating", sender: ratingButton)
    return true
  }
}
