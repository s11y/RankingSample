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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.fetch()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendButton() {

        self.send()
    }


    func send() {

        let ref = Database.database().reference().child("ranking")
        let username: String = nameTextField.text!
        let score: Int = Int(scoreTextField.text ?? "0") ?? 0

        ref.childByAutoId().setValue(["username": username, "score": score])
    }

    func fetch() {

        let ref = Database.database().reference().child("ranking")
        ref.queryOrdered(byChild: "score").queryLimited(toLast: 3).observe(.value, with: { snapshot in

            print("snap")

            var snapshotArray: [DataSnapshot] = []

            for item in snapshot.children {

                snapshotArray.append(item as! DataSnapshot)
            }

            snapshotArray.reverse()

            var rankArray: [Rank] = []

            for snap in snapshotArray {

                let rank = Rank(dic: snap.value as! [String: Any])
                rankArray.append(rank)
            }

            for (index, rank) in rankArray.enumerated() {

                if index == 0 {

                    self.firstLabel.text = "\(rank.username)...\(rank.score)"
                }else if index == 1 {

                    self.secondLabel.text = "\(rank.username)...\(rank.score)"
                }else if index == 2 {

                    self.thirdLabel.text = "\(rank.username)...\(rank.score)"
                }
            }
        })
    }
}

class Rank {

    var username: String = ""
    var score: Int = 0

    init(dic: [String: Any]) {

        self.username = dic["username"] as? String ?? ""
        self.score = dic["score"] as? Int ?? 0
    }
 }

