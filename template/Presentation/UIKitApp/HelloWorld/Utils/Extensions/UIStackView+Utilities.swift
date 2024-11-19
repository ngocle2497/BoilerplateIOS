import Foundation
import UIKit

extension UIStackView {
    @discardableResult
    func alignment(_ alignment: Alignment) -> UIStackView {
        self.alignment = alignment
        return self
    }

    @discardableResult
    func distribution(_ distribution: Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }

    @discardableResult
    func spacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }

    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        self.axis = axis
        return self
    }

    @discardableResult
    func addingArrangedSubviews(_ arrangedSubviews: [UIView]) -> UIStackView {
        arrangedSubviews.forEach {
            self.addArrangedSubview($0)
        }

        return self
    }

    @discardableResult
    func preparedForAutoLayout() -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func addingArrangedSubviews(@SubviewsBuilder content: () -> [UIView]) -> UIStackView {
        for sv in content() {
            addArrangedSubview(sv)
            sv.translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }
}
