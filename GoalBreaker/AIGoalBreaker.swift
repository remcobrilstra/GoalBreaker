//
//  AIGoalBreaker.swift
//  GoalBreaker
//
//  Created by GoalBreaker on 2026-01-02.
//

import Foundation

class AIGoalBreaker {
    
    struct AIResponse: Codable {
        let monthly: [String]
        let weekly: [[String]]
    }
    
    struct OpenAIMessage: Codable {
        let role: String
        let content: String
    }
    
    struct OpenAIRequest: Codable {
        let model: String
        let messages: [OpenAIMessage]
        let temperature: Double
    }
    
    struct OpenAIResponse: Codable {
        let choices: [Choice]
        
        struct Choice: Codable {
            let message: Message
            
            struct Message: Codable {
                let content: String
            }
        }
    }
    
    /// Breaks down a goal into monthly milestones and weekly tasks using OpenAI
    static func breakDownGoal(goal: String, deadline: Date) async -> (monthly: [String], weekly: [[String]]) {
        let today = Date()
        let numMonths = max(1, deadline.monthDiff(from: today))
        
        let prompt = """
        Break down the goal '\(goal)' with deadline \(deadline.formatted(date: .abbreviated, time: .omitted)) into \(numMonths) monthly milestones, and for each month, break into 4 weekly tasks. 
        
        Output ONLY as valid JSON in this exact format (no other text):
        {"monthly": ["month 1 goal", "month 2 goal", ...], "weekly": [["week1", "week2", "week3", "week4"], ["week1", "week2", "week3", "week4"], ...]}
        """
        
        let messages = [OpenAIMessage(role: "user", content: prompt)]
        let requestBody = OpenAIRequest(model: "gpt-3.5-turbo", messages: messages, temperature: 0.7)
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            print("Invalid URL")
            return fallbackBreakdown(numMonths: numMonths)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("API request failed with status: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return fallbackBreakdown(numMonths: numMonths)
            }
            
            let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            
            guard let content = openAIResponse.choices.first?.message.content else {
                print("No content in response")
                return fallbackBreakdown(numMonths: numMonths)
            }
            
            // Extract JSON from the response (it might have markdown code blocks)
            let jsonString = content
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("Failed to convert response to data")
                return fallbackBreakdown(numMonths: numMonths)
            }
            
            let aiResponse = try JSONDecoder().decode(AIResponse.self, from: jsonData)
            return (monthly: aiResponse.monthly, weekly: aiResponse.weekly)
            
        } catch {
            print("Error breaking down goal: \(error)")
            return fallbackBreakdown(numMonths: numMonths)
        }
    }
    
    /// Provides a fallback breakdown if AI fails
    private static func fallbackBreakdown(numMonths: Int) -> (monthly: [String], weekly: [[String]]) {
        let monthly = (1...numMonths).map { "Month \($0) milestone" }
        let weekly = (1...numMonths).map { month in
            (1...4).map { "Month \(month), Week \($0) task" }
        }
        return (monthly: monthly, weekly: weekly)
    }
}
