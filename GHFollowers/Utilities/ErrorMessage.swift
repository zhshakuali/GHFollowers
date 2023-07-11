//
//  ErrorMessage.swift
//  GHFollowers
//
//  Created by Жансая Шакуали on 06.07.2023.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unableToComplete = "Unable your request. Plese check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try it again"
    case invalidData = "The data received from the server was invalid. Please try again."
}
