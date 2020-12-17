//
//  Conway.swift
//  AdventOfCode
//
//  Created by Jeff Kelley on 12/17/20.
//

import Foundation

struct GameOfLife<Point: NDimensionPoint> where Point: Neighbors {

    let alwaysEnabledPoints: Set<Point>
    let state: Set<Point>

    init(initialState: Set<Point>, alwaysEnabledPoints: Set<Point> = []) {
        self.alwaysEnabledPoints = alwaysEnabledPoints
        state = initialState.union(alwaysEnabledPoints)
    }

    func nextState() -> Self {
        var pointsToConsider = Set<Point>()

        for point in state {
            pointsToConsider.insert(point)
            pointsToConsider.formUnion(point.neighbors())
            pointsToConsider.formUnion(alwaysEnabledPoints)
        }

        var nextIteration = Set<Point>()

        for point in pointsToConsider {
            let activeNeighbors = point.neighbors().intersection(state)

            switch activeNeighbors.count {
            case 2 where state.contains(point), 3:
                nextIteration.insert(point)
            case _ where alwaysEnabledPoints.contains(point):
                nextIteration.insert(point)
            default:
                break
            }
        }

        return Self(initialState: nextIteration)
    }

}

struct BoundedGameOfLife<Point, Bounds: NDimensionPointBounds>
where Point: Neighbors, Point.Unit: Comparable, Bounds.Point == Point {

    let game: GameOfLife<Point>
    let bounds: Bounds
    var state: Set<Point> { game.state }

    init(initialState: Set<Point>,
         bounds: Bounds,
         alwaysEnabledPoints: Set<Point> = []) {
        self.bounds = bounds

        game = GameOfLife(
            initialState: initialState.filter(bounds.isIncluded),
            alwaysEnabledPoints: alwaysEnabledPoints.filter(bounds.isIncluded)
        )
    }

    func nextState() -> Self {
        let nextGameState = game.nextState().state.filter(bounds.isIncluded)

        return BoundedGameOfLife(initialState: nextGameState,
                                 bounds: bounds,
                                 alwaysEnabledPoints: game.alwaysEnabledPoints)
    }

}
