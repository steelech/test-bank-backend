require 'test_helper'

class SessionControllerTest < ActionController::TestCase
	test "authentication with username" do 
		pw = 'secret'
		larry = User.create!(username: 'larry', email: 'larry@example.com', name: 'Larry Moulders', password: pw, password_confirmation: pw)
		post 'create', {username_or_email: larry.username, password: pw }
		results = JSON.parse(response.body)
		puts results
		assert results['data']['attributes']['access-token'] =~ /\S{32}/
	end

	test "authentication with email" do 
		pw = 'secret'
		larry = User.create!(username: 'larry', email: 'larry@example.com', name: 'Larry Moulders', password: pw, password_confirmation: pw)
		post 'create', {username_or_email: larry.email, password: pw}
		results = JSON.parse(response.body)
		assert results['data']['attributes']['access-token'] =~ /\S{32}/
	end

	test "authentication with invalid info" do 
		pw = 'secret'
		larry = User.create!(username: 'larry', email: 'larry@example.com', name: 'Larry Moulders', password: pw, password_confirmation: pw)
		post 'create', {username_or_email: larry.email, password: 'huh'}
		assert response.status == 401

	end
end
