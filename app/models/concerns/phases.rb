require 'active_support/concern'

module Phases
  extend ActiveSupport::Concern

  included do
    enum phase_number: [ :mulligan_phase, :completed_mulligans_phase, :drawing_phase, :playing_phase, :attacking_phase, :cleanup_phase, :finished_phase ]
  end

  def phase
    phase_number.classify.constantize.new
  end

end
