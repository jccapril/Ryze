//
//  File.swift
//  Ryze
//
//  Created by Jiang Chencheng on 2024/12/5.
//

@propertyWrapper
struct UnDecodable<Value>: Decodable {
    private var value: Value?
    
    init(wrappedValue: Value) { value = wrappedValue }
    
    init(from decoder: Decoder) throws { }

    var wrappedValue: Value {
        get { value! }
        set { value = newValue }
    }
}

