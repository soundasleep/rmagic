RSpec.shared_examples "something on the battlefield" do

  it "exist on the battlefield" do
    expect(player1.battlefield).to include(source)
  end

end
