# frozen_string_literal: true

describe "CLI" do
  describe "add" do
    it "adds a card to the list" do
      ENV["PATH"] = "bin"
      system "adulting add dentist appointment"
      card_list = `adulting list`.lines
      expect(card_list).to include("dentist appointment")
    end
  end
end
