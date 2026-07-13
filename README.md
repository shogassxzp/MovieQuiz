# MovieQuiz

MovieQuiz is an iOS quiz app about movies from IMDb ratings. The user answers whether a movie rating is higher than the suggested value, completes a 10-question round, and sees personal statistics at the end.

## Overview

The project was built as a UIKit training app and gradually evolved from a static quiz screen into a network-driven application with separated presentation logic, statistics, error handling, and tests.

## Features

- Splash screen and main quiz screen
- 10-question game rounds
- Questions based on movie ratings
- Visual feedback for correct and incorrect answers
- Round result alert with current score
- Best result, total games count, and average accuracy
- Network loading of movie data
- Retry flow when loading fails
- Unit tests for presenter and movie loading logic
- UI test target

## Tech Stack

- Swift
- UIKit
- Storyboard + programmatic logic
- MVP-style presentation layer
- URLSession
- XCTest
- UserDefaults for statistics storage

## Architecture

The project separates the screen, business logic, data loading, and statistics:

- `MovieQuizViewController` renders UI and receives presenter commands.
- `MovieQuizPresenter` controls quiz state, answer handling, and navigation between questions.
- `QuestionFactory` prepares quiz questions.
- `MoviesLoader` and `NetworkClient` load movie data.
- `StatisticService` stores game statistics.
- `AlertPresenter` centralizes alert presentation.

## Project Structure

```text
MovieQuiz/
├── Models/          # Quiz, movie, result, and alert models
├── Presentation/    # View controller, presenter, alert presenter
├── Services/        # Network, question factory, statistics
├── Helpers/         # Extensions and utilities
├── Mocks/           # Mock questions
└── Resources/       # Assets, fonts, storyboard resources
```

## Tests

The repository contains:

- `MovieQuizPresenterTests`
- `MoviesLoaderTests`
- `MovieQuizUITests`

Run tests from Xcode with the included test plans.

## Getting Started

1. Open `MovieQuiz.xcodeproj` in Xcode.
2. Select the `MovieQuiz` scheme.
3. Run the app on an iPhone simulator.

## Repository

[github.com/shogassxzp/MovieQuiz](https://github.com/shogassxzp/MovieQuiz)
