
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
