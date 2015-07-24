require "game_helper"

class MockedTrueCondition < Condition
  attr_reader :evaluated

  def initialize
    @evaluated = false
  end

  def evaluate(duel, stack)
    @evaluated = true
    true
  end

  def evaluated?
    evaluated
  end
end

class MockedFalseCondition < MockedTrueCondition
  def evaluate(duel, stack)
    @evaluated = true
    false
  end
end

RSpec.describe TextualConditions, type: :condition do

  let(:duel) { nil }
  let(:stack) { nil }

  context "combined true conditions" do
    let(:condition1) { MockedTrueCondition.new }
    let(:condition2) { MockedTrueCondition.new }

    let(:combined) { TextualConditions.new(condition1, condition2) }

    context "condition 1" do
      it "is not evaluated" do
        expect(condition1.evaluated?).to be(false)
      end
    end

    context "condition 2" do
      it "is not evaluated" do
        expect(condition2.evaluated?).to be(false)
      end
    end

    it "returns true" do
      expect(combined.evaluate(duel, stack)).to be(true)
    end

    it "returns an explaination" do
      expect(combined.explain(duel, stack)).to_not be_empty
    end

    context "when evaluated" do
      before(:each) { combined.evaluate(duel, stack) }

      context "condition 1" do
        it "is evaluated" do
          expect(condition1.evaluated?).to be(true)
        end
      end

      context "condition 2" do
        it "is evaluated" do
          expect(condition2.evaluated?).to be(true)
        end
      end
    end

  end

  context "combined false conditions" do
    let(:condition1) { MockedFalseCondition.new }
    let(:condition2) { MockedFalseCondition.new }

    let(:combined) { TextualConditions.new(condition1, condition2) }

    context "condition 1" do
      it "is not evaluated" do
        expect(condition1.evaluated?).to be(false)
      end
    end

    context "condition 2" do
      it "is not evaluated" do
        expect(condition2.evaluated?).to be(false)
      end
    end

    it "returns false" do
      expect(combined.evaluate(duel, stack)).to be(false)
    end

    it "returns an explaination" do
      expect(combined.explain(duel, stack)).to_not be_empty
    end

    context "when evaluated" do
      before(:each) { combined.evaluate(duel, stack) }

      context "condition 1" do
        it "is evaluated" do
          expect(condition1.evaluated?).to be(true)
        end
      end

      context "condition 2" do
        it "is not evaluated" do
          expect(condition2.evaluated?).to be(false)
        end
      end
    end
  end

end
