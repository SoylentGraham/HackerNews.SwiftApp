//
//  CrossPlatform.swift
//  Hacker News
//
//  Created by Graham Reeves on 23/02/2026.
//
import SwiftUI


func OpenUrlInExternalApp(_ url:URL)
{
	#if canImport(AppKit)
	NSWorkspace.shared.open(url)
	#endif
	
	#if canImport(UIKit)
	UIApplication.shared.open(url)
	#endif
}
