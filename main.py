from fastapi import FastAPI, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
import random

app = FastAPI()

# Mount static directory
app.mount("/static", StaticFiles(directory="static"), name="static")

# Setup templates
templates = Jinja2Templates(directory="templates")

# Game state (in memory)
class Card:
    def __init__(self, suit, rank):
        self.suit = suit
        self.rank = rank
        self.value = self._get_value()
    
    def _get_value(self):
        if self.rank in ['J', 'Q', 'K']:
            return 10
        elif self.rank == 'A':
            return 11  # Ace value will be handled in hand calculation
        return int(self.rank)
    
    def to_dict(self):
        return {
            'suit': self.suit,
            'rank': self.rank,
            'value': self.value
        }

class Deck:
    def __init__(self):
        suits = ['♠', '♥', '♦', '♣']
        ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']
        self.cards = [Card(suit, rank) for suit in suits for rank in ranks]
        random.shuffle(self.cards)
    
    def draw(self):
        if not self.cards:
            self.__init__()
        return self.cards.pop()

class Game:
    def __init__(self):
        self.deck = Deck()
        self.player_hand = []
        self.dealer_hand = []
        self.bet = 0
        self.balance = 100
        self.game_over = False
        self.message = ""

game_state = Game()

@app.get("/", response_class=HTMLResponse)
async def get_home(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})

@app.post("/api/start-game")
async def start_game(bet: int):
    global game_state
    if bet <= 0 or bet > game_state.balance:
        return {"error": "Invalid bet amount"}
    
    game_state = Game()  # Reset game
    game_state.bet = bet
    game_state.balance -= bet
    
    # Deal initial cards
    game_state.player_hand = [game_state.deck.draw(), game_state.deck.draw()]
    game_state.dealer_hand = [game_state.deck.draw(), game_state.deck.draw()]
    
    return get_game_state()

@app.post("/api/hit")
async def hit():
    if game_state.game_over:
        return {"error": "Game is over"}
    
    game_state.player_hand.append(game_state.deck.draw())
    player_score = calculate_score(game_state.player_hand)
    
    if player_score > 21:
        game_state.game_over = True
        game_state.message = "Bust! You lose!"
        # Money was already deducted when betting
    
    return get_game_state()

@app.post("/api/stand")
async def stand():
    if game_state.game_over:
        return {"error": "Game is over"}
    
    dealer_score = calculate_score(game_state.dealer_hand)
    while dealer_score < 17:
        game_state.dealer_hand.append(game_state.deck.draw())
        dealer_score = calculate_score(game_state.dealer_hand)
    
    player_score = calculate_score(game_state.player_hand)
    
    game_state.game_over = True
    
    if dealer_score > 21:
        game_state.balance += 2 * game_state.bet  # Return bet + winnings
        game_state.message = "Dealer busts! You win!"
    elif dealer_score < player_score:
        game_state.balance += 2 * game_state.bet  # Return bet + winnings
        game_state.message = "You win!"
    elif dealer_score > player_score:
        game_state.message = "Dealer wins!"
    else:
        game_state.balance += game_state.bet  # Return bet only
        game_state.message = "Push!"
    
    return get_game_state()

def calculate_score(hand):
    score = 0
    aces = 0
    
    for card in hand:
        if card.rank == 'A':
            aces += 1
        else:
            score += card.value
    
    # Add aces
    for _ in range(aces):
        if score + 11 <= 21:
            score += 11
        else:
            score += 1
    
    return score

def get_game_state():
    # Hide dealer's hole card if game is not over
    dealer_cards = [card.to_dict() for card in game_state.dealer_hand]
    if not game_state.game_over:
        dealer_cards[1] = {"suit": "?", "rank": "?", "value": 0}
    
    return {
        "playerHand": [card.to_dict() for card in game_state.player_hand],
        "dealerHand": dealer_cards,
        "playerScore": calculate_score(game_state.player_hand),
        "dealerScore": calculate_score(game_state.dealer_hand) if game_state.game_over else dealer_cards[0]["value"],
        "balance": game_state.balance,
        "bet": game_state.bet,
        "gameOver": game_state.game_over,
        "message": game_state.message
    }

if __name__ == "__main__":
    import uvicorn
    print("\nPlease open http://localhost:8000 in your web browser\n")
    uvicorn.run(app, host="127.0.0.1", port=8000)