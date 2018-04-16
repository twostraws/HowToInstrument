//
//  AppDelegate.swift
//  HowToInstrument
//
//  Created by Paul Hudson on 04/16/2018.
//  Copyright © 2018 Paul Hudson. All rights reserved.
//
//  This is an example app that is specifically designed
//  to be bad. If you're looking for great code to learn
//  from, this is the literal antithesis.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var delegate: ViewController?

    @IBOutlet var webView: WKWebView!
    var newsTitle = ""

    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Read article"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "😍", style: .plain, target: self, action: #selector(loveTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "😡", style: .plain, target: self, action: #selector(hateTapped))

        let str = generateHTML()
        webView.loadHTMLString(str, baseURL: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { [weak self] timer in
                self?.webView.scrollView.contentOffset.y += 0.3
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @objc func loveTapped() {
        delegate?.love(newsTitle)
    }

    @objc func hateTapped() {
        delegate?.hate(newsTitle)
    }

    func generateHTML() -> String {
        return "<style>body { margin: 20px } h1 { font-family: sans-serif; font-size: 64px }  p { font-family: sans-serif; font-size: 40px } </style><h1>\(newsTitle)</h1><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p><p>This is a very long news article that is totally realistic oh yes it is, and not at all completely made up for the purpose of this example project.</p>"
    }
}

