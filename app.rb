require 'sinatra'
require 'mongoid'
require 'grape'
require 'grape_entity'

Mongoid.load!("./mongoid.yml")

class Member
  include Mongoid::Document
  include Mongoid::Timestamps

  field :first_name, type: String
  field :last_name, type: String

  attr_accessible :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end
end

module MemberHelpers

  def scrub_member_params(params)
    params.reject!{|k,v| v.blank? }
    params.select{|k,v| Member.accessible_attributes.to_a.include? k }
  end

end

module Entities
  class Member < Grape::Entity
    expose :id
    expose :first_name
    expose :last_name
    expose :full_name
  end
end

class MemberApi < Grape::API
  # configure :production, :development, :staging, :test do
  #   enable :logging
  # end

  rescue_from :all

  format :json

  helpers MemberHelpers

  resource :members do

    desc "Return all members."
    get '/' do
      Member.limit(20)
    end

    desc "Return a member."
    params do
      requires :id, type: String, desc: "Member id."
    end
    route_param :id do
      get do
        member = Member.find(params[:id])
        present member, with: Entities::Member, type: :full
      end
    end

    desc "Create a member."
    params do
      requires :first_name, type: String, desc: "Your first name."
      requires :last_name, type: String, desc: "Your last name."
    end
    post do
      Member.create!({
        first_name: params[:first_name],
        last_name: params[:last_name]
      })
    end

    desc "Update a member."
    put ':id' do
      Member.find(params[:id]).update_attributes(scrub_member_params(params))
    end

  end
end