class GameWindow < Gosu::Window
  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT
    self.caption = 'Knooght, the MMMMOORPG'

    @background_image = Gosu::Image.new 'images/background.jpg', tileable: true
    @player1 = Knight.new player_number: 0, name: 'player1left'
    @player2 = Mage.new player_number: 1, name: 'player2right'
    @gui = GUI.new player1: @player1, player2: @player2
  end

  def update
    if Gosu::button_down? Gosu::KbF
      @player1.attack @player2
    end
    if Gosu::button_down? Gosu::KbJ
      @player2.attack @player1
    end
    @player1.animate Gosu::milliseconds
    @player2.animate Gosu::milliseconds
  end

  def draw
    @background_image.draw 0, 0, ZOrder::BACKGROUND
    @player1.draw
    @player2.draw
    @gui.draw
  end

  def button_down id
    if id == Gosu::KbEscape
      close
    end
  end
end
