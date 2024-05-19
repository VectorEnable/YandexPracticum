import UIKit

final class MovieQuizViewController: UIViewController {
	
	private var currentQuestionIndex = 0
	private var correctAnswers = 0
	
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var counterLabel: UILabel!
	
	private let questions: [QuizQuestion] = [
		QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
		QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
		
	]
	
	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		show(quiz: convert(model: questions[currentQuestionIndex]))
	}
	struct QuizQuestion {
		// строка с названием фильма,
		// совпадает с названием картинки афиши фильма в Assets
		let image: String
		// строка с вопросом о рейтинге фильма
		let text: String
		// булевое значение (true, false), правильный ответ на вопрос
		let correctAnswer: Bool
	}
	
	private func convert(model: QuizQuestion) -> QuizStepViewModel {
		return QuizStepViewModel(
			image: UIImage(named: model.image) ?? UIImage(),
			question: model.text,
			questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
	}
	
	private func show(quiz step: QuizStepViewModel) {
		imageView.image = step.image
		counterLabel.text = step.questionNumber
		textLabel.text = step.question
		
	}
	
	struct QuizStepViewModel {
		let image: UIImage
		let question: String
		let questionNumber: String
	}
	
	// для состояния "Результат квиза"
	struct QuizResultsViewModel {
		let title: String
		let text: String
		let buttonText: String
	}
	
	private func showAnswerResult(isCorrect: Bool) {
		
		if isCorrect {
			correctAnswers += 1
		}
		
		imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
		imageView.layer.borderWidth = 1 // толщина рамки
		imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
		imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			self.showNextQuestionOrResults()
		}
	}
	
	private func showNextQuestionOrResults() {
		if currentQuestionIndex == questions.count - 1 { // 1
			// идём в состояние "Результат квиза"
			let alert = UIAlertController(title: "Результат квиза", message: "Ваш результат: \(correctAnswers)/\(questions.count)", preferredStyle: .alert)
			let action = UIAlertAction(title: "Начать заново", style: .default, handler: {_ in
				self.currentQuestionIndex = 0
				self.correctAnswers = 0
				self.imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
				self.imageView.layer.borderWidth = 1 // толщина рамки
				self.imageView.layer.borderColor = UIColor.white.cgColor //делаем белую рамку после перехода на следующий вопрос
				self.imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
				
				let firstQuestion = self.questions[self.currentQuestionIndex] // 2
				let viewModel = self.convert(model: firstQuestion)
				self.show(quiz: viewModel)
			})
			alert.addAction(action)
			self.present(alert, animated: true)
			
		} else { // 2
			currentQuestionIndex += 1
			// идём в состояние "Вопрос показан"
			imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
			imageView.layer.borderWidth = 1 // толщина рамки
			imageView.layer.borderColor = UIColor.white.cgColor //делаем белую рамку после перехода на следующий вопрос
			imageView.layer.cornerRadius = 6 // радиус скругления углов рамки
			let nextQuestion = questions[currentQuestionIndex]
			let viewModel = convert(model: nextQuestion)
			
			show(quiz: viewModel)
		}
	}
	
	
	
	@IBAction private func noButtonClicked(_ sender: UIButton) {
		let givenAnswer = false
		let currentQuestion = questions[currentQuestionIndex]
		
		showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
	}
	
	@IBAction private func yesButtonClicked(_ sender: UIButton) {
		let givenAnswer = true
		let currentQuestion = questions[currentQuestionIndex]
		
		showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
	}
}

