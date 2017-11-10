require_relative 'diceset'
require_relative 'player'

class Main
  attr_reader :players, :diceset, :player_count

  def initialize(player_count_val)
    @player_count=player_count_val.to_i
    if @player_count <= 1
      puts "Number of players must be >= 1"
      exit
    end

    @players = []
    @diceset = DiceSet.new

    i = 1
    @player_count.times {
      player = Player.new(i)
      @players << player
      i += 1
    }
  end

  #Last round logic
  def process_last_round(stop_id, player)
    if player.final_sc >= 3000
      puts "-----Player #{player.id} crosses 3000 i.e. score >= 3000-----"
      puts "\n -----LAST ROUND------\n"
      stop_id = player.id if stop_id == -1
    end                                               
    stop_id
  end

  # Output total score for all the players
  def output_player_ts
    player_ts = {}
    @players.each { |player| player_ts[player.id] = player.final_sc }
    puts "\nPlayer's Total Scores: #{player_ts}\n"
  end

  #get winner with the maximum score
  def get_winner
    winner_id = -1
    winner_sc = 0
    @players.each { |player|
      if player.final_sc > winner_sc
        winner_id = player.id
        winner_sc = player.final_sc
      end
    }

    [winner_id, winner_sc]
  end

  #main process
  def process
    stop_id = -1
    turn_count=0
    catch :stop_game do
      loop do
        @players.each do |player|
          throw :stop_game if player.id == stop_id

          pc = @player_count
          if turn_count % pc == 0
            tc = (turn_count/pc) + 1
            puts "\nTurn #{tc}\n"
          end

          player.process_turn(@diceset)

          stop_id = process_last_round(stop_id, player)
          output_player_ts
          turn_count += 1
        end
      end
    end

    winner_id, winner_score = get_winner
    puts "\nWINNER: Player #{winner_id} with winning score of #{winner_score}\n"
  end

end


#entry point
if __FILE__ == $PROGRAM_NAME
  puts "Enter number of players: (>= 1) \n"
  player_count = gets.chomp
  main = Main.new(player_count)
  main.process
end
