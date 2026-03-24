//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/4.
//
import Logging
import AppMetricaCore

struct AnalyticsService {
    
    private static let logger = Logger(label: "AnalyticsService")
    
    static func activate() {
        guard let configuration = AppMetricaConfiguration(
            apiKey: "d6643117-1660-4329-9a0c-a105caddfdf6"
        ) else { return }

        AppMetrica.activate(with: configuration)
    }

    static func report(event: String, screen: String, item: String? = nil) {
        var params: [String: Any] = [
            "event": event,
            "screen": screen
        ]

        if let item {
            params["item"] = item
        }

        AppMetrica.reportEvent(name: "event", parameters: params) { error in
            logger.error("AppMetrica error: \(error.localizedDescription)")
        }

        logger.info("Analytics event: \(params)")
    }
}
