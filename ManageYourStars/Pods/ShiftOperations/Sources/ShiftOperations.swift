//
//  ShiftOperations.swift
//  ShiftOperations
//
//  The MIT License (MIT)
//
//  Copyright (c) 2016-2017 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

/// A type that can use shift operators.
@available(swift, obsoleted: 4.0, message: "Functionality replaced by BinaryInteger")
public protocol ShiftOperations {

    /// Shifts `lhs` left by `rhs` and returns the result.
    static func << (lhs: Self, rhs: Self) -> Self

    /// Shifts `lhs` right by `rhs` and returns the result.
    static func >> (lhs: Self, rhs: Self) -> Self

    /// Shifts `lhs` left by `rhs`.
    static func <<= (lhs: inout Self, rhs: Self)

    /// Shifts `lhs` right by `rhs`.
    static func >>= (lhs: inout Self, rhs: Self)

}

#if !swift(>=4)

extension ShiftOperations {

    /// Shifts `lhs` left by `rhs`.
    public static func <<= (lhs: inout Self, rhs: Self) {
        lhs = lhs << rhs
    }

    /// Shifts `lhs` right by `rhs`.
    public static func >>= (lhs: inout Self, rhs: Self) {
        lhs = lhs >> rhs
    }

}

extension Int: ShiftOperations {
}

extension Int64: ShiftOperations {
}

extension Int32: ShiftOperations {
}

extension Int16: ShiftOperations {
}

extension Int8: ShiftOperations {
}

extension UInt: ShiftOperations {
}

extension UInt64: ShiftOperations {
}

extension UInt32: ShiftOperations {
}

extension UInt16: ShiftOperations {
}

extension UInt8: ShiftOperations {
}

#endif
