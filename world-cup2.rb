require 'httparty'

class AllMatchesPlayed
	def print_matches
		response = HTTParty.get('http://worldcup.sfg.io/matches')

		rabbit = response.parsed_response

		puts "Match #    Home Team     Away Team\n"
		puts "-------    ---------     ---------\n"
#		puts rabbit.first['home_team']['country']
		rabbit.each do |games|
# This IF-block checks whether the home_team field is hash or not.  
# A hash will contain the information from the completed game.  
# If not a hash (it will probably be an array), then it will not 
# contain any information as the game has not been played yet.  
			if ( ( games['home_team'].class.to_s() =~ /^Hash$/ ) && 
				 ( games['away_team'].class.to_s() =~ /^Hash$/ ) )
				puts "\nMatch #{games['match_number']}:  #{games['home_team']['country']}  #{games['away_team']['country']}"
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

		charliehorse = response.parsed_response
#		puts charliehorse.first['home_team']['country']

		location_of_matches = {}

# This EACH-DO loop will iterate through all the matches? 
		charliehorse.each do |games|
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

		puts "Location    Match #\n"
		puts "--------    ----------------------------------\n"

		location_of_matches.each do |stadium|
			puts stadium # what happens when you print this??
		end # end of EACH-DO loop |stadium|

	end # end group_matches_by_location function 



	def team_wins
# Makes sure you list of teams do not include 'Draw'
# 
		response = HTTParty.get('http://worldcup.sfg.io/matches')

		battlestar = response.parsed_response

		location_of_matches = {}

# This EACH-DO loop will iterate through all the matches? 
		battlestar.each do |games|

		end 

	end # end of team_wins function


end # end AllMatchesPlayed class


# Step 1 of 2 (Super Extra Bonus): Instantiate new object
favorite_team = AllMatchesPlayed.new

# Step 2 of 2 (Super Extra Bonus): Call function in Class AllMatchesPlayed
favorite_team.print_matches()

# favorite_team.group_matches_by_location()

# favorite_team.team_wins()


