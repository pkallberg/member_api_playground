require 'spec_helper'

describe UserApi do

  before do
    @user = User.create({ first_name: "John", last_name: "Doe", email: "john@doe.com" })
    @user.stub(:created_at => "2013-07-08T17:40:16-05:00")
  end

  describe "#full_name" do
    it "takes the first name and the last name and returns a space-separated full name" do
      @user.full_name.should == 'John Doe'
    end
  end

  describe "GET users/" do
    it "returns all users" do
      get "/users"
      last_response.status.should == 200
      last_response.body.should == [{
        id: "#{@user.id}",
        first_name: "John",
        last_name: "Doe",
        full_name: "John Doe",
        email: "john@doe.com",
        created_at: "07/08/2013"
      }].to_json
    end
  end

  describe "GET users/:id" do
    it "returns a user by id" do
      get "/users/#{@user.id}"
      last_response.status.should == 200
      last_response.body.should == {
        id: "#{@user.id}",
        first_name: "John",
        last_name: "Doe",
        full_name: "John Doe",
        email: "john@doe.com",
        created_at: "07/08/2013"
      }.to_json
    end
  end
end