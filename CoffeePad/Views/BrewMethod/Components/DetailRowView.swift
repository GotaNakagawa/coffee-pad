import Inject
import SwiftUI

struct DetailRowView: View {
    @ObserveInjection var inject
    let imageName: String
    let label: String
    let value: String
    let memo: String?
    let imageIsSystem: Bool
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                if self.imageIsSystem {
                    Image(systemName: self.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.primary)
                } else {
                    Image(self.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }

                Text(self.label)
                    .font(.body)
                    .foregroundColor(.primary)

                Spacer()

                Text(self.value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if !self.isLast {
                Divider()
                    .padding(.leading, 52)
            }
        }
        .enableInjection()
    }
}

struct StepRowView: View {
    @ObserveInjection var inject
    let step: BrewStep
    let stepNumber: Int
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(self.stepNumber). \(self.step.title)")
                        .font(.body)
                        .foregroundColor(.primary)

                    if let subOption = step.subOption, !subOption.isEmpty {
                        Text(subOption)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                HStack(spacing: 8) {
                    if let time = step.time {
                        Text("\(time)秒")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    if let weight = step.weight {
                        Text("\(weight)ml")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            if !self.isLast {
                Divider()
                    .padding(.leading, 52)
            }
        }
        .enableInjection()
    }
}

struct CommentRowView: View {
    @ObserveInjection var inject
    let comment: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "text.bubble")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundColor(.primary)

            Text(self.comment)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .enableInjection()
    }
}
