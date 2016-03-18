//
//  Zip3.swift
//  PieChart
//
//  Created by Maarten Schumacher on 14/01/16.
//  Copyright © 2016 Maarten Schumacher. All rights reserved.
//

import Foundation

/// Given three sequences, return a sequence of 3-tuples
public func zip3<A: SequenceType, B: SequenceType, C: SequenceType>(a: A, _ b: B, _ c: C)
    -> ZipSequence3<A, B, C>
{
    return ZipSequence3(a, b, c)
}

/// Sequence of tuples created from values from three other sequences
public struct ZipSequence3<A: SequenceType, B: SequenceType, C: SequenceType>: SequenceType {
    private var a: A
    private var b: B
    private var c: C
    
    public init (_ a: A, _ b: B, _ c: C) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    public func generate() -> ZipGenerator3<A.Generator, B.Generator, C.Generator> {
        return ZipGenerator3(a.generate(), b.generate(), c.generate())
    }
}

/// Generator that creates tuples of values from three other generators
public struct ZipGenerator3<A: GeneratorType, B: GeneratorType, C: GeneratorType>: GeneratorType {
    private var a: A
    private var b: B
    private var c: C
    
    public init(_ a: A, _ b: B, _ c: C) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    mutating public func next() -> (A.Element, B.Element, C.Element)? {
        switch (a.next(), b.next(), c.next()) {
        case let (.Some(aValue), .Some(bValue), .Some(cValue)):
            return (aValue, bValue, cValue)
        default:
            return nil
        }
    }
}