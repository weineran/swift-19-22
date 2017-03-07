import Cocoa

enum Token {
    case Number(Int)
    case Plus
}

class Lexer {
    // NOTE ErrorType has been renamed to Error
    //      so had to rename the enum so that it wasn't the same as the type?
    enum LexerError: Error {
        case InvalidCharacter(Character)
    }
    
    let input: String.CharacterView
    var position: String.CharacterView.Index
    init(input: String) {
        self.input = input.characters
        self.position = self.input.startIndex
    }
    
    func peek() -> Character? {
        guard position < input.endIndex else {
            return nil }
        return input[position]
    }
    
    func advance() {
        assert(position < input.endIndex, "Cannot advance past the end!")
        position = input.index(after: position)  // NOTE The ++ operator was deprecated
    }
    
    func getNumber() -> Int {
        var value = 0
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9":
                // Another digit - add it into value
                let digitValue = Int(String(nextCharacter))!
                value = 10*value + digitValue
                advance()
            default:
                // A non-digit - go back to regular lexing
                return value
            }
        }
        return value
    }
    
    func lex() throws -> [Token] {
        var tokens = [Token]()
        while let nextCharacter = peek() {
            switch nextCharacter {
            case "0" ... "9":
                // Start of a number - need to grab the rest
                let value = getNumber()
                tokens.append(.Number(value))
            case "+":
                tokens.append(.Plus)
                advance()
            case " ":
                // Just advance to ignore spaces
                advance()
            default:
                // Something unexpected - need to send back an error
                throw LexerError.InvalidCharacter(nextCharacter)
            }
        }
        return tokens
    }
}

class Parser {
    enum ParserError: Error {
        case UnexpectedEndOfInput
        case InvalidToken(Token)
    }
    
    let tokens: [Token]
    var position = 0
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    func getNextToken() -> Token? {
        guard position < tokens.count else {
            return nil
        }
        // NOTE changed because ++ operator is gone
        let nextToken = tokens[position]
        position += 1
        return nextToken
    }
    
    func getNumber() throws -> Int {
        guard let token = getNextToken() else {
            throw ParserError.UnexpectedEndOfInput
        }
        switch token {
        case .Number(let value):
            return value
        case .Plus:
            throw ParserError.InvalidToken(token)
        }
    }
    
    func parse() throws -> Int {
        // Require a number first
        var value = try getNumber()  // NOTE no corresponding catch block
        while let token = getNextToken() {
            switch token {
            // Getting a Plus after a Number is legal
            case .Plus:
                // After a plus, we must get another number
                let nextNumber = try getNumber()  // NOTE no corresponding catch block
                value += nextNumber
            // Getting a Number after a Number is not legal
            case .Number:
                throw ParserError.InvalidToken(token)
            }
        }
        return value
    }
}

func evaluate(input: String) {
    print("Evaluating: \(input)")
    let lexer = Lexer(input: input)
    
    do {
        let tokens = try lexer.lex()
        print("Lexer output: \(tokens)")
        
        let parser = Parser(tokens: tokens)
        let result = try parser.parse()
        print("Parser output: \(result)")
    } catch Lexer.LexerError.InvalidCharacter(let character) {
        // catch block that is specifically looking for the InvalidCharacter error
        print("Input contained an invalid character: \(character)")
    } catch Parser.ParserError.UnexpectedEndOfInput {
        print("Unexpected end of input during parsing")
    } catch Parser.ParserError.InvalidToken(let token) {
        print("Invalid token during parsing: \(token)")
    } catch {
        print("An error occurred: \(error)")
    }
}

evaluate(input: "10 + 3 + 5")
evaluate(input: "10")
evaluate(input: "10 + 3 + 5abc")
evaluate(input: "10 + 3 + + 5")
evaluate(input: "10 11")
evaluate(input: "10 +")



