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


    @IBOutlet var scoreTextField: UITextField! // スコア入力用のテキストフィールド

    @IBOutlet var nameTextField: UITextField! // ユーザーネーム入力用のテキストフィールド

    @IBOutlet var firstLabel: UILabel! // 1位表示用のラベル

    @IBOutlet var secondLabel: UILabel! // 2位表示用のラベル

    @IBOutlet var thirdLabel: UILabel! // 3位表示用のラベル

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


    // スコア登録用メソッド
    func send() {

        let ref = Database.database().reference().child("ranking") // 保存先を指定
        let username: String = nameTextField.text! // ユーザーネーム
        let score: Int = Int(scoreTextField.text ?? "0") ?? 0 // スコア

        ref.childByAutoId().setValue(["username": username, "score": score]) // 保存
    }

    // 取得
    func fetch() {

        let ref = Database.database().reference().child("ranking") // 取得先を指定
        // scoreの値が上から3つになるように設定して取得
        ref.queryOrdered(byChild: "score").queryLimited(toLast: 3).observe(.value, with: { snapshot in

            print("snap")

            // DataSnapshotを配列に変換
            var snapshotArray: [DataSnapshot] = []

            for item in snapshot.children {

                snapshotArray.append(item as! DataSnapshot)
            }

            // 順序が昇順なので、降順に
            snapshotArray.reverse()

            // Snapshotの配列からRankの配列をつくる
            var rankArray: [Rank] = []

            for snap in snapshotArray {

                let rank = Rank(dic: snap.value as! [String: Any])
                rankArray.append(rank)
            }

            // Rankの配列を使ってラベルに表示
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


// ランキングのデータをまとめるためのクラス
class Rank {

    var username: String = ""
    var score: Int = 0

    init(dic: [String: Any]) {

        self.username = dic["username"] as? String ?? ""
        self.score = dic["score"] as? Int ?? 0
    }
 }

