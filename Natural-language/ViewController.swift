//
//  ViewController.swift
//  Natural-language
//
//  Created by 何家瑋 on 2017/7/17.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

        @IBOutlet weak var inputTextField: UITextField!
        @IBOutlet weak var analyzeResultLabel: UILabel!
        
        var analyzeResult : String {
                set {
                        analyzeResultLabel.text = newValue
                }
                get {
                        return analyzeResultLabel.text!
                }
        }
        
        var didSelectTag : String = "language"
        var taggerPorcess = LinguisticTaggerProcess(tagSchemes: [NSLinguisticTagScheme.language, NSLinguisticTagScheme.nameType, NSLinguisticTagScheme.lexicalClass, NSLinguisticTagScheme.nameTypeOrLexicalClass, NSLinguisticTagScheme.tokenType, NSLinguisticTagScheme.lemma])
        
        override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
                
                inputTextField.delegate = self
                inputTextField.returnKeyType = .search
                
                analyzeResultLabel.numberOfLines = 0
        }

        override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
        }
        
        @IBAction func clickTagButton(_ sender: UIButton) {
                
                if let buttonTitle = sender.currentTitle {
                        didSelectTag = buttonTitle
                }
                
                cleanAnalyzeResultLabel()
                sentenceAnalyze(inputTextField.text!)
        }
        
        func sentenceAnalyze(_ sentence : String) -> Void {
                var taggerResult : [LinguisticTaggerProcess.taggerResult]
                taggerPorcess.setAnalyzeString(sentence)
                do {
                        taggerResult = try taggerPorcess.startTheAnalysis(enumerateTag: didSelectTag)
                        for result in taggerResult {
                                
                                let value = result.value ?? "no value"
                                let tag = result.tag?.rawValue ?? "no tag"
                                
                                print("tag : ", tag)
                                print("value : ", value)
                                print("====================")
                                
                                let currentDisplayString = analyzeResult
                                analyzeResult = "\(currentDisplayString)   \(value) -> \(tag)."
                        }
                } catch let error {
                        print(error)
                }
        }
        
        func cleanAnalyzeResultLabel() -> Void {
                analyzeResult = ""
        }
        
        // MARK: UITextFieldDelegate
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                textField.resignFirstResponder()
                return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
                return true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
                cleanAnalyzeResultLabel()
                sentenceAnalyze(textField.text!)
        }
}

