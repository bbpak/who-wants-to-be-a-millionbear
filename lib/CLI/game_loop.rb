$game_session = nil

def start_game(user)
  initiate_game(user)
  question_loop
  end_message
  play_again?(user)
end

def clear_all
  GameSession.delete_all
  UserGuess.delete_all
  Question.delete_all
end

def initiate_game(user)
  clear_all
  $game_session = GameSession.create(user_id: user.id)

  TriviaApi.get_questions.each do |question|
    Question.create(question)
  end
end

def question_loop
  system "clear"
  Question.all.each do |quest|
    answer_hash = shuffle_and_print_answers(quest)
    puts

    puts "Enter your answer:"
    user_input = gets.chomp
    check_answer(quest, answer_hash, user_input)
    sleep(1.5)
    system "clear"
  end
end


def shuffle_and_print_answers(question)
  answers = [
    question.correct,
    question.incorrect1,
    question.incorrect2,
    question.incorrect3
  ].shuffle

  answers_hash = {}
  letter = "A"
  answers.each do |answer|
    answers_hash[letter] = answer
    letter = letter.next
  end

  puts question.question.center(80)
  puts
  puts print_answers(answers_hash)
  return answers_hash
end

def check_answer(quest, answer_hash, user_input)
  #track points in game_session. store correctness?
  correctness = answer_hash[user_input.upcase] == quest.correct

  if correctness
    puts "Correct"
    puts
  else
    puts "Bearly missed it.".colorize(:red)
    puts
    puts "The correct answer was: #{quest.correct}"
    puts
  end

  UserGuess.create(
    question_id: quest.id,
    game_session_id: $game_session.id,
    correctness: correctness
  )
end

def print_answers(answers)
  Terminal::Table.new do |t|
    t.add_row ["A. #{answers["A"]}", "B. #{answers["B"]}"]
    t.add_row ["C. #{answers["C"]}", "D. #{answers["D"]}"]
    t.style = {:all_separators => true, :width => 80}
  end
end

def end_message
  puts "Thanks for playing!"
  puts "You got #{$game_session.get_correct_questions.length} questions correct and earned #{$game_session.total_score} points!!"
  puts
end

def play_again?(user)
  puts "Would you like to play again? (yes/no)"
  user_input = gets.chomp
  if user_input == "yes"
    start_game(user)
  else
    puts "Goodbye!"
    return
  end
end
