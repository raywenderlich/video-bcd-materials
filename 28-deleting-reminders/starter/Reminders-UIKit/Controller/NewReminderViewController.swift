/// Copyright (c) 2020 Razeware LLC
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import CoreData
import UIKit

final class NewReminderViewController: UITableViewController {
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var attachmentImageView: UIImageView!
  var context: NSManagedObjectContext?
  var list: List?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func dismissViewController(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveReminder(_ sender: Any) {
    guard let title = titleTextField.text else { return }
    guard let context = context else { return }
    guard let list = list else { return }

    let newReminder = Reminder(context: context)
    newReminder.title = title
    newReminder.list = list

    do {
      try context.save()
      dismiss(animated: true, completion: nil)
    } catch {
      fatalError("Core Data save error")
    }
  }
}


extension NewReminderViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let attachmentsIndexPath = IndexPath(row: 0, section: 1)
    
    if indexPath == attachmentsIndexPath {
      let imagePickerController = UIImagePickerController()
      imagePickerController.delegate = self
      present(imagePickerController, animated: true, completion: nil)
    }
  }
}

extension NewReminderViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    guard let image = info[.originalImage] as? UIImage else { return }
    self.attachmentImageView.image = image
    // Customize
    
    dismiss(animated: true, completion: nil)
  }
}

