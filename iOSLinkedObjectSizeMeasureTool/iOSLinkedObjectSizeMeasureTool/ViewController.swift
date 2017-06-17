//
//  ViewController.swift
//  iOSLinkedObjectSizeMeasureTool
//
//  Created by Jacob on 6/17/17.
//  Copyright © 2017 Ringcentral. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var oldVersionTextField: NSTextField!
    @IBOutlet weak var newVersionTextField: NSTextField!
    @IBOutlet var resultTextView: NSTextView!
    var xlsString:String = ""
    @IBAction func selectNewFile(_ sender: Any) {
        let openDlg = NSOpenPanel()
        openDlg.canChooseFiles = true
        openDlg.canChooseDirectories = false
        openDlg.runModal()
        self.newVersionTextField.stringValue = (openDlg.urls.first?.path)!
    }
    
    @IBAction func selectOldFile(_ sender: Any) {
        let openDlg = NSOpenPanel()
        openDlg.canChooseFiles = true
        openDlg.canChooseDirectories = false
        openDlg.runModal()
        self.oldVersionTextField.stringValue = (openDlg.urls.first?.path)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startAnalyse(_ sender: Any) {
        if !FileManager.default.fileExists(atPath: oldVersionTextField.stringValue) || !FileManager.default.fileExists(atPath: newVersionTextField.stringValue){
            self.resultTextView.string = "File not existed"
            return
        }
        
        let oldString = try? String(contentsOfFile: oldVersionTextField.stringValue)
        let newString = try? String(contentsOfFile: newVersionTextField.stringValue)
        
        if (oldString?.isEmpty)! || (newString?.isEmpty)! {
            self.resultTextView.string = "File seems empty"
            return
        }
        
        let oldArray = oldString?.components(separatedBy: "\n")
        let newArray = newString?.components(separatedBy: "\n")
        
        if oldArray?.count == 0 || newArray?.count == 0 {
            self.resultTextView.string = "Parse failed, format not correct"
            return
        }
        
        var allDic:[String:[Int64]] = [:]
        for item in oldArray! {
            if !item.isEmpty {
                let keyValue = item.components(separatedBy: "\t")
                allDic[keyValue.first!] = [Int64(keyValue.last!)!]
            }
        }
        
        for item in newArray! {
            if !item.isEmpty {
                let keyValue = item.components(separatedBy: "\t")
                if allDic[keyValue.first!] != nil {
                    allDic[keyValue.first!]?.insert(Int64(keyValue.last!)!, at: 1)
                }
                else
                {
                    allDic[keyValue.first!] = [Int64(keyValue.last!)!]
                }
            }
        }
        
        let sortedDic = allDic.sorted { (v1, v2) -> Bool in
            return v1.value.first! > v2.value.first!
        }
        
        var resultString = ""
        xlsString = ",Old,New\n"
        for (key,value) in sortedDic {
            resultString.append("\(key)\t\(covertToFileString(with: value.first!))\t\(covertToFileString(with: value.last!))\n")
            xlsString.append("\(key),\(value.first!),\(value.last!)\n")
        }
        resultTextView.string = resultString
    }
    
    @IBAction func saveXLSChart(_ sender: Any) {
        let data = xlsString.data(using: String.Encoding.utf8)
        let openDlg = NSOpenPanel()
        openDlg.canChooseFiles = false
        openDlg.canChooseDirectories = true
        openDlg.runModal()
        let saveDir = (openDlg.urls.first?.path)! + "/chart.cvs"
        do {
            try data?.write(to: URL(fileURLWithPath: saveDir))
        } catch {
            
        }
    }
    
    func covertToFileString(with size: Int64) -> String {
        var convertedValue: Double = Double(size)
        var multiplyFactor = 0
        let tokens = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB",  "ZB", "YB"]
        while convertedValue > 1024 {
            convertedValue /= 1024
            multiplyFactor += 1
        }
        return String(format: "%4.2f %@", convertedValue, tokens[multiplyFactor])
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    
}

