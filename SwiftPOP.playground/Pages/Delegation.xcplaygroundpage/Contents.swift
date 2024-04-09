//: [Previous](@previous)

import UIKit

var greeting = "Delegation"

protocol TextEditorDelegate: AnyObject {
    func textDidChange(_ editor: TextEditor, text: String)
}

class TextEditor: UIViewController {
    weak var delegate: TextEditorDelegate?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
    }
    
    @IBAction func textDidChange(_ sender: UITextView) {
        delegate?.textDidChange(self, text: sender.text)
    }
}

extension TextEditor: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textDidChange(textView)
    }
}

class ToolbarViewController: UIViewController, TextEditorDelegate {
    @IBOutlet weak var charCountLabel: UILabel!
    
    func textDidChange(_ editor: TextEditor, text: String) {
        charCountLabel.text = "\(text.count) characters"
    }
}

let textEditor = TextEditor()
let toolbarViewController = ToolbarViewController()
textEditor.delegate = toolbarViewController

//: [Next](@next)
