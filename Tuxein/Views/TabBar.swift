//
//  TabBar.swift
//  Tuxein
//
//  Created by Ewan Bigotte on 09/06/2026.
//

import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Int;

    @Namespace private var tabAnimation;
    @FocusState private var isSearchFocused: Bool;
    @State private var isSearchExpanded = false;
    @State private var searchText = "";

    private let tint = Color.purple
    private let tabs = ["atom", "heart.fill", "gear"]

    var body: some View {
        HStack(spacing: 10) {
            tabsContainer

            searchButton
        }
        .padding(.horizontal, 10)
        .animation(.snappy(duration: 0.28), value: isSearchExpanded)
    }

    private var tabsContainer: some View {
        HStack(spacing: 6) {
            ForEach(tabs.indices, id: \.self) { index in
                Button {
                    selectTab(index)
                } label: {
                    Image(systemName: tabs[index])
                        .font(.system(size: 19, weight: .semibold))
                        .symbolEffect(.bounce, value: selectedTab == index)
                        .frame(width: 48, height: 42)
                        .foregroundStyle(selectedTab == index ? tint : .secondary)
                        .background {
                            if selectedTab == index {
                                Capsule(style: .continuous)
                                    .fill(tint.opacity(0.16))
                                    .matchedGeometryEffect(id: "TAB_SELECTION", in: tabAnimation)
                            }
                        }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(accessibilityLabel(for: index))
            }
        }
        .padding(6)
        .glassBarBackground()
    }

    private var searchButton: some View {
        HStack(spacing: 8) {
            Button {
                toggleSearch()
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .foregroundStyle(isSearchExpanded ? tint : .secondary)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Search")

            if isSearchExpanded {
                TextField("Search", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .medium))
                    .focused($isSearchFocused)
                    .submitLabel(.search)
                    .transition(.move(edge: .trailing).combined(with: .opacity))

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .frame(width: isSearchExpanded ? 174 : 48, height: 54)
        .padding(.horizontal, isSearchExpanded ? 10 : 3)
        .glassBarBackground()
    }

    private func selectTab(_ index: Int) {
        withAnimation(.snappy(duration: 0.28)) {
            selectedTab = index
            isSearchExpanded = false
        }

        isSearchFocused = false
    }

    private func toggleSearch() {
        withAnimation(.snappy(duration: 0.28)) {
            isSearchExpanded.toggle()
        }

        isSearchFocused = isSearchExpanded
    }

    private func accessibilityLabel(for index: Int) -> String {
        switch index {
        case 0:
            "Proteins"
        case 1:
            "Favorites"
        default:
            "Settings"
        }
    }
}

private extension View {
    func glassBarBackground() -> some View {
        background(.ultraThinMaterial, in: Capsule(style: .continuous))
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(.white.opacity(0.28), lineWidth: 0.7)
            }
            .shadow(color: .black.opacity(0.1), radius: 18, x: 0, y: 8)
    }
}

#Preview {
    PreviewWrapper()
        .padding()
}

private struct PreviewWrapper: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [.purple.opacity(0.35), .blue.opacity(0.4), .clear],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()

            TabBar(selectedTab: $selectedTab)
        }
    }
}
