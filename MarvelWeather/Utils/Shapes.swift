//
//  Shapes.swift
//  MarvelWeather
//
//  Created by Waliok on 18/04/2023.
//

import SwiftUI

struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX - 1, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX + 1, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX + 1, y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX - 1, y: rect.maxY + 1))
        path.closeSubpath()
        
        return path
    }
}

struct Trapezoid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0, y: 0.37965*height))
        path.addCurve(to: CGPoint(x: 0.03312*width, y: 0.02995*height), control1: CGPoint(x: 0, y: 0.18083*height), control2: CGPoint(x: 0, y: 0.08142*height))
        path.addCurve(to: CGPoint(x: 0.21492*width, y: 0.04559*height), control1: CGPoint(x: 0.06623*width, y: -0.02153*height), control2: CGPoint(x: 0.1158*width, y: 0.00085*height))
        path.addLine(to: CGPoint(x: 0.9003*width, y: 0.35499*height))
        path.addCurve(to: CGPoint(x: 0.98602*width, y: 0.42173*height), control1: CGPoint(x: 0.94813*width, y: 0.37658*height), control2: CGPoint(x: 0.97204*width, y: 0.38738*height))
        path.addCurve(to: CGPoint(x: width, y: 0.59997*height), control1: CGPoint(x: width, y: 0.45609*height), control2: CGPoint(x: width, y: 0.50405*height))
        path.addLine(to: CGPoint(x: width, y: 0.74857*height))
        path.addCurve(to: CGPoint(x: 0.98116*width, y: 0.96318*height), control1: CGPoint(x: width, y: 0.8671*height), control2: CGPoint(x: width, y: 0.92636*height))
        path.addCurve(to: CGPoint(x: 0.87135*width, y: height), control1: CGPoint(x: 0.96232*width, y: height), control2: CGPoint(x: 0.93199*width, y: height))
        path.addLine(to: CGPoint(x: 0.12865*width, y: height))
        path.addCurve(to: CGPoint(x: 0.01884*width, y: 0.96318*height), control1: CGPoint(x: 0.06801*width, y: height), control2: CGPoint(x: 0.03768*width, y: height))
        path.addCurve(to: CGPoint(x: 0, y: 0.74857*height), control1: CGPoint(x: 0, y: 0.92636*height), control2: CGPoint(x: 0, y: 0.8671*height))
        path.addLine(to: CGPoint(x: 0, y: 0.37965*height))
        path.closeSubpath()
        return path
    }
}

struct MidButtonCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.42105*width, y: 0))
        path.addLine(to: CGPoint(x: 0.57895*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.77343*width, y: 0.48699*height), control1: CGPoint(x: 0.69925*width, y: 0), control2: CGPoint(x: 0.73497*width, y: 0.2414*height))
        path.addCurve(to: CGPoint(x: 0.98496*width, y: height), control1: CGPoint(x: 0.81325*width, y: 0.74125*height), control2: CGPoint(x: 0.85338*width, y: height))
        path.addLine(to: CGPoint(x: 0.01504*width, y: height))
        path.addCurve(to: CGPoint(x: 0.22657*width, y: 0.48699*height), control1: CGPoint(x: 0.14662*width, y: height), control2: CGPoint(x: 0.18675*width, y: 0.74125*height))
        path.addCurve(to: CGPoint(x: 0.42105*width, y: 0), control1: CGPoint(x: 0.26503*width, y: 0.2414*height), control2: CGPoint(x: 0.30075*width, y: 0))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.42105*width, y: 0.0025*height))
        path.addLine(to: CGPoint(x: 0.57895*width, y: 0.0025*height))
        path.addCurve(to: CGPoint(x: 0.70616*width, y: 0.15301*height), control1: CGPoint(x: 0.63881*width, y: 0.0025*height), control2: CGPoint(x: 0.67755*width, y: 0.0625*height))
        path.addCurve(to: CGPoint(x: 0.77065*width, y: 0.47575*height), control1: CGPoint(x: 0.73387*width, y: 0.2407*height), control2: CGPoint(x: 0.75208*width, y: 0.35704*height))
        path.addCurve(to: CGPoint(x: 0.77256*width, y: 0.48795*height), control1: CGPoint(x: 0.77129*width, y: 0.47981*height), control2: CGPoint(x: 0.77192*width, y: 0.48388*height))
        path.addLine(to: CGPoint(x: 0.77295*width, y: 0.49042*height))
        path.addCurve(to: CGPoint(x: 0.84408*width, y: 0.84048*height), control1: CGPoint(x: 0.79272*width, y: 0.61665*height), control2: CGPoint(x: 0.81271*width, y: 0.74427*height))
        path.addCurve(to: CGPoint(x: 0.95455*width, y: 0.9975*height), control1: CGPoint(x: 0.87057*width, y: 0.92173*height), control2: CGPoint(x: 0.90518*width, y: 0.98054*height))
        path.addLine(to: CGPoint(x: 0.04546*width, y: 0.9975*height))
        path.addCurve(to: CGPoint(x: 0.15592*width, y: 0.84048*height), control1: CGPoint(x: 0.09483*width, y: 0.98054*height), control2: CGPoint(x: 0.12943*width, y: 0.92173*height))
        path.addCurve(to: CGPoint(x: 0.22705*width, y: 0.49042*height), control1: CGPoint(x: 0.1873*width, y: 0.74427*height), control2: CGPoint(x: 0.20728*width, y: 0.61665*height))
        path.addLine(to: CGPoint(x: 0.22744*width, y: 0.48795*height))
        path.addCurve(to: CGPoint(x: 0.22935*width, y: 0.47575*height), control1: CGPoint(x: 0.22808*width, y: 0.48388*height), control2: CGPoint(x: 0.22871*width, y: 0.47981*height))
        path.addCurve(to: CGPoint(x: 0.29384*width, y: 0.15301*height), control1: CGPoint(x: 0.24792*width, y: 0.35704*height), control2: CGPoint(x: 0.26613*width, y: 0.2407*height))
        path.addCurve(to: CGPoint(x: 0.42105*width, y: 0.0025*height), control1: CGPoint(x: 0.32245*width, y: 0.0625*height), control2: CGPoint(x: 0.36119*width, y: 0.0025*height))
        path.closeSubpath()
        return path
    }
}
