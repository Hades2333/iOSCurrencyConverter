//
//  LoadingLabel.swift
//  CurrencyConverter
//
//  Created by Mikalai Bekliamishchau on 05/02/2025.
//

import UIKit

final class LoadingLabel: UILabel {
    private var loadingDotsTimer: Timer?
    private var loadingDotsState = 0
    private let baseText: String

    init(baseText: String = "Загрузка") {
        self.baseText = baseText
        super.init(frame: .zero)
        self.text = baseText
        self.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateStateWith(_ isLoading: Bool) {
        if isLoading {
            startLoading()
        } else {
            stopLoading()
        }
    }
    
    private func startLoading() {
        self.isHidden = false
        loadingDotsState = 0
        loadingDotsTimer?.invalidate()

        loadingDotsTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.loadingDotsState = (self.loadingDotsState + 1) % 4
            let dots = String(repeating: ".", count: self.loadingDotsState)
            self.text = "\(self.baseText)\(dots)"
        }
    }

    private func stopLoading() {
        loadingDotsTimer?.invalidate()
        loadingDotsTimer = nil
        self.isHidden = true
    }
}
