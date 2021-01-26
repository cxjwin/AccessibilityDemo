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

class InstructionCell: UITableViewCell {
  @IBOutlet var checkmarkButton: UIButton!
  @IBOutlet var descriptionLabel: UILabel!
  
  func configure(_ description: String) {
    descriptionLabel.attributedText = nil
    descriptionLabel.text = description
  }
  
  @IBAction func checkmarkTapped(_ sender: AnyObject) {
    shouldStrikeThroughText(!checkmarkButton.isSelected)
  }
  
  func shouldStrikeThroughText(_ strikeThrough: Bool) {
    guard let text = descriptionLabel.text else {
      return
    }
    
    let attributeString =  NSMutableAttributedString(string: text)
    
    // 1
    checkmarkButton.isAccessibilityElement = false
    
    if strikeThrough {
      // 2
      descriptionLabel.accessibilityLabel = "Completed: \(text)"
      attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(text.startIndex..., in: text))
    } else {
      // 3
      descriptionLabel.accessibilityLabel = "Uncompleted: \(text)"
    }
    
    let buttonImage = strikeThrough ? UIImage(named: "icon-check") : UIImage(named: "icon-empty")
    checkmarkButton.setImage(buttonImage, for: .normal)
    descriptionLabel.attributedText = attributeString
  }
}
