//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Mina Emad on 02/11/2024.
//

import UIKit

class HomeViewController: UIViewController {

    var coordinator: Coordinator!

    override func viewDidLoad() {
        super.viewDidLoad()

        let customView = HomeView()
        customView.frame = view.bounds // Set frame for the custom view
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // Resize with parent view
        customView.coordinator = coordinator // Set the coordinator
        
        view.addSubview(customView)
    }

}
