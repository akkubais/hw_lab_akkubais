import Charts
import SwiftUI

struct ChartsView: View {
    @EnvironmentObject private var library: Library

    private var genderCounts: [(name: String, count: Int)] {
        [
            (Gender.female.rawValue, library.getFemaleAuthoredBooks().count),
            (Gender.male.rawValue, library.getMaleAuthoredBooks().count)
        ]
    }

    private let selectedAuthors = [
        "William Shakespeare",
        "Jane Austen",
        "J.R.R. Tolkien",
        "Charles Dickens",
        "Charlotte Bronte"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    chartCard(title: "Books by Author Gender") {
                        Chart(genderCounts, id: \.name) { item in
                            BarMark(
                                x: .value("Gender", item.name),
                                y: .value("Books", item.count)
                            )
                            .foregroundStyle(by: .value("Gender", item.name))
                            .annotation(position: .top) {
                                Text("\(item.count)")
                                    .font(.caption.bold())
                            }
                        }
                        .chartLegend(position: .bottom)
                        .frame(height: 220)
                        .accessibilityIdentifier("gender-chart")
                    }

                    chartCard(title: "Books by Selected Authors") {
                        Chart(selectedAuthors, id: \.self) { author in
                            BarMark(
                                x: .value("Books", library.getBooksFor(author).count),
                                y: .value("Author", author)
                            )
                            .foregroundStyle(.green.gradient)
                            .annotation(position: .trailing) {
                                Text("\(library.getBooksFor(author).count)")
                                    .font(.caption.bold())
                            }
                        }
                        .frame(height: 220)
                        .accessibilityIdentifier("author-chart")
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Library Charts")
        }
    }

    private func chartCard<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            Text(title)
                .font(.title3.bold())
            content()
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.06), radius: 8, y: 3)
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
            .environmentObject(Library())
    }
}
