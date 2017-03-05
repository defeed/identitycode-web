require 'sinatra/base'

class IdentityCodeWeb < Sinatra::Base
  get '/' do
    haml :index
  end
end
