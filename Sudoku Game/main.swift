//
//  main.swift
//  Sudoku
//
//  Created by Ainash Turbayeva on 29.04.2023.
//

import Foundation

class Sudoku {
    
    var grid: [[Int]]
    var answers: [[Int]]
    var n: Int
    var squareRoot: Int
    var k: Int
    var timer = Timer()
    
    
    init(n: Int, k: Int) {
        self.n = n
        self.k = k
        
        let squareRootInDouble = Double(n).squareRoot()
        squareRoot = Int(squareRootInDouble)
        
        grid = Array(repeating: Array(repeating: 0, count: n), count: n)
        answers = Array(repeating: Array(repeating: 0, count: n), count: n)
    }
    
    func fillValues() {
        fillDiagonal()
        fillRemaining(i: 0, j: squareRoot)
        
        for i in 0..<n {
            for j in 0..<n {
                answers[i][j] = grid[i][j]
            }
        }
        
        removeKDigits()
    }
    
    func fillDiagonal() {
        for i in stride(from: 0, to: n, by: squareRoot) {
            fillBox(row: i, col: i)
        }
    }
    
    func fillBox(row: Int, col: Int) {
        var num = 0 // 6
        for i in 0..<squareRoot  { // 0
            for j in 0..<squareRoot { // 0
                while isUsedInBox(row, col, num) { // 3 3 0
                    num = randomGenerator(num: n)
                }
                grid[row+i][col+j] = num //
            }
        }
    }
    
    func isUsedInBox(_ rowStart: Int, _ colStart: Int, _ num: Int) -> Bool {// 3 3 2
        for i in 0..<squareRoot { // 0
            for j in 0..<squareRoot { // 0
                if (grid[rowStart + i][colStart + j] == num) { // [
                    return true
                }
            }
        }
        return false
    }
    
    
    func randomGenerator(num: Int) -> Int {
        let rand = Int(floor(Double.random(in: 0..<1) * Double(num) + 1))
        return rand
        
    }
    func fillRemaining(i: Int, j: Int) -> Bool {
        var i = i // 0
        var j = j // 3
        if i == n - 1 && j == n {
            return true
        }
        
        if j >= n {
            j = 0
            i += 1
        }
        
        if grid[i][j] != 0 {
            return fillRemaining(i: i, j: j + 1)
        }
        
        for num in 1...n {
            if checkIfSafe(i, j, num) {
                grid[i][j] = num
                if fillRemaining(i: i, j: j + 1) {
                    return true
                }
                grid[i][j] = 0
            }
        }
        
        return false
    }
    
    func checkIfSafe(_ i: Int, _ j: Int, _ num: Int) -> Bool {
        return (!isUsedInRow(i, num) &&
                !isUsedInCol(j, num) &&
                !isUsedInBox(i - i % squareRoot, j - j % squareRoot, num))
    }
    
    func isUsedInRow(_ i: Int, _ num: Int) -> Bool {
        for j in 0..<n { // 0
            if grid[i][j] == num {
                return true
            }
        }
        return false
    }
    
    func isUsedInCol(_ j: Int, _ num: Int) -> Bool {
        for i in 0..<n { // 0
            if grid[i][j] == num {
                return true
            }
        }
        return false
    }
    
    func removeKDigits() {
        var count = k
        
        while count != 0 {
            let cellId = randomGenerator(num: n * n) - 1
            let i = cellId / n
            var j = cellId % 9
            
            if j != 0 {
                j = j - 1
            }
            
            if grid[i][j] != 0 {
                count -= 1
                grid[i][j] = 0
            }
        }
    }
    
    
    func isCorrectGuess(_ row: Int, _ col: Int, _ num: Int) -> Bool {
        return answers[row - 1][col - 1] == num
    }
    
    func validate(_ row: Int, _ col: Int, _ num: Int) -> Bool {
        return row >= 1 && row <= 9 && col >= 1 && col <= 9 && num >= 0 && num <= 9
    }
    
    func updateGrid(row: Int, col: Int, value: Int) {
        grid[row - 1][col - 1] = value
    }
    
    func buildMap() -> String {
        var result = ""
        let horizontalBorder = getHorizontalBorder()
        
        result += getColumnKeys() + "\n" + horizontalBorder + "\n"
        
        for i in 0..<n {
            for j in 0..<n {
                var txt = "\(grid[i][j]) "
                if j == 0 {
                    txt = "\(i + 1) | \(grid[i][j]) "
                } else if j == n - 1 {
                    txt = "\(grid[i][j]) |"
                } else if (j + 1) % 3 == 0 {
                    txt = "\(grid[i][j]) | "
                }
                
                result += txt
            }
            
            if i == 2 || i == 5 {
                result += "\n" + horizontalBorder
            }
            result += "\n"
        }
        
        result += horizontalBorder + "\n"

        return result
    }
    
