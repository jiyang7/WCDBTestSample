//
//  ViewController.swift
//  TestSample
//
//  Created by jiyang on 2024/6/3.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TestSample.sharedInstance.createTable()
        TestSample.sharedInstance.createSampleData()
    }

    @IBAction func selectRightTestData(_ sender: Any) {
        resultLabel.text = TestSample.sharedInstance.selectRightTestData()
    }
    
    @IBAction func selectWrongTestData(_ sender: Any) {
        resultLabel.text = TestSample.sharedInstance.selectWrongTestData()
    }
}

