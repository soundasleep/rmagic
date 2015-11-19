class ResolveCombat
  attr_reader :duel

  def initialize(duel:)
    @duel = duel
  end

  def call
    apply_attack_damages

    apply_defend_damages

    # remove attackers
    duel.declared_attackers.destroy_all

    # remove defenders
    duel.declared_defenders.destroy_all

    true
  end

  private

    def apply_damage_to(action, remaining_damage, battlefield)
      if remaining_damage > 0
        if remaining_damage > battlefield.card.remaining_health
          AddDamage.new(card: battlefield.card, damage: battlefield.card.remaining_health).call
          remaining_damage -= battlefield.card.remaining_health
        else
          AddDamage.new(card: battlefield.card, damage: remaining_damage).call
          remaining_damage = 0
        end

        # link the defender
        action.targets.create! card: battlefield.card
      end

      remaining_damage
    end

    def apply_attack_damage(attacker)
      # TODO allow attacker to specify order of damage
      remaining_damage = attacker.card.power

      action = ActionLog.attack_card_action(duel, attacker.player, attacker)

      declared_defenders(attacker).each do |d|
        apply_damage_to action, remaining_damage, d.source
        # chump blocking
        remaining_damage = 0
      end

      if remaining_damage > 0
        attacker.target_player.remove_life! remaining_damage
      end

      if attacker.card.tags.include? "lifelink"
        apply_lifelink(attacker.card)
      end

      if attacker.card.tags.include? "trample"
        apply_trample(attacker.card)
      end
    end

    def apply_defend_damage(defender)
      damage = defender.source.card.power

      action = ActionLog.defended_card_action(duel, defender.source.player, defender.source)

      # any overkill damage is ignored
      apply_damage_to action, damage, defender.target

      if defender.source.card.tags.include? "lifelink"
        apply_lifelink(defender.source.card)
      end
    end

    def apply_attack_damages
      duel.declared_attackers.each do |d|
        apply_attack_damage d
      end
    end

    def apply_defend_damages
      duel.declared_defenders.each do |d|
        apply_defend_damage d
      end
    end

    def apply_lifelink(card)
      # TODO rename to gain_life!
      card.controller.add_life! card.power

      # TODO it would be nice to get rid of this one day
      duel.reload
    end

    def apply_trample(attacker)
      defenders = declared_defenders(attacker)
    end

    def declared_defenders(attacker)
      duel.declared_defenders.select { |d| d.target == attacker }
    end

end
