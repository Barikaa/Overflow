//
//  Question.swift
//  Stackoverflow
//
//  Created by Kalló Barbara on 2019. 09. 09..
//  Copyright © 2019. Kalló Barbara. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let title: String
    let questionId: Int

}

struct QuestionsResponseModel: Decodable {
    let items: [Question]
}

struct Answer: Decodable {
    let body: String
    let owner: Owner
}

struct Owner: Decodable {
    let displayName: String
}

struct AnswersResponseModel: Decodable {
    let items: [Answer]
}
