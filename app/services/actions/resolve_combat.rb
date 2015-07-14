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
          battlefield.card.damage! battlefield.card.remaining_health
          remaining_damage -= battlefield.card.remaining_health
        else
          battlefield.card.damage! remaining_damage
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

      duel.declared_defenders.select { |d| d.target == attacker }.each do |d|
        remaining_damage = apply_damage_to action, remaining_damage, d.source
      end

      if remaining_damage > 0
        attacker.target_player.remove_life! remaining_damage
      end
    end

    def apply_defend_damage(defender)
      damage = defender.source.card.power

      action = ActionLog.defended_card_action(duel, defender.source.player, defender.source)

      # any overkill damage is ignored
      apply_damage_to action, damage, defender.target
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

end
