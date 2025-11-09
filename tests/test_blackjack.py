import pytest
from fastapi.testclient import TestClient

from main import app, Game, Card, Deck, calculate_score

@pytest.fixture
def client():
    return TestClient(app)

class TestCard:
    def test_card_creation(self):
        card = Card('♠', 'A')
        assert card.suit == '♠'
        assert card.rank == 'A'
        assert card.value == 11
    
    def test_face_card_value(self):
        king = Card('♥', 'K')
        queen = Card('♦', 'Q')
        jack = Card('♣', 'J')
        
        assert king.value == 10
        assert queen.value == 10
        assert jack.value == 10
    
    def test_number_card_value(self):
        two = Card('♠', '2')
        nine = Card('♥', '9')
        ten = Card('♦', '10')
        
        assert two.value == 2
        assert nine.value == 9
        assert ten.value == 10
    
    def test_card_to_dict(self):
        card = Card('♠', 'A')
        card_dict = card.to_dict()
        
        expected = {'suit': '♠', 'rank': 'A', 'value': 11}
        assert card_dict == expected

class TestDeck:
    def test_deck_creation(self):
        deck = Deck()
        assert len(deck.cards) == 52
    
    def test_deck_draw(self):
        deck = Deck()
        initial_count = len(deck.cards)
        card = deck.draw()
        
        assert isinstance(card, Card)
        assert len(deck.cards) == initial_count - 1
    
    def test_deck_reshuffle_when_empty(self):
        deck = Deck()
        # Draw all cards
        for _ in range(52):
            deck.draw()
        
        # Drawing one more should trigger reshuffle
        card = deck.draw()
        assert isinstance(card, Card)
        assert len(deck.cards) == 51  # 52 - 1 (just drawn)

class TestGame:
    def test_game_initialization(self):
        game = Game()
        assert len(game.player_hand) == 0
        assert len(game.dealer_hand) == 0
        assert game.bet == 0
        assert game.balance == 100
        assert game.game_over == False
        assert game.message == ""
    
    def test_calculate_score_no_aces(self):
        # Create cards without aces
        cards = [Card('♠', '5'), Card('♥', 'K')]
        score = calculate_score(cards)
        assert score == 15
    
    def test_calculate_score_with_aces_low(self):
        # Ace should be counted as 1 when 11 would bust
        cards = [Card('♠', 'K'), Card('♥', '5'), Card('♦', 'A')]
        score = calculate_score(cards)
        assert score == 16  # 10 + 5 + 1
    
    def test_calculate_score_with_aces_high(self):
        # Ace should be counted as 11 when it doesn't bust
        cards = [Card('♠', '5'), Card('♥', 'A')]
        score = calculate_score(cards)
        assert score == 16  # 5 + 11
    
    def test_calculate_score_multiple_aces(self):
        # Only one ace should be 11, others should be 1
        cards = [Card('♠', 'A'), Card('♥', 'A'), Card('♦', '9')]
        score = calculate_score(cards)
        assert score == 21  # 11 + 1 + 9

class TestAPI:
    def test_get_home_page(self, client):
        response = client.get("/")
        assert response.status_code == 200
        assert "text/html" in response.headers["content-type"]
    
    def test_start_game_valid_bet(self, client):
        response = client.post("/api/start-game?bet=10")
        assert response.status_code == 200
        
        data = response.json()
        assert "playerHand" in data
        assert "dealerHand" in data
        assert "balance" in data
        assert data["bet"] == 10
        assert len(data["playerHand"]) == 2
        assert len(data["dealerHand"]) == 2
    
    def test_start_game_invalid_bet(self, client):
        # Test bet that's too high
        response = client.post("/api/start-game?bet=200")
        assert response.status_code == 200
        
        data = response.json()
        assert "error" in data
        assert data["error"] == "Invalid bet amount"
    
    def test_start_game_negative_bet(self, client):
        response = client.post("/api/start-game?bet=-5")
        assert response.status_code == 200
        
        data = response.json()
        assert "error" in data
        assert data["error"] == "Invalid bet amount"
    
    def test_hit_endpoint(self, client):
        # Start a game first
        client.post("/api/start-game?bet=10")
        
        response = client.post("/api/hit")
        assert response.status_code == 200
        
        data = response.json()
        assert "playerHand" in data
        assert len(data["playerHand"]) >= 3  # Should have at least 3 cards now
    
    def test_stand_endpoint(self, client):
        # Start a game first
        client.post("/api/start-game?bet=10")
        
        response = client.post("/api/stand")
        assert response.status_code == 200
        
        data = response.json()
        assert "gameOver" in data
        assert data["gameOver"] == True
        assert "message" in data