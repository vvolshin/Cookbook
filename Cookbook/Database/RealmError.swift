//
//  RealmError.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

enum RealmError: String, Error {
    case createDatabaseError = "Error: create database error"
    case initializationFailed = "Error: unable to initialize realm"
    case fileNotFound = "Error: name not found"
    case recipeNotFound = "Error: recipe not found"
    case createError = "Error: create error"
    case updateError = "Error: update error"
    case deleteError = "Error: delete error"
    case fileAlreadyExists = "Error: file already exists"
    case emptyDatabase = "Error: empty database"
    case testError = "Error: test error"
    case unknownError = "Error: unknown error"
    
    var description: String {
        return rawValue
    }
}
