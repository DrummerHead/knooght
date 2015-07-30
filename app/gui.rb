class GUI
  def initialize options
    @player1 = options[:player1]
    @player2 = options[:player2]
    @max_width = 300
    @begin_margin = 10
    @top_margin = 10
    @height = 20
    @color = Gosu::Color::RED
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

  def draw
    health_bar @player1.health, @player1.max_health, true
    if @player2
      health_bar @player2.health, @player2.max_health, false
    end
  end
end
