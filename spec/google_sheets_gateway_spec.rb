# frozen_string_literal: true

require "google_sheets_gateway"

describe GoogleSheetsGateway do
  def need(name)
  end

  describe GoogleSheetsGateway::AchieveCurrentCredentials do
    it "can be instantiated" do
      it = GoogleSheetsGateway::AchieveCurrentCredentials.new
      it.next => {status:, need:, stage:}
      expect(stage).to eq(:initial)
      expect(status).to eq(:blocked)
      expect(need).to include(:client_id, :client_secret)
      it.next(provide: {client_id: "cid1234"}) => {status:, need:}
      expect(need).not_to include(:client_id)
      it.next(provide: {client_secret: "sec5678"}) => {status:, need:}
      expect(need).not_to include(:client_secret)
      it.next => {status:, stage:, need:}
      expect(status).to eq(:ready)
      expect(stage).to eq(:get_token_store)
    end
  end
end
