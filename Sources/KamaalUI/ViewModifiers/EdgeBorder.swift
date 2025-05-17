//
//  EdgeBorder.swift
//
//
//  Created by Kamaal M Farah on 17/04/2021.
//

import SwiftUI

extension View {
    public func kborder(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in self.edges {
            var xAs: CGFloat {
                switch edge {
                case .top, .bottom, .leading: rect.minX
                case .trailing: rect.maxX - width
                }
            }

            var yAs: CGFloat {
                switch edge {
                case .top, .leading, .trailing: rect.minY
                case .bottom: rect.maxY - width
                }
            }

            var width: CGFloat {
                switch edge {
                case .top, .bottom: rect.width
                case .leading, .trailing: self.width
                }
            }

            var height: CGFloat {
                switch edge {
                case .top, .bottom: self.width
                case .leading, .trailing: rect.height
                }
            }
            path.addPath(Path(CGRect(x: xAs, y: yAs, width: width, height: height)))
        }
        return path
    }
}

struct EdgeBorder_Previews: PreviewProvider {
    static var previews: some View {
        EdgeBorder(width: 1, edges: [.bottom])
    }
}
