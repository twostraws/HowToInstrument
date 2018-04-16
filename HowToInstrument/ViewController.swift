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

typealias Story = (title: String, image: String)

class ViewController: UICollectionViewController {
    var newsItems = [Story]()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let filename = Bundle.main.url(forResource: "headlines", withExtension: nil) else {
            fatalError("Unable to find headlines")
        }

        guard let contents = try? String(contentsOf: filename) else {
            fatalError("Unable to load headlines")
        }

        let headlines = contents.components(separatedBy: "\n")

        for headline in headlines {
            let components = headline.components(separatedBy: "|||")
            generateThumbnail(title: components[0], imageName: components[1])
        }

        for headline in headlines {
            let components = headline.components(separatedBy: "|||")
            let newsItem = (components[0], components[1])
            newsItems.append(newsItem)
        }
    }

    func generateThumbnail(title: String, imageName: String) {
        let cacheFilename = getCachesDirectory().appendingPathComponent(imageName)

        guard let image = UIImage(named: imageName) else {
            fatalError("Unable to load thumbnail")
        }

        let padding: CGFloat = 10

        let drawRect = CGRect(x: 0, y: 0, width: 300, height: 170)
        let titleRect = drawRect.insetBy(dx: padding, dy: padding)

        let config = UIGraphicsImageRendererFormat()
        let renderer = UIGraphicsImageRenderer(size: drawRect.size, format: config)

        let shadow = NSShadow()
        shadow.shadowBlurRadius = 10
        shadow.shadowColor = UIColor.black
        let headlineAttributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.white, .shadow: shadow]
        let attributedTitle = NSAttributedString(string: title, attributes: headlineAttributes)

        let renderedImage = renderer.image { ctx in
            image.draw(in: drawRect)

            let titleSize = attributedTitle.boundingRect(with: titleRect.size, options: [.usesLineFragmentOrigin], context: nil)
            let titleDrawRect = titleRect.offsetBy(dx: 0, dy: titleRect.height - titleSize.height)

            UIColor.black.withAlphaComponent(0.5).set()
            let backgroundRect = drawRect.offsetBy(dx: 0, dy: titleDrawRect.minY - padding)
            ctx.fill(backgroundRect, blendMode: .multiply)

            attributedTitle.draw(in: titleDrawRect)
        }

        let data = UIImagePNGRepresentation(renderedImage)

        do {
            try data?.write(to: cacheFilename)
        } catch {
            fatalError("Unable to write cached image")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        guard let imageView = cell.contentView.subviews.first as? UIImageView else { return cell }

        let newsItem = newsItems[indexPath.row]

        let imagePath = getCachesDirectory().appendingPathComponent(newsItem.image)
        imageView.image = UIImage(contentsOfFile: imagePath.path)

        imageView.layer.borderWidth = 0.5
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 5, height: 5)
        cell.clipsToBounds = false

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailNC = storyboard?.instantiateViewController(withIdentifier: "Detail") as? UINavigationController else { return }
        guard let detailVC = detailNC.topViewController as? DetailViewController else { return }

        detailVC.delegate = self
        detailVC.newsTitle = newsItems[indexPath.row].title
        detailNC.modalPresentationStyle = .formSheet
        present(detailNC, animated: true)
    }

    func getCachesDirectory() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }

    func love(_ title: String) {
        print("Reader loved \(title)!")
        dismiss(animated: true)
    }

    func hate(_ title: String) {
        print("Reader loved \(title)!")
        dismiss(animated: true)
    }
}

