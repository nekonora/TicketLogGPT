//
//  String+.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation

extension String {
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }
}
