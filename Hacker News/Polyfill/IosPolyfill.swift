//	this project is macos based, so ios/UIKit needs polyfill

#if canImport(UIKit)
import UIKit
import SwiftUI

//	mac -> ios polyfill
typealias NSImage = UIImage
typealias NSViewRepresentable = UIViewRepresentable
typealias NSView = UIView

extension NSImage
{
	convenience init?(contentsOf: URL)
	{
		self.init(systemName: "figure.run")
	}
}

extension Image
{
	init(nsImage:NSImage)
	{
		self.init(uiImage: nsImage)
	}
}


class NSCursor
{
	static let pointingHand = NSCursor()
	
	func push()			{} 
	static func pop()	{}
}

extension UIColor
{
	static var windowBackgroundColor : UIColor
	{
		return .blue
	}
}

#endif
