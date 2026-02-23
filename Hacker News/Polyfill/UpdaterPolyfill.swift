
protocol AppUpdater
{
	func checkForUpdates()
}

extension SPUUpdater : AppUpdater
{
}

#if canImport(UIKit)
class AppStoreUpdater
{
	func checkForUpdates()	{}
}
#endif


#if !canImport(Sparkle)
struct SPUUpdater
{
	var automaticallyChecksForUpdates = false
	
	func checkForUpdatesInBackground()
	{
	}
	
	func checkForUpdates()
	{
	}
	
	func observe(_ key:KeyPath<SPUUpdater,Int>,_ callback:(Self,Int)->Void)
	{
	}
}
struct SPUUpdatedDelegate
{
}
struct SPUUserDriverDelegate
{
}
struct SPUStandardUpdaterController
{
	var startingUpdater : Bool
	var updaterDelegate: SPUUpdatedDelegate?
	var userDriverDelegate : SPUUserDriverDelegate?
	var updater = SPUUpdater()
}
#endif
