//
//  String+Extension.swift
//  BYT-liamdkane
//
//  Created by C4Q on 12/9/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

extension String {
    func filterBadLanguage (_ toggle: Bool) -> String {
        guard toggle else { return self }
        let wordsToBeFiltered: Set<String> = ["fuck", "bitch", "ass", "dick", "pussy", "shit", "twat", "cunt", "cock"]
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        
        func filterFoulWords (_ previewText: String) -> String {
            var words = previewText.components(separatedBy: " ")
            for (index, word) in words.enumerated() {
                let filteredWord = word.replacingOccurrences(of: word, with: filter(word), options: .caseInsensitive, range: nil)
                words[index] = filteredWord
            }
            return words.joined(separator: " ")
        }
        func filter(_ word: String) -> String {
            for foulWord in wordsToBeFiltered where word.lowercased().contains(foulWord){
                for char in word.lowercased().characters where vowels.contains(char) {
                    return word.replacingOccurrences(of: String(char), with: "*", options: .caseInsensitive, range: nil)
                }
            }
            return word
        }
        
        return filterFoulWords(self)
    }
}
