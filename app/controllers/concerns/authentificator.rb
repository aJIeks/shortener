module Authentificator
  class UnAuthorized < StandardError; end

  def require_oauth
    return @authorized if defined? @authorized

    client = OAuth2::Client.new('client_id', 'client_secret', :site => 'http://auth.vmp.ru')
    token = nil
    case params[:token]
      when Hash
        token = OAuth2::AccessToken.from_hash client, params[:token].merge(mode: :header)
      when String
        token = OAuth2::AccessToken.from_hash client, { mode: :header, access_token: params[:token] }
    end

    profile = token.get('/profile/me').parsed

    @authorized = !(profile['roles'] & ['admin', 'shortener']).empty?
  rescue
    @authorized = false
  end

  def require_oauth!
    fail UnAuthorized.new unless require_oauth
    @authorized
  end

  def authorized?
    require_oauth unless defined? @authorized
    @authorized
  end
end