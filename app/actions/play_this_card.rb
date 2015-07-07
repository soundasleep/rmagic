# TODO probably split this into "PlayThisCard" (which updates turn_played)
class PlayThisCard < TextualActions

  def initialize
    super(
      'move this card into the battlefield',
      'update card turn played',
    )
  end

end
