//
//  LinguisticTaggerProcess.swift
//  Natural-language
//
//  Created by 何家瑋 on 2017/7/17.
//  Copyright © 2017年 何家瑋. All rights reserved.
//

import Foundation

struct LinguisticTaggerProcess {
        
        init(tagSchemes : [NSLinguisticTagScheme]) {
                tagger = NSLinguisticTagger(tagSchemes: tagSchemes, options: 0)
        }
        
        private var tagger : NSLinguisticTagger?
        private var sentence : String = ""
        private var tagSchemeTable :  Dictionary<String , tagSchemeArgument> = [
                "language"      : tagSchemeArgument(enumerateUnit: .sentence, options: [.omitWhitespace, .omitPunctuation],                         enumerateScheme: NSLinguisticTagScheme.language),
                "tokenType"      : tagSchemeArgument(enumerateUnit: .word, options: [.omitWhitespace, .omitPunctuation],                         enumerateScheme: NSLinguisticTagScheme.tokenType),
                "lexicalClass"      : tagSchemeArgument(enumerateUnit: .word, options: [.omitWhitespace, .omitPunctuation], enumerateScheme: NSLinguisticTagScheme.lexicalClass),
                "nameType"      : tagSchemeArgument(enumerateUnit: .word, options: [.omitWhitespace, .omitPunctuation, .joinNames], enumerateScheme: NSLinguisticTagScheme.nameType),
                "nameTypeOrLexicalClass"   : tagSchemeArgument(enumerateUnit: .word, options: [.omitWhitespace, .omitPunctuation, .joinNames], enumerateScheme: NSLinguisticTagScheme.nameTypeOrLexicalClass),
                "lemma"      : tagSchemeArgument(enumerateUnit: .word, options: [.omitWhitespace, .omitPunctuation], enumerateScheme: NSLinguisticTagScheme.lemma),
        ]
        
        private struct tagSchemeArgument {
                var enumerateUnit : NSLinguisticTaggerUnit
                var options : NSLinguisticTagger.Options
                var enumerateScheme : NSLinguisticTagScheme
        }
        
        private func supportTagScheme(_ tagScheme : NSLinguisticTagScheme) -> Bool {
                return tagger?.tagSchemes.contains(tagScheme) ?? false
        }
        
        //MARK: public
        public enum errorMessage : Error {
                case notSupportScheme
        }
        
        public struct taggerResult {
                var tag : NSLinguisticTag?
                var value : String?
        }
        
        mutating func setAnalyzeString(_ analyzeString : String) -> Void {
                sentence = analyzeString
        }
        
        func startTheAnalysis(enumerateTag : String) throws -> [taggerResult] {
                var result = [taggerResult]()
                if let tagArgument = tagSchemeTable[enumerateTag] {
                        guard supportTagScheme(tagArgument.enumerateScheme) else {
                                throw errorMessage.notSupportScheme
                        }
                        
                        tagger?.string = sentence
                        let range = NSMakeRange(0, sentence.utf16.count)
                        tagger?.enumerateTags(in: range, unit: tagArgument.enumerateUnit, scheme: tagArgument.enumerateScheme, options: tagArgument.options, using: { (tag, tokenRange, pointer) in
                                let value = (sentence as NSString).substring(with: tokenRange)
                                result.append(taggerResult(tag: tag, value: value))
                        })
                }
                
                return result
        }
}

