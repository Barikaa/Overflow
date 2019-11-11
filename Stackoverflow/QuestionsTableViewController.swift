//
//  QuestionsTableViewController.swift
//  Stackoverflow
//
//  Created by Kalló Barbara on 2019. 09. 09..
//  Copyright © 2019. Kalló Barbara. All rights reserved.
//

import UIKit
import Alamofire

class QuestionsTableViewController: UITableViewController, UISearchBarDelegate {
    
    var questions: [Question] = []
    var page: Int = 1
    var tag: String = "" {
        didSet {
            if tag.count > 0 {
                let url = createURL(for: tag, page: page)
                getData(url: url)
            }
        }
    }
    var searchActive: Bool = false
    @IBOutlet var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let index = indexPath.row
        let question = questions[index]
        cell.textLabel?.text = question.title

        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tag = searchText
    }

    func createURL(for tag: String, page: Int) -> String {
        return "https://api.stackexchange.com/2.2/questions?page=\(page)&order=desc&sort=activity&tagged=\(tag)&site=stackoverflow"
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
                guard let responseModel = try? decoder.decode(QuestionsResponseModel.self, from: data)
                    else {
                        print("Error: Decoding failed")
                        return
                }
                self.questions = responseModel.items
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAnswers",
            let answersViewController = segue.destination as? AnswersTableViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let index = indexPath.row
            let question = questions[index]
            answersViewController.questionId = question.questionId
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // load more questions
    }
}

