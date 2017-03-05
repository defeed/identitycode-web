require 'sinatra/base'
require 'identity_code'
require 'json'

class IdentityCodeWeb < Sinatra::Base
  get '/' do
    haml :index
  end

  post '/generate' do
    content_type :json

    count = case params[:count].to_i
    when proc { |n| n <= 0 }
      1
    when proc { |n| n > 100 }
      100
    else
      params[:count].to_i
    end

    opts = {
      count: count,
      country: params[:country] || 'ee',
      safe_age: true?(params[:safe_age]),
      separator: true?(params[:separator]),
      sex: params[:sex]
    }

    codes = []
    opts[:count].times do
      codes << IdentityCode.generate(opts)
    end

    {
      country: opts[:country],
      result: codes
    }.to_json
  end

  get '/validate' do
    content_type :json

    country = params[:country] || 'ee'
    code = IdentityCode.validate(country: country, code: params[:code])

    {
      country: country,
      valid: code.valid?,
      sex: code.sex,
      age: code.age,
      birth_date: code.birth_date
    }.to_json
  end

  helpers do
    def true?(thing)
      thing.to_s == 'true'
    end
  end
end
