class DiceSet
  
  def initialize
    @vals = []
  end

  # generate random vals for a roll of a diceset
  def process_roll(dice_count)
    @vals = Array.new(dice_count) { rand(1..6) }
  end

  # get face values of a roll of a diceset
  def get_vals
    @vals
  end

  #get_score function calculates score for each roll
  def get_score(vals)
    total_sc = 0

    #get count of each face on dices
    fc_count_hash = {}
    fc = 1
    6.times {
      fc_count_hash[fc] = vals.count(fc)
      fc += 1
    }

    fc_count_hash.each { |key, _value|
      if fc_count_hash[key] >= 3
        total_sc += key * 100
        total_sc *= 10 if key == 1
        fc_count_hash[key] -= 3
      end

      total_sc += 100 * fc_count_hash[key] if key == 1
      total_sc += 50 * fc_count_hash[key] if key == 5
    }
    
    total_sc
  end
end
