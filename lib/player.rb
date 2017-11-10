class Player
  attr_accessor :final_sc, :id, :acc

  def initialize(id)
    @id = id
    @final_sc = 0
    @acc = false
  end

  # Accumulated Score (if matches the accumulation condn, then returns the turn score to be accumulated)
  def get_acc_sc(turn_sc)
    if @acc == false && turn_sc >= 300
      @acc = true
      puts '-----Turn score >= 300. Your scores will be accumulated now-----'
    elsif @acc == false
      turn_sc = 0
      puts "------Turn score < 300. Your scores will not be accumulated-----"
    end
    turn_sc
  end

  # Get current dice count i.e. non-scording dices
  def get_curr_dice_count(dice_count, vals)
    valid_dice = vals.select { |val| val != 1 && val != 5 && vals.count(val) >= 3 }
    
    if valid_dice.size >= 3
      dice_count -= 3 
    end

    valid_dice = vals.select { |val| val == 1 || val == 5 }
    dice_count -= valid_dice.size

    if dice_count == 0
      dice_count = 5 
    end

    dice_count
  end

  # For each roll, rolls dice and calculates roll score
  def process_diceset_roll(diceset, dice_count, turn_sc)
    diceset.process_roll(dice_count)
    vals = diceset.get_vals
    puts "Rolls: #{vals}"
    roll_sc = diceset.get_score(vals)
    puts "Roll score: #{roll_sc}"

    if roll_sc == 0
      turn_sc = 0
    else
      turn_sc += roll_sc
      dice_count = get_curr_dice_count(dice_count, vals)
    end

    [dice_count, turn_sc]
  end

  # Process dice roll turns for each player
  def process_turn(dice)
    turn_sc = 0
    dice_count = 5
    turn_count = 0

    puts "\nPlayer #{@id}"
    loop do
      dice_count, turn_sc = process_diceset_roll(dice, dice_count, turn_sc)
      break if turn_sc == 0

      puts "Do you want to roll the non-scoring #{dice_count} dices? [y/n]"
      next unless gets.strip == 'n'

      turn_sc = get_acc_sc(turn_sc)
      break
    end

    @final_sc += turn_sc
    puts "Turn Score: #{turn_sc}"
    puts "Final Score: #{@final_sc}"
  end
end
