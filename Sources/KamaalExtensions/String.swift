//
//  String.swift
//
//
//  Created by Kamaal Farah on 28/10/2020.
//

import Foundation

extension String {
    public var nsString: NSString? {
        NSString(utf8String: self)
    }

    public var uuid: UUID? {
        UUID(uuidString: self)
    }

    public func replaceMultipleOccurrences(of targets: [Character], with replacement: Character) -> String {
        guard !targets.isEmpty else { return self }
        var stringToEdit = asArray()
        for (index, character) in enumerated() where targets.contains(character) {
            stringToEdit[index] = replacement
        }
        return String(stringToEdit)
    }
}

extension StringProtocol {
    public var splitByCapital: [String] {
        let indexes = Set(enumerated()
            .filter(\.element.isUppercase)
            .map(\.offset))
        let chunks: [String] = map { String($0) }
            .enumerated()
            .reduce([]) { (chunks: [String], elm: (offset: Int, element: String)) in
                guard !chunks.isEmpty else { return [elm.element] }
                guard !indexes.contains(elm.offset) else { return chunks + [String(elm.element)] }
                var chunks = chunks
                chunks[chunks.count - 1] += String(elm.element)
                return chunks
            }
        return chunks
    }

    /// Transforming localized number to a double
    public var localizedStringToDouble: Double? {
        let string = trimmingByWhitespacesAndNewLines
        guard let startNumberIndex = string.firstIndex(where: \.isNumber),
              let endNumberIndex = string.lastIndex(where: \.isNumber) else { return nil }

        let rawAmount = string[startNumberIndex ... endNumberIndex]
        let rawAmountCount = rawAmount.count
        var seperatorIndex: Int?
        let seperators: [Character] = [".", ","]
        if rawAmountCount > 1 {
            for index in 0 ..< rawAmountCount {
                let characterIndex = rawAmountCount - index - 1
                let character = rawAmount[characterIndex]
                if seperators.contains(character) {
                    seperatorIndex = characterIndex
                    break
                }
            }
        }

        return Double(String(rawAmount
                .enumerated()
                .filter { $0.offset == seperatorIndex || !seperators.contains($0.element) }
                .map(\.element))
            .replacingOccurrences(of: ",", with: "."))
    }

    /// Split String by newlines(\n)
    public var splitLines: [SubSequence] {
        split(whereSeparator: \.isNewline)
    }

    /// Split String by commas(,)
    public var splitCommas: [SubSequence] {
        split(separator: ",")
    }

    /// Converts String to Int
    public var int: Int? {
        Int(self)
    }

    public var trimmingByWhitespacesAndNewLines: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public var scrambled: String {
        String(shuffled())
    }

    public var digits: String {
        components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }

    /// Splitting strings by new lines (\n).
    /// - Parameter omittingEmptySubsequences: Whether or not to omit empty subsequences.
    /// - Returns: A splitted string by new line.
    func splitLines(omittingEmptySubsequences: Bool) -> [Self.SubSequence] {
        split(omittingEmptySubsequences: omittingEmptySubsequences, whereSeparator: \.isNewline)
    }

    /// Makes a range of the current string.
    /// - Parameters:
    ///   - start: from which index to start the range.
    ///   - end: the index to end the range on.
    /// - Returns: range of the current string.
    public func range(from start: Int, to end: Int? = nil) -> Self.SubSequence {
        var end = end ?? count
        if end > count {
            end = count
        }

        return self[index(startIndex, offsetBy: start) ..< index(startIndex, offsetBy: end)]
    }

    public subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
