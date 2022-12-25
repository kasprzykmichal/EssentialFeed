//
//  UITableView+Dequeing.swift
//  EssentialFeediOS
//
//  Created by Michał Kasprzyk on 25/12/2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
