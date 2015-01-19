Rails.application.routes.draw do
  scope path: 'api', defaults: { format: :json } do
    scope path: 'v1' do
      scope path: 'links' do
        get '/' => 'links#index'
        get '/shorten' => 'links#shorten'
        post '/' => 'links#create'
      end
    end
  end

  get '/links' => 'links#angular'

  get ':key' => 'links#link', as: :shorted
  root to: 'links#angular'
end
