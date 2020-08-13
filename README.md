# PolyKit

Rounded Polygons in SwiftUI

<img src="https://github.com/hexagons/PolyKit/blob/main/Assets/3.png?raw=true" height="100" /> &nbsp;&nbsp; <img src="https://github.com/hexagons/PolyKit/blob/main/Assets/4.png?raw=true" height="100" /> &nbsp;&nbsp;&nbsp; <img src="https://github.com/hexagons/PolyKit/blob/main/Assets/5.png?raw=true" height="100" /> &nbsp;&nbsp;&nbsp; <img src="https://github.com/hexagons/PolyKit/blob/main/Assets/6.png?raw=true" height="100" /> &nbsp;&nbsp;&nbsp; <img src="https://github.com/hexagons/PolyKit/blob/main/Assets/7.png?raw=true" height="100" />


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
