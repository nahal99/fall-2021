//
//  QuestionStore.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/27/21.
//

import Foundation

class QuestionStore: ObservableObject {
    static let sharedInstance = QuestionStore()
    var isEdited = false
    var drawAcessed = false
    var Index = 0
    @Published var fib = [Questions]()
    
    init(){
        let questions: [String] = [
            "What is 2+1 = ?",
            "What is 5+7 = ?",
            "What is 1+7 = ?",
            "What is 2+5 = ?",
            "What is 0+0 = ?",
            "What is 8+11 = ?",
        ]
        let answers: [String] = [
            "3", "12", "8", "7","0","19"
        ]
        
        for i in 0..<6 {
            fib.append(Questions(question: questions[i], answer: answers[i]))
        }

    }
    
    private static var documentsFolder: URL {
        do {
            return try FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        } catch {
            fatalError("Can't find documents directory.")
        }
    }
    private static var fileURL: URL {
        return documentsFolder.appendingPathComponent("scrums.data")
    }
    
    func load() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let data = try? Data(contentsOf: Self.fileURL) else {
                #if DEBUG
                DispatchQueue.main.async {
                    self?.fib = QuestionStore.sharedInstance.fib
                }
                #endif
                return
            }
            guard let dailyfib = try? JSONDecoder().decode([Questions].self, from: data) else {
                fatalError("Can't decode saved scrum data.")
            }
            DispatchQueue.main.async {
                self?.fib = dailyfib
            }
        }
    }
    
    func save() {
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let fibs = self?.fib else { fatalError("Self out of scope") }
                guard let data = try? JSONEncoder().encode(fibs) else { fatalError("Error encoding data") }
                do {
                    let outfile = Self.fileURL
                    try data.write(to: outfile)
                } catch {
                    fatalError("Can't write to file")
                }
            }
        }
    
}
    


   
  