    func getColumnKeys() -> String {
        var result = ""
        for i in 0..<n {
            var txt = "\(i + 1) "
            if i == 0 {
                txt = "    \(i + 1) "
            } else if i == n - 1 {
                txt = "\(i + 1)  "
            } else if (i + 1) % 3 == 0 {
                txt = "\(i + 1)   "
            }
            result += txt
        }
        
        return result
    }
    
    func getHorizontalBorder() -> String {
        var bottomBorder = "  "
        
        let dashCounts = n * 2 + 2 + 1 + 4
        for _ in 0..<dashCounts {
            bottomBorder += "-"
        }
        
        return bottomBorder
    }
    
    func printSolver() {
        for i in 0..<n {
            for j in 0..<n {
                grid[i][j] = answers[i][j]
            }
        }
        
        print(buildMap())
    }
}

class Game {
    static let main_menu = 0
    static let game_levels = 1
    static let instruction_page = 2
    static let game = 3
    
    let menu = ["New Game", "Instructions", "Exit"]
    let levels = ["Easy", "Medium", "Hard"]
    let k_level_matcher = [30, 45, 55]
    let sudoku_width = 9
    
    var step: Int
    var started: Bool
    var sudoku: Sudoku?
    var validationError: String
    
    init() {
        self.step = 0
        self.started = false
        self.validationError = ""
    }
    
    func isStarted() -> Bool {
        return self.started
    }
    
    func setStarted(_ started: Bool) {
        self.started = started
    }
    
    func start(level: Int) {
        self.sudoku = Sudoku(n: sudoku_width, k: k_level_matcher[level - 1])
        self.sudoku?.fillValues()
        self.started = true
    }
    
    func printScreen() -> String {
        var screen = ""
        let back_menu_txt = "(enter 'MENU' to return to the main menu)"
        switch (self.step) {
        case Game.main_menu:
            for i in 0..<menu.count {
                let key = (i == menu.count - 1) ? "q" : String(i + 1)
                screen += "\(i + 1) \(menu[i]) (PRESS \(key))\n"
            }
            break
        case Game.game_levels:
            screen = "Choose Level:\n"
            for i in 0..<levels.count {
                screen += "\(i + 1) \(levels[i]) (PRESS \(i + 1))\n"
            }
            screen += back_menu_txt
            break
        case Game.instruction_page:
            screen = "About Game:\n"
            screen += "A Sudoku puzzle begins with a grid in which some of the numbers are already in place.\n"
            screen += "A puzzle is completed when each number from 1 to 9 appears only once in each of the rows, columns, and blocks.\n"
            screen += "Study the grid to find the numbers that might fit into each cell.\n\n"
            screen += "How to play:\n"
            screen += "To fill in a number, enter the row number, column number, and value of the number separated by spaces. For example: '1 2 5'.\n"
            screen += "This will place the number 5 in the second column of the first row.\n"
            screen += "Make sure that the number you enter follows the rules of Sudoku.\n"
            screen += "Each row, column, and 3x3 box must contain all of the numbers from 1 to 9 without any repeats.\n"
            screen += "Enter 0 to give up and run Sudoku solver to see the answers.\n"
            screen += back_menu_txt
            break
        case Game.game:
            screen = self.sudoku!.buildMap() + "\n"
            screen += "Enter 0 to give up and run Sudoku solver to see the answers" + "\n"
            screen += "Enter 'MENU' to return to the main menu" + "\n"
            screen += "Enter 'q' to quit" + "\n"
            screen += "Enter row, column, and guessed number (e.g. '1 1 3'), or 'q' to quit: \n"
            
            if !self.validationError.isEmpty {
                screen += self.validationError + "\n"
            }
            
            self.validationError = ""
            
            break
        default:
            screen = "Welcome to the game\(back_menu_txt)"
        }
        
        return screen
    }
    
    func setValidationError(_ message: String) {
        self.validationError = message
    }
    
    func validateChoice(_ choice: Int) -> Bool {
        if self.step == Game.main_menu && choice < menu.count {
            return true
        }
        
        if self.step == Game.game_levels && choice < levels.count {
            return true
        }
        
        return false
    }
    
    func setStep(_ step: Int) {
        self.step = step
    }
    
    func getStep() -> Int {
        return self.step
    }
}
