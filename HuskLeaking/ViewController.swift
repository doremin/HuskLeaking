//
//  ViewController.swift
//  HuskLeaking
//
//  Created by doremin on 7/23/25.
//

import UIKit

final class FooObject {
    init() {
        print(
            "init \(FooObject.self)\n",
            "id: \(ObjectIdentifier(self))\n",
            "size: \(MemoryLayout<Self>.size)"
        )
    }
    
    deinit {
        print(
            "deinit \(FooObject.self)\n",
            "id: \(ObjectIdentifier(self))\n",
            "size: \(MemoryLayout<Self>.size)"
        )
    }
}

class ViewController: UIViewController {
    
    // - MARK: UI
    private let statusLabel = UILabel()
    private let createWeakButton = UIButton()
    private let removeWeakButton = UIButton()
    private let createUnownedButton = UIButton()
    private let removeUnownedButton = UIButton()
    private let clearAllButton = UIButton()
    
    // - MARK: Properties
    var data: FooObject?
    var weakRefs: [() -> FooObject?] = []
    var unownedRefs: [() -> FooObject?] = []
    
    // - MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateStatus()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Status Label
        statusLabel.numberOfLines = 0
        statusLabel.textAlignment = .center
        statusLabel.font = .systemFont(ofSize: 16)
        
        // Buttons
        createWeakButton.setTitle("Create Objects + Weak Refs", for: .normal)
        createWeakButton.backgroundColor = .systemBlue
        createWeakButton.setTitleColor(.white, for: .normal)
        createWeakButton.layer.cornerRadius = 8
        
        removeWeakButton.setTitle("Remove Strong Refs (Keep Weak)", for: .normal)
        removeWeakButton.backgroundColor = .systemGreen
        removeWeakButton.setTitleColor(.white, for: .normal)
        removeWeakButton.layer.cornerRadius = 8
        
        createUnownedButton.setTitle("Create Objects + Unowned Refs", for: .normal)
        createUnownedButton.backgroundColor = .systemOrange
        createUnownedButton.setTitleColor(.white, for: .normal)
        createUnownedButton.layer.cornerRadius = 8
        
        removeUnownedButton.setTitle("Remove Strong Refs (Keep Unowned)", for: .normal)
        removeUnownedButton.backgroundColor = .systemRed
        removeUnownedButton.setTitleColor(.white, for: .normal)
        removeUnownedButton.layer.cornerRadius = 8
        
        clearAllButton.setTitle("Clear All References", for: .normal)
        clearAllButton.backgroundColor = .systemGray
        clearAllButton.setTitleColor(.white, for: .normal)
        clearAllButton.layer.cornerRadius = 8
        
        // Stack View
        let stackView = UIStackView(arrangedSubviews: [
            statusLabel,
            createWeakButton,
            removeWeakButton,
            createUnownedButton,
            removeUnownedButton,
            clearAllButton,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            createWeakButton.heightAnchor.constraint(equalToConstant: 50),
            removeWeakButton.heightAnchor.constraint(equalToConstant: 50),
            createUnownedButton.heightAnchor.constraint(equalToConstant: 50),
            removeUnownedButton.heightAnchor.constraint(equalToConstant: 50),
            clearAllButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add targets
        createWeakButton.addTarget(self, action: #selector(createWeakReferences), for: .touchUpInside)
        removeWeakButton.addTarget(self, action: #selector(removeStrongReferencesKeepWeak), for: .touchUpInside)
        createUnownedButton.addTarget(self, action: #selector(createUnownedReferences), for: .touchUpInside)
        removeUnownedButton.addTarget(self, action: #selector(removeStrongReferencesKeepUnowned), for: .touchUpInside)
        clearAllButton.addTarget(self, action: #selector(clearAllReferences), for: .touchUpInside)
    }
    
    // - MARK: - Button Actions
    
    @objc private func createWeakReferences() {
        data = FooObject()
        
        for _ in 0 ..< 10 {
            let weakRef = { [weak data = self.data] in
                return data
            }
            weakRefs.append(weakRef)
        }
        updateStatus()
    }
    
    @objc private func removeStrongReferencesKeepWeak() {
        data = nil
        updateStatus()
    }
    
    @objc private func createUnownedReferences() {
        data = FooObject()
        
        for _ in 0 ..< 10 {
            let weakRef = { [unowned data = self.data] in
                return data
            }
            unownedRefs.append(weakRef)
        }
        updateStatus()
    }

    @objc private func removeStrongReferencesKeepUnowned() {
        data = nil
        updateStatus()
    }

    @objc private func clearAllReferences() {
        data = nil
        weakRefs.removeAll()
        unownedRefs.removeAll()
        updateStatus()
    }
    
    private func updateStatus() {
        statusLabel.text = """
        data = \(MemoryLayout<FooObject>.size)
        weakCount = \(self.weakRefs.count)
        unowned = \(self.unownedRefs.count)
        """
    }
}

