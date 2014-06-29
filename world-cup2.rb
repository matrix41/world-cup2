require 'httparty'

class AllMatchesPlayed
	def print_matches
		response = HTTParty.get('http://worldcup.sfg.io/matches')

		rabbit = response.parsed_response

		puts "Match #    Home Team     Away Team     Date/Time\n"
		puts "-------    ---------     ---------     ---------\n"
#		puts rabbit.first['home_team']['country']
		rabbit.each do |games|
# This IF-block checks whether the home_team field is hash or not.  
# A hash will contain the information from the completed game.  
# If not a hash (it will probably be an array), then it will not 
# contain any information as the game has not been played yet.  
			if ( ( games['home_team'].class.to_s() =~ /^Hash$/ ) && 
				 ( games['away_team'].class.to_s() =~ /^Hash$/ ) )
				print "\nMatch #{games['match_number']}:  "
				print "#{games['home_team']['country']}   "
				print "#{games['away_team']['country']}   " 
				0.upto(9) {|i| print "#{games['datetime'][i]}"}
				print " "
				11.upto(18) {|i| print "#{games['datetime'][i]}"}
				print " (localtime)"
				puts " "
#				if ( !games['winner'].nil? )
#				puts games['winner']
				game_winner = games['winner']
				game_status = games['status']
				# if ( !games['winner'].nil? )
				# 	puts game_winner
				# else
				# 	puts "Draw"
				# end

				if game_status.include?("completed")
				  if game_winner.include?( "Draw" )
				  	puts "Draw"
				  else
					puts "Winner: #{game_winner}"
				  end
				else
					puts "Not Played"
				end
			else
				puts "Not Played"
				break # exit loop once the program finds no more match data. 
			end # end IF block ( =~ /^Hash$/ )
		end # end EACH-DO loop |games| 
	end # end print_matches function


	def group_matches_by_location
		response = HTTParty.get('http://worldcup.sfg.io/matches')

		charleyhorse = response.parsed_response
#		puts charliehorse.first['home_team']['country']

		location_of_matches = {}

# This EACH-DO loop will iterate through all the matches? 
		charleyhorse.each do |games|
# This IF-block checks to see if the location is already in the 
# location_of_match hash.  If the location already exists as a 
# key in the hash, then shovel a match number into the array it 
# is associated with.  If the location doesn't exist yet as a 
# key, then make a new hash key using the location and then 
# asssociate with an empty array.  After that, shovel the match 
# number into the array. 
			if location_of_matches.has_key? ( games['location'] )
				location_of_matches[ games['location'] ] << games['match_number']
			else
				location_of_matches[ games['location'] ] = []
				location_of_matches[ games['location'] ] << games['match_number']
			end

		end # end of EACH-DO loop |games| 

		puts "Location             Match #\n"
		puts "------------------   ----------------------------------\n"

		location_of_matches.each do |stadium|
			puts "#{stadium[0]} - Matches: #{stadium[1]}"
		end # end of EACH-DO loop |stadium|

	end # end group_matches_by_location function 



	def team_winners
		response = HTTParty.get('http://worldcup.sfg.io/matches')

		battlestar = response.parsed_response

		match_winners = {}

# This EACH-DO loop will iterate through all the matches? 
		battlestar.each do |games|
			game_winner = games['winner']
			game_status = games['status']

			if game_status.include?("completed")
#				puts games['winner']
				if match_winners.has_key? ( game_winner )
					match_winners[ game_winner ] += 1 # increment by 1 if an existing key
				else
					match_winners[ game_winner ] = 1 # initialize with value 1 if new key
				end # end of inner IF-block 
			end # end of outer IF-block 
		end # end of EACH-DO loop |games| 

# Prints a list of winners and the number of wins (excludes Draw results) 
		match_winners.each do |thewinners|
			puts "#{thewinners[0]} ==> #{thewinners[1]}" if !thewinners.include?("Draw")
		end # end of EACH-DO loop |thewinners|
	end # end of team_wins function


	def team_losers
		response = HTTParty.get('http://worldcup.sfg.io/matches')

		coffee = response.parsed_response

		all_teams = {}

# This EACH-DO loop will iterate through all the matches? 
		coffee.each do |games|

			game_home_team = games['home_team']['country']
			game_away_team = games['away_team']['country']
			game_winner = games['winner']
			game_status = games['status']

# This nested IF block will look for completed games and then populate the 
# hash all_teams with the home team countries 
			if game_status.include?("completed")
				if !all_teams.has_key?( game_home_team )
					all_teams[ game_home_team ] = 0 # initialize team win to 0 
				end # end of inner IF-block 
			end # end of outer IF-block 

# This nested IF block will look for completed games and then populate the 
# hash all_teams with the away team countries 
			if game_status.include?("completed")
				if !all_teams.has_key?( game_away_team )
					all_teams[ game_away_team ] = 0 # initialize team win to 0 
				end # end of inner IF-block 
			end # end of outer IF-block 

# This nested IF block will look for completed games and then increment by 1 the 
# value associated with keys in hash all_teams when a team has won a game 
			if game_status.include?("completed")
				if all_teams.has_key? ( game_winner )
					all_teams[ game_winner ] += 1 # increment by 1 if an existing key
				end # end of inner IF-block 
			end # end of outer IF-block 

		end # end of EACH-DO loop |games|

# Prints a list of all the loser teams that did not win one single game 
		all_teams.each do |thelosers|
			if ( thelosers[1] < 1 )
				puts "#{thelosers[0]} ==> #{thelosers[1]}"
			end
		end # end of EACH-DO loop |thewinners|
	end # end of team_losers function 

end # end AllMatchesPlayed class


# Step 1 of 2 (Super Extra Bonus): Instantiate new object
favorite_team = AllMatchesPlayed.new

puts "\nThis prints the match number, the home team, and the away team."
puts "This also prints the winner of the match."
favorite_team.print_matches()

puts "\nThis is a list of all the match locations and the matches played there: "
favorite_team.group_matches_by_location()

puts "\nThis is a list of all the winning teams: "
favorite_team.team_winners()

puts "\nThis is a list of all the losing teams: "
favorite_team.team_losers()

