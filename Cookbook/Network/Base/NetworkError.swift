//
//  NetworkError.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/17/25.
//

enum NetworkError: Error {
    case noData                // Отсутствие данных в ответе
    case decodingError         // Ошибка декодирования данных
    case badServerResponse     // Неправильный ответ от сервера
    case requestFailed(Error)  // Ошибка выполнения запроса (с передачей ошибки)
}
