//
//  ReplyTableViewController.swift
//  Stackoverflow
//
//  Created by Kalló Barbara on 2019. 09. 13..
//  Copyright © 2019. Kalló Barbara. All rights reserved.
//

import UIKit
import Alamofire

class AnswersTableViewController: UITableViewController {
    
    var questionId: Int?
    var answers: [Answer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let questionId = questionId {
            let url = createAnswersURL(questionId: questionId)
            getData(url: url)
            
        }
    }

    func createAnswersURL(questionId: Int) -> String {
        return "https://api.stackexchange.com/2.2/questions/\(questionId)/answers?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wzShk"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        let index = indexPath.row
        let answer = answers[index]
        cell.textLabel?.text = answer.title
        
        return cell
    }

    func getData(url: String) {
        
        Alamofire.request(url, method: .get, parameters: nil).responseJSON { response in
            if response.result.isSuccess {
                guard let data = response.data else {
                    print("Error: No response data")
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                guard let responseModel = try? decoder.decode(AnswersResponseModel.self, from: data) else {
                    print("Error: Decoding failed")
                    return
                }
                self.answers = responseModel.items
                self.tableView.reloadData()
            }
        }
    }
}
