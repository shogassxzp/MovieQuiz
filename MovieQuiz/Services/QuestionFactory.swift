import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private var moviesLoader: MoviesLoader
    private weak var delegate: QuestionFactoryDelegate?
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    // let questions: [QuizQuestion] = QuizQuestion.mockQuestions
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveNextQuestion(question: nil)
                }
                return
            }
            
            guard let imageData = try? Data(contentsOf: movie.resizedImageURL) else {
                print("Failed to load image")
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didReceiveNextQuestion(question: nil)
                }
                return
            }
            
            let randomRating = Double.random(in: 6.0...9.0)
            let rating = Double(movie.rating) ?? 0
            let text = String(format: "Рейтинг этого фильма больше чем %.1f?", randomRating)
            let correctAnswer = rating > randomRating
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async{[weak self] in
                guard let self = self else {return}
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
        
        
        init(moviesLoader: MoviesLoader, delegate: QuestionFactoryDelegate?) {
            self.moviesLoader = moviesLoader
            self.delegate = delegate
        }
    }

