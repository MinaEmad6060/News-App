//
//  Coordinator.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit

class Coordinator {
    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func pushViewController<T: UIViewController>(viewController: T) {
        // Optionally set the coordinator for the view controller
        if var viewControllerWithCoordinator = viewController as? CoordinatorProtocol {
            viewControllerWithCoordinator.coordinator = self
        }
        navigationController?.pushViewController(viewController, animated: true)
    }


    func popToViewController<T: UIViewController>(ofType type: T.Type, animated: Bool) {
        if let viewControllers = navigationController?.viewControllers {
            for controller in viewControllers {
                if controller is T {
                    navigationController?.popToViewController(controller, animated: animated)
                    return
                }
            }
        }
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }

}

protocol CoordinatorProtocol {
    var coordinator: Coordinator? { get set }
}
