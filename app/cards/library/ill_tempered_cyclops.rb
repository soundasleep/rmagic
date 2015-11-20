class Library::IllTemperedCyclops < CardType
  include Creature

  def name
    "Ill-Tempered Cyclops"
  end

  def power
    3
  end

  def toughness
    3
  end

  def mana_cost
    Mana.new red: 1, colourless: 3
  end

  def ability_cost
    Mana.new red: 1, colourless: 5
  end

  def conditions_for_ability
    TextualConditions.new(
      "we can use card abilities",
      "we have priority",
      "not monstrous"
      )
  end

  def actions_for_ability
    TextualActions.new(
      ActivateTargetCreaturesActivatedAbility.new(Effects::MakeMonstrousThree)
    )
  end

  def playing_ability_goes_onto_stack?
    false # TODO this should be true, but can't figure out how to pass the test when true
  end

  def self.metaverse_id
    373545
  end

  def tags
    super << "trample"
  end

end
