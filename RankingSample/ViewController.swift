//
//  ViewController.swift
//  RankingSample
//
//  Created by ShinokiRyosei on 2017/08/28.
//  Copyright © 2017年 ShinokiRyosei. All rights reserved.
//

import UIKit

import Firebase

class ViewController: UIViewController {


    @IBOutlet var scoreTextField: UITextField!

    @IBOutlet var nameTextField: UITextField!

    @IBOutlet var firstLabel: UILabel!

    @IBOutlet var secondLabel: UILabel!

    @IBOutlet var thirdLabel: UILabel!

    let ref = Database.database().reference().child("ranking")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.fetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButton() {

        self.send()
    }


    func send() {

        let username: String = nameTextField.text!
        let score: Int = Int(scoreTextField.text ?? "0") ?? 0

        ref.childByAutoId().setValue(["username": username, "score": score])
    }

    func fetch() {

        ref.queryOrdered(byChild: "score").queryLimited(toLast: 3).observe(.value, with: { snapshot in
            
            print(snapshot)
        })
    }


}

