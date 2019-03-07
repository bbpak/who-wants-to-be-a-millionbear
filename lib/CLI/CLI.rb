# Main method for starting the game
# Called in bin/run.rb
def play_game
  print "\e[8;1000;1000t"
  welcome if !$TEST_MODE
  current_user = get_user
  menu(current_user)
end

# Gratuitous ASCII art introduction
def welcome
  system "clear"
  aa = Artii::Base.new :font => 'univers'
  bb = Artii::Base.new :font => 'doh'
  cc = Artii::Base.new :font => 'larry3d'
  dd = Artii::Base.new :font => 'banner3'
  # puts bb.asciify('Welcome to')
  # sleep(2)
  # system "clear"
  # puts aa.asciify("Who Wants To Be A")
  # sleep(1)
  # puts bb.asciify("   Millionbear").center(100)
  # puts cc.asciify(" $$$$$$$$$$$$$$$$$$$$$$$").center(100)
  # sleep(2)
  # system "clear"
  # puts aa.asciify "      With your host"
  # sleep(1)
  system "clear"
  puts bb.asciify "Alex"
  puts bb.asciify "Trebear"
  sleep(2)
  system "clear"
  #bear_host
  Catpix::print_image "lib/cli/img/bear5.png",
    :center_x => true,
    :resolution => "low",
    :bg_fill => false
  puts
end

# Asks for user input for user name
# And creates new user instance

def get_user
  puts "What's your name?".center(200)
  print "                                                "
  print "                                                "
  new_name = gets.chomp
  puts
  new_user = User.create(name: new_name)
  new_user
end
# def get_user
#   dd= Artii::Base.new :font => 'invita'
#   puts
#   puts dd.asciify("What's your name?")
#   new_name = gets.chomp
#   puts
#   system "clear"
#   new_user = User.create(name: new_name)
#   new_user
# end

# Main menu for user to start game, view leaderboard, or exit
def menu(user)
  system "clear"
  print "\e[8;1000;1000t"
  aa = Artii::Base.new :font => 'doom'
  puts aa.asciify("What would you like to do?")
  puts
  puts aa.asciify("1. Play a New Game")
  puts aa.asciify("2. View Leaderboard")
  puts aa.asciify("3. How to Play")
  puts aa.asciify("4. Exit")

  # puts "What would you like to do?".center($GAME_WIDTH)
  # puts
  # puts "1. Play a new game ".center($GAME_WIDTH)
  # puts "2. View Leaderboard".center($GAME_WIDTH)
  # puts "3. Exit            ".center($GAME_WIDTH)
  # puts "4. Credits         ".center($GAME_WIDTH)

  user_input = gets.chomp
  if user_input == "1"
    start_game(user)
  elsif user_input == "2"
    display_leaderboard(user)
  elsif user_input == '3'
    how_to_play(user)
  elsif user_input == "4"
    system "clear"
    puts aa.asciify("Thanks for playing!")
    bye_bear
    sleep(3)
    return nil
  else
    puts "Selection not recognized"
    menu(user)
  end
end

def display_leaderboard(user)
  system "clear"
  rows = []
  count = 1
  puts "Leaderboard:"
  puts
  top_scores = GameSession.all.max_by(10){|sesh| sesh.total_score}
  top_scores.each do |gg|
    rows << [count, gg.user.name, gg.total_score]
   #puts "#{count}. #{gg.user.name}"
    count += 1
   end
   table = Terminal::Table.new :headings => ["Rank", "Name", "Score"], :rows => rows
   puts table
   sleep(3)
   menu(user)
end
