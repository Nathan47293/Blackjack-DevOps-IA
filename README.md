# Simple Blackjack Game

A lightweight implementation of Blackjack using FastAPI backend and vanilla JavaScript frontend.

## Features
- RESTful API for game actions
- Complex game state management with dealer AI
- Real-time score calculation with special Ace handling
- Simple betting system
- Responsive web interface

## Setup Instructions

1. Prerequisites
   - Python 3.8 or higher
   - pip (Python package manager)

2. Installation
   ```bash
   # Clone the repository
   git clone [your-repo-url]
   cd [repository-name]

   # Install dependencies
   pip install -r requirements.txt
   ```

3. Running the Application
   ```bash
   # Start the server
   python main.py
   ```

4. Access the Game
   - Open your web browser
   - Navigate to http://localhost:8000
   - Start playing!

## Game Rules
- Initial balance: $100 (resets on page refresh)
- Place your bet before each round
- Dealer must hit on 16 or below, stand on 17 or above
- Blackjack pays 2:1
- Push (tie) returns your bet

## Tech Stack
- Backend: Python + FastAPI
- Frontend: HTML5, CSS3, JavaScript
- Template Engine: Jinja2

## Project Structure
```
├── main.py           # FastAPI application and game logic
├── requirements.txt  # Python dependencies
├── static/          # Static assets
│   ├── css/        # Stylesheets
│   └── js/         # JavaScript files
└── templates/       # HTML templates
```