require "net/http"

class UserSessionsController < ApplicationController
  def new
  end

  def create
    
    puts "assertion = #{params['assertion'].inspect}"

    http = Net::HTTP.new("verifier.login.persona.org", 443)
    http.use_ssl = true
    request = Net::HTTP::Post.new("/verify")
    request.form_data = {'assertion' => params['assertion'], 'audience' => "http://localhost:3000"}
    response = http.request(request)

    puts "response = #{response.inspect}"
    json = JSON.parse response.body
    if (json["status"] == "okay") 
      #
      # {
      #   "status"=>"okay", 
      #   "email"=>"stevetuckner@stewdle.com", 
      #   "audience"=>"http://localhost:3000", 
      #   "expires"=>1349026927383, 
      #   "issuer"=>"login.persona.org"
      # }
      #
      user = User.find_by_email_address(json["email"])
      if user then
        render :text => "OK"
      else
        user = User.create(:email_address => json["email"])
        render :text => "OK"
      end
      session[:user_id] = user.id
    else
      
    end
    puts "json = #{json.inspect}"
=begin
    if user
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
=end
  end

  def destroy
    session[:user_id] = nil
    render :text => "OK"
  end
end
