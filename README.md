# PolyKit

## Add to App

- *File* / *Swift Packages* / *Add Package Dependecy*
- Search for **PolyKit** by **hexagons**
- Add *Up to Next Major* from **1.0.0**

## Example

~~~~swift
import SwiftUI
import PolyKit

struct ContentView: View {
    var body: some View {
        Poly(count: 6, cornerRadius: 60)
    }
}
~~~~

## Add to Package

~~~~swift
.package(url: "https://github.com/hexagons/PolyKit.git", from: "1.0.0")
~~~~
