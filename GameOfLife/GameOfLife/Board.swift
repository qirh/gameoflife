//
//  Board.swift
//  GameOfLife
//
//  Created by saleh on 7/19/17.
//  Copyright © 2017 saleh. All rights reserved.
//

import Foundation
import UIKit

//a lot of the structure of this model was copied from the helper code provided by the instructor of this course
typealias CellPoint = (col: Int, row: Int)

enum CellState {
    case Alive
    case Born   //just lived this generation
    
    case Empty
    case Died   //just died this generation
    
    var isAlive: Bool {
        get {
            return self == .Alive || self == .Born
        }
    }
}
protocol LifeDataSource {
    func moveToNextGeneration()
    func setCellAt(point: CellPoint, toState : CellState)
    func cellStateAt(point: CellPoint) -> CellState
    func reset()
    var generation: Int { get }
    var size: Int { get }
}
class Board: LifeDataSource{
    
    //private var board: [[String]] = Array(repeating: Array(repeating: 0, count: 24), count: 24)
    
    //  information about multi-dimenonsonal arryas obtained from here:
    //  http://dev.iachieved.it/iachievedit/multidimensional-arrays-in-swift/
    var generation: Int
    var size: Int
    private var previousGrid: [[CellState]]
    private var grid: [[CellState]]
    
    let MAXSIZE = 100
    let MINSIZE = 5
    
    init(generationInput: Int = 0, size sizeInput: Int, defaultState: CellState = .Empty){
        generation = generationInput
        size = sizeInput
        grid = [[CellState]](repeating: [CellState](repeating: defaultState, count: size), count: size)
        previousGrid = [[CellState]](repeating: [CellState](repeating: defaultState, count: size), count: size)
    }
    
    func countNeighborsWithToroidTopology(point: CellPoint) -> Int {
        var count = 0
        
        for neighborXOffset in -1...1 {
            for neighborYOffset in -1...1 {
                guard !(neighborXOffset == 0 && neighborYOffset == 0) else {
                    continue // self isn't a neighbor
                }
                var neighbor: CellPoint
                var x: Int
                var y: Int
                if(point.col + neighborXOffset) >= 0{
                    x = (point.col + neighborXOffset)%size
                }
                else{
                    x = point.col + neighborXOffset + size
                }
                if (point.row + neighborYOffset) >= 0{
                    y = (point.row + neighborYOffset)%size
                }
                else{
                    y = point.row + neighborYOffset + size
                }
                neighbor = CellPoint(col: x, row: y)
                
                if previousGrid[neighbor.col][neighbor.row].isAlive {
                    count += 1
                }
            }
        }
        return count
    }
    
    func reset() {
        previousGrid.removeAll()
        grid.removeAll()
    }
    func pressedCell(point: CellPoint) {
        
        grid[point.col][point.row] = .Alive
    }

    func cellStateAt(point: CellPoint) -> CellState {
        return grid[point.col][point.row]
    }
    
    func setCellAt(point: CellPoint, toState: CellState) {
        grid[point.col][point.row] = toState
    }
    func setAllCells(toState: CellState) {
        for i in 0...size{
            for j in 0...size{
                grid[i][j] = toState
            }
        }

    }
    func getStates() -> [CellState]{
        var states = [CellState]()
        
        for i in 0..<size{
            for j in 0..<size{
                
                states.append(grid[i][j])
            }
        }
        
        return states
    }
    func moveToNextGeneration() {
        copyGrid()
        
        for i in 0..<size{
            for j in 0..<size{
                let neighborCount = countNeighborsWithToroidTopology(point: CellPoint(i,j))
                
                
                if(grid[i][j] == .Alive || grid[i][j] == .Born){
                    if(neighborCount < 2 || neighborCount > 3){
                        
                        grid[i][j] = .Died
                    }
                    else if(neighborCount == 2 || neighborCount == 3){
                        
                        grid[i][j] = .Alive
                    }
                    else{
                        
                    }
                }
                else{
                    if(neighborCount == 3){
                        
                        grid[i][j] = .Born
                    }
                    else{
                        
                    }
                }
            }
        }
        
        increaseGeneration()
    }
    func getSize() -> Int {
        return size
    }
    func setSize(size: Int) {
        if(size <= MAXSIZE && size >= MINSIZE){
            self.size = size
        }
    }
    func getGeneration() -> Int {
        return generation
    }
    func setGeneration(generation: Int) {
        self.generation = generation
    }
    func increaseGeneration(by: Int = 1) {
        self.generation += by
    }
    func copyGrid(){
        
        for i in 0..<size{
            for j in 0..<size{
                previousGrid[i][j] = grid[i][j]
            }
        }
    }
}
