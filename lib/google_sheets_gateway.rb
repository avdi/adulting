module GoogleSheetsGateway
  class AchieveCurrentCredentials
    def initialize
      @stage = :initial
    end

    def next(provide: {})
      credentials = {
        client_id: @client_id ||= provide[:client_id],
        client_secret: @client_secret ||= provide[:client_secret]
      }
      case @stage
      in :initial then
        if credentials.all? { _2 } then @stage = :get_token_store end
        {status: :blocked, need: credentials.reject { _2 }, stage: @stage}
      in :get_token_store
        {status: :ready, need: {}, stage: @stage}
      end
    end
  end
end
