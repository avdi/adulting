# frozen_string_literal: true

require "google/apis/drive_v3"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require "webrick"

OOB_URI = "http://localhost:4567"  # Change the port number if necessary
APPLICATION_NAME = "Google Drive API Ruby Quickstart"
CREDENTIALS_PATH = "tmp/creds.json"
TOKEN_PATH = "tmp/token.yaml"
SCOPE = Google::Apis::DriveV3::AUTH_DRIVE_FILE

def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = "default"
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    server = WEBrick::HTTPServer.new(Port: 4567)
    trap "INT" do server.shutdown end

    code = nil
    server.mount_proc "/" do |req, res|
      code = req.query["code"]
      res.body = "Authorization complete. You can close this page."
      server.shutdown
    end

    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts "Open the following URL in your browser and complete the authorization:"
    puts url

    server.start

    credentials = authorizer.get_and_store_credentials_from_code(user_id: user_id, code: code, base_url: OOB_URI)
  end
  credentials
end

def create_sheet
  service = Google::Apis::DriveV3::DriveService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize

  file_metadata = {
    name: "My Spreadsheet",
    mime_type: "application/vnd.google-apps.spreadsheet"
  }
  file = service.create_file(file_metadata, fields: "id")
  puts "Spreadsheet ID: #{file.id}"
end

create_sheet
