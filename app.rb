require 'sinatra'
# require 'mongoid'

# Mongoid.load!("./mongoid.yml")

class MemberApi < Sinatra::Base
  # configure :production, :development, :staging, :test do
  #   enable :logging
  # end

  get '/' do
    'Hello from the MemberApi Server'
  end

  # get '/monitoring' do
  #   halt 500 if params[:ping] && !Monitoring.ok?
  #   content_type 'text/plain'
  #   Monitoring.status_message
  # end

  # post '/share_a_sale_callback' do
  #   return if Member.where(member_id: params[:tracking]).exists?
  #   Member.create(ssaid: params[:userID], member_id: params[:tracking])
  # end
end