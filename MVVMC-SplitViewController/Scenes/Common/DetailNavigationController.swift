//
//  DetailNavigationController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/29/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit

class DetailNavigationController: UINavigationController {

    init() {
        super.init(nibName: nil, bundle: nil)
        delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isTranslucent = false
    }

}

// MARK: - UINavigationControllerDelegate
extension DetailNavigationController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard operation == .push, toVC is EmptyDetailViewController else {
            return nil
        }

        return NavigationControllerAnimator(operation: operation)
    }

}

// MARK: - Animator
class NavigationControllerAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let operation: UINavigationControllerOperation

    init(operation: UINavigationControllerOperation) {
        self.operation = operation
        super.init()
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }

        if operation == .push {
            switch toViewController is EmptyDetailViewController {
            case true:
                animatePushAsPop(from: fromViewController, to: toViewController, using: transitionContext)
            case false:
                animatePush(from: fromViewController, to: toViewController, using: transitionContext)
            }
        } else if operation == .pop {
            animatePop(from: fromViewController, to: toViewController, using: transitionContext)
        }
    }

    // MARK: - Push / Pop

    private func animatePush(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        let dx = containerView.frame.size.width
        toVC.view.frame = finalFrame.offsetBy(dx: dx, dy: 0.0)
        containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIViewAnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
                fromVC.view.frame = finalFrame.offsetBy(dx: dx / -2.5, dy: 0.0)
        },
            completion: { (finished) in transitionContext.completeTransition(true) }
        )
    }

    private func animatePushAsPop(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let finalFrame = transitionContext.finalFrame(for: toVC)

        let dx = containerView.frame.size.width
        toVC.view.frame = finalFrame.offsetBy(dx: dx / -2.5, dy: 0.0)
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIViewAnimationOptions.curveEaseOut ],
            animations: {
                toVC.view.frame = transitionContext.finalFrame(for: toVC)
                fromVC.view.frame = finalFrame.offsetBy(dx: dx, dy: 0.0)
        },
            completion: { (finished) in transitionContext.completeTransition(true) }
        )
    }

    private func animatePop(from fromVC: UIViewController, to toVC: UIViewController, using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        containerView.addSubview(toVC.view)

        UIView.animate(
            withDuration: transitionDuration(using: transitionContext), delay: 0,
            options: [ UIViewAnimationOptions.curveEaseOut ],
            animations: {
                fromVC.view.frame = containerView.bounds.offsetBy(dx: containerView.frame.width, dy: 0)
                toVC.view.frame = containerView.bounds
            },
            completion: { (finished) in transitionContext.completeTransition(true) }
        )
    }

}
