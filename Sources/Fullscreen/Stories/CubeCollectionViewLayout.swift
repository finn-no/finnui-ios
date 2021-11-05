import Foundation
import UIKit

public final class CubeCollectionViewLayout: UICollectionViewFlowLayout {
    private var animator = CubeAttributesAnimator()

    // MARK: - Init

    public override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        sectionInset = .zero
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override class var layoutAttributesClass: AnyClass { AnimatedCollectionViewLayoutAttributes.self }
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool { true }

    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)?
            .compactMap({ $0.copy() as? AnimatedCollectionViewLayoutAttributes })
            .map(transformLayoutAttributes(_:))
    }

    public override func prepare() {
        super.prepare()

        if let collectionView = collectionView {
            itemSize = collectionView.bounds.size
        }
    }

    // MARK: - Layout attributes

    private func transformLayoutAttributes(
        _ attributes: AnimatedCollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        guard let collectionView = collectionView else { return attributes }

        let distance = collectionView.frame.width
        let itemMiddleOffset = attributes.center.x - collectionView.contentOffset.x
        let itemOriginOffset = attributes.frame.origin.x - collectionView.contentOffset.x

        //attributes.size = collectionView.bounds.size
        attributes.startOffset = itemOriginOffset / attributes.frame.width
        attributes.middleOffset = itemMiddleOffset / distance - 0.5
        attributes.endOffset = (itemOriginOffset - collectionView.frame.width) / attributes.frame.width

        if attributes.contentView == nil {
            attributes.contentView = collectionView.cellForItem(at: attributes.indexPath)?.contentView
        }

        animator.animate(collectionView: collectionView, attributes: attributes)

        return attributes
    }
}

/// A custom layout attributes with extra information.
private class AnimatedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var startOffset: CGFloat = 0
    var middleOffset: CGFloat = 0
    var endOffset: CGFloat = 0
    var contentView: UIView?

    override func copy(with zone: NSZone? = nil) -> Any {
        guard let copy = super.copy(with: zone) as? AnimatedCollectionViewLayoutAttributes else {
            return super.copy(with: zone)
        }
        copy.startOffset = startOffset
        copy.middleOffset = middleOffset
        copy.endOffset = endOffset
        copy.contentView = contentView
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? AnimatedCollectionViewLayoutAttributes else { return false }
        return super.isEqual(object)
            && object.startOffset == startOffset
            && object.middleOffset == middleOffset
            && object.endOffset == endOffset
            && object.contentView == contentView
    }
}

/// Animator
private struct CubeAttributesAnimator {
    var perspective: CGFloat
    var totalAngle: CGFloat

    init(perspective: CGFloat = -1 / 500, totalAngle: CGFloat = .pi / 2) {
        self.perspective = perspective
        self.totalAngle = totalAngle
    }

    func animate(collectionView: UICollectionView, attributes: AnimatedCollectionViewLayoutAttributes) {
        let position = attributes.middleOffset

        if abs(position) >= 1 {
            attributes.contentView?.layer.transform = CATransform3DIdentity
            attributes.contentView?.setAnchorPoint(CGPoint(x: 0.5, y: 0.5))
        } else {
            let rotateAngle = totalAngle * position
            var transform = CATransform3DIdentity
            transform.m34 = perspective
            transform = CATransform3DRotate(transform, rotateAngle, 0, 1, 0)
            attributes.contentView?.layer.transform = transform
            attributes.contentView?.setAnchorPoint(CGPoint(x: position > 0 ? 0 : 1, y: 0.5))
        }
    }
}

// MARK: - Private extensions

private extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        guard layer.anchorPoint != point else { return }

        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}
