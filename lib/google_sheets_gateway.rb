module GoogleSheetsGateway
  class AchieveCurrentCredentials
    def proceed
      needs = {client_id: nil, client_secret: nil}
      until needs.all? { _2 }
        yield(intent: :get_credentials, status: :blocked, need: needs.filter { _2.nil? }.keys) => {provide:}
        needs.merge! provide
      end
      yield(intent: :get_token_store, status: :ready, need: {}) => request until Hash(request)[:to] == :get_token_store
    end
  end
end
