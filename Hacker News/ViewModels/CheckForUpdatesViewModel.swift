import Combine
import Foundation
#if canImport(Sparkle)
import Sparkle
#endif


final class CheckForUpdatesViewModel : ObservableObject 
{
    @Published var canCheckForUpdates = false

    private let updater: any AppUpdater
    private var observation: NSKeyValueObservation?

	init(updater: any AppUpdater) 
	{
        self.updater = updater
#if canImport(Sparkle)
        observation = updater.observe(
            \.canCheckForUpdates,
            options: [.initial, .new]
        ) { [weak self] updater, _ in
            DispatchQueue.main.async {
                self?.canCheckForUpdates = updater.canCheckForUpdates
            }
        }
		#endif
    }

    func checkForUpdates() {
        updater.checkForUpdates()
    }
}
