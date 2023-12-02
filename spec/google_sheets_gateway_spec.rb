# frozen_string_literal: true

require "google_sheets_gateway"

describe GoogleSheetsGateway do
  def need(name)
  end

  describe GoogleSheetsGateway::AchieveCurrentCredentials do
    it "can be instantiated" do
      it = GoogleSheetsGateway::AchieveCurrentCredentials.new.enum_for(:proceed)
      it.next => {status:, need:, intent:}
      expect(intent).to eq(:get_credentials)
      expect(status).to eq(:blocked)
      expect(need).to include(:client_id, :client_secret)
      it.feed provide: {client_id: "cid1234"}
      it.next => {status:, need:}
      expect(need).not_to include(:client_id)
      it.feed provide: {client_secret: "sec5678"}
      it.next => {status:, need:}
      expect(need).not_to include(:client_secret)
      it.next => {status:, intent:, need:}
      expect(status).to eq(:ready)
      expect(intent).to eq(:get_token_store)
    end
  end
end
