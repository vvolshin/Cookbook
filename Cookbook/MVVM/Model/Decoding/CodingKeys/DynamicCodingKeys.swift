//
//  DynamicCodingKeys.swift
//  Cookbook
//
//  Created by Vitaly Volshin on 1/18/25.
//

struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    var intValue: Int? { nil }
    init?(intValue: Int) { nil }
}
