class GUI
  def initialize options
    @player1 = options[:player1]
    @player2 = options[:player2]
    @height = 20
    @max_width = 400
    @begin_margin = 20
    @top_margin = 58
    @chrome_padding = 5
    @color = Gosu::Color::RED
    @chrome_color = Gosu::Color.new 77, 0, 0, 0
    @text_color = Gosu::Color.new 177, 0, 0, 0
    @font = Gosu::Font.new 40, name: '/Users/dh/Library/Fonts/SanukLF-Bold.otf'
  end

  def chrome is_left
    Gosu::draw_rect(
      (is_left ? @begin_margin - @chrome_padding : WINDOW_WIDTH - @max_width - @begin_margin - @chrome_padding),
      @top_margin - @chrome_padding,
      @max_width + 2 * @chrome_padding,
      @height + 2 * @chrome_padding,
      @chrome_color,
      ZOrder::GUI,
      :default
    )
  end

  def health_bar health, max_health, is_left
    width = health * @max_width / max_health
    Gosu::draw_rect(
      (is_left ? @begin_margin : WINDOW_WIDTH - width - @begin_margin),
      @top_margin,
      width,
      @height,
      @color,
      ZOrder::GUI,
      :default
    )
  end

  def name name, is_left
    @font.draw_rel(
      name,
      (is_left ? @begin_margin - @chrome_padding : WINDOW_WIDTH - @begin_margin + @chrome_padding),
      10,
      ZOrder::GUI,
      (is_left ? 0 : 1),
      0,
      1,
      1,
      @text_color,
      :default
    )
  end

  def draw
    chrome true
    name @player1.name, true
    health_bar @player1.health, @player1.max_health, true
    if @player2
      chrome false
      name @player2.name, false
      health_bar @player2.health, @player2.max_health, false
    end
  end
end
