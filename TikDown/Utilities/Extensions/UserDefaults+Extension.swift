//
//  UserDefaults+Extension.swift
//  TikDown
//
//  Created by Ali on 19.05.2022.
//

import UIKit

//MARK: - Save Model
protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

extension UserDefaults: ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    
    
    func setModel<T>(object: T, forKey: String) throws where T: Encodable {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
            set(encodedData, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    func getModel<T>(forKey: String, castTo type: T.Type) throws -> T where T: Decodable {
        do {
            guard let data = data(forKey: forKey) else {
                
                throw ObjectSavableError.noValue
            }
            
            guard let dataModel = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) else {
                
                throw ObjectSavableError.unableToDecode
            }
            
            return dataModel as! T
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}
