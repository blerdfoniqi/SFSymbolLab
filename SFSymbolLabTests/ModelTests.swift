import Testing
import SwiftUI
@testable import SFSymbolLab

// MARK: - DemoSection

@MainActor
@Suite("DemoSection")
struct DemoSectionTests {
    @Test("Exposes all seven demo sections")
    func sevenSections() {
        #expect(DemoSection.allCases.count == 7)
    }

    @Test("id mirrors rawValue")
    func idMatchesRawValue() {
        for section in DemoSection.allCases {
            #expect(section.id == section.rawValue)
        }
    }

    @Test("Every section has non-empty metadata")
    func metadataPopulated() {
        for section in DemoSection.allCases {
            #expect(!section.title.isEmpty)
            #expect(!section.icon.isEmpty)
            #expect(!section.description.isEmpty)
        }
    }

    @Test("Titles are unique")
    func uniqueTitles() {
        let titles = DemoSection.allCases.map(\.title)
        #expect(Set(titles).count == titles.count)
    }
}

// MARK: - RenderingModeOption

@MainActor
@Suite("RenderingModeOption")
struct RenderingModeOptionTests {
    @Test("Wraps the four rendering modes")
    func fourModes() {
        #expect(RenderingModeOption.allCases.count == 4)
    }

    @Test("id mirrors rawValue")
    func idMatchesRawValue() {
        for mode in RenderingModeOption.allCases {
            #expect(mode.id == mode.rawValue)
        }
    }

    @Test("Titles, short titles and descriptions are non-empty")
    func labelsPopulated() {
        for mode in RenderingModeOption.allCases {
            #expect(!mode.title.isEmpty)
            #expect(!mode.shortTitle.isEmpty)
            #expect(!mode.description.isEmpty)
        }
    }

    @Test("rawValue round-trips to the matching case")
    func rawValueMapping() {
        // SymbolRenderingMode isn't Equatable, so assert the rawValue contract
        // that drives `renderingMode` instead.
        #expect(RenderingModeOption(rawValue: "monochrome") == .monochrome)
        #expect(RenderingModeOption(rawValue: "hierarchical") == .hierarchical)
        #expect(RenderingModeOption(rawValue: "palette") == .palette)
        #expect(RenderingModeOption(rawValue: "multicolor") == .multicolor)
    }
}

// MARK: - AnimationEffectOption

@MainActor
@Suite("AnimationEffectOption")
struct AnimationEffectOptionTests {
    @Test("Exposes five effects including none")
    func fiveEffects() {
        #expect(AnimationEffectOption.allCases.count == 5)
        #expect(AnimationEffectOption.allCases.contains(.none))
    }

    @Test("id mirrors rawValue")
    func idMatchesRawValue() {
        for effect in AnimationEffectOption.allCases {
            #expect(effect.id == effect.rawValue)
        }
    }

    @Test("Every effect has a title and icon")
    func metadataPopulated() {
        for effect in AnimationEffectOption.allCases {
            #expect(!effect.title.isEmpty)
            #expect(!effect.icon.isEmpty)
        }
    }
}
