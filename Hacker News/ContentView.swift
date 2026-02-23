import SwiftUI

struct ContentView: View {
    @State private var viewModel = FeedViewModel()
    @State private var authManager = HNAuthManager()
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility
        ) {
            Group {
                SidebarView(viewModel: viewModel)
                    .toolbar(removing: .sidebarToggle)
            }
            .navigationSplitViewColumnWidth(min: 250, ideal: 375, max: 375)
        } detail: {
            DetailView(viewModel: viewModel, authManager: authManager, columnVisibility: $columnVisibility)
        }
        .task {
            await authManager.restoreSession()
            viewModel.loggedInUsername = authManager.isLoggedIn ? authManager.username : nil
            await viewModel.loadFeed()
        }
        .onChange(of: authManager.isLoggedIn) {
            viewModel.loggedInUsername = authManager.isLoggedIn ? authManager.username : nil
            if !authManager.isLoggedIn && viewModel.contentType.requiresAuth {
                viewModel.contentType = .all
            }
        }
        .onAppear {
            applyAppearance(viewModel.appearanceMode)
        }
        .onChange(of: viewModel.appearanceMode) {
            applyAppearance(viewModel.appearanceMode)
        }
        .frame(minWidth: 900, minHeight: 600)
        .navigationTitle("Hacker News")
        .background(WindowTabTitleSetter(title: tabTitle))
        .focusedSceneValue(\.feedViewModel, viewModel)
    }

    private var tabTitle: String {
        if viewModel.showingSettings {
            return "Settings"
        }
        if let profileURL = viewModel.viewingUserProfileURL {
            if profileURL.absoluteString.contains("/submit") {
                return "Submit"
            }
            return "Profile"
        }
        if let story = viewModel.selectedStory {
            let title = story.title ?? story.storyTitle ?? "Hacker News"
            let suffix: String
            if story.type == "comment" || story.displayURL == nil {
                suffix = ""
            } else {
                switch viewModel.viewMode {
                case .post: suffix = " — Post"
                case .comments: suffix = " — Comments"
                case .both: suffix = " — Split Pane"
                }
            }
            return title + suffix
        }
        return "Homepage"
    }

	private struct WindowTabTitleSetter: NSViewRepresentable {
		typealias UIViewType = NSView
		typealias NSViewType = NSView
		
        let title: String

		func makeNSView(context: Context) -> NSViewType {
			let view = NSView()
			DispatchQueue.main.async {
#if canImport(AppKit)
				view.window?.tab.title = title
#endif
			}
			return view
		}
		
		func makeUIView(context: Context) -> UIViewType {
			return makeNSView(context: context)
		}

		func updateNSView(_ nsView: NSView, context: Context) 
		{
			#if canImport(AppKit)
			nsView.window?.tab.title = title
			#endif
		}
		func updateUIView(_ nsView: NSViewType, context: Context) {
			updateNSView(nsView,context: context)
		}
    }

    private func applyAppearance(_ mode: AppearanceMode) 
	{
#if canImport(UIKit)
		UIApplication.shared.windows.first?.overrideUserInterfaceStyle = mode.uiUserInterfaceStyle
#endif

		//	gr: there must be an ios version of this...
#if canImport(AppKit)
		NSApp.appearance = mode.nsAppearance
#endif
    }
}
