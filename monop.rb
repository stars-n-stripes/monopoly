$players = []

def setup_board
  board = [] # make this a global!
  raw = File.readlines("properties.txt")
  each { l || raw }
    ll = l.split(",")
    spot = {:name => ll[0], :rent => ll[1].to_i, :houses => 0, :rent_1h => ll[2], :rent_2h => ll[3], :rent_3h => ll[4], :rent_4h => ll[5], rent_hotel => ll[6], :owner => nil, :color => ll[7], :cost => ll[8]}
    board.append(spot)
  end
  board
end

def setup_player(id)
  player = {:id => id, :money => 1500, :location => 0, :sock => nil} # HASHES not dictionaries!
end

def build_players(n)
  players = []
  for p in 1..n
    #need to add sockets sometime
    $players.append(setup_player(p))
  end
  players
end

def run_turn(board, player)
  doubles = 0

  while doubles < 3
    die1 = rand(6) + 1
    die2 = rand(6) + 1
    if die1 == die2
      double = TRUE
      doubles += 1
    else
      double = FALSE
      doubles += 1
    end
    player[:location] += die1 + die2
    land(player, board)
  end

end

def land(player, board)
  loc = player[:location]
  landed_name = board[player[:location]][:name]
  if landed_name == landed_name.upcase
    # It's not a regular property
    handle_special(landed_name, player)
  else
    if board[loc][:owner] == nil
      buy(board, loc, player)
    end
    if board[loc][owner] != player[:id]
      pay(player, get_player(board[loc][:owner]), board[loc][:cost])
    end
  end
end

def get_player(id)
  $players[id]
end

def buy(board, location, player)
  # We can add the option later if we have time
  if player[:money] >= board[location][:cost]
    player[:money] -= board[location][:cost]
    board[location][:owner] = player[:id]
    puts "Property #{board[location][:name]} bought for #{board[location][:cost]}."
  else
    puts "Not enough money!"
  end
end

def rent(payer, recipient, cost)
  if payer[:money] >= cost
    payer[:money] -= cost
    recipient[:money] += cost
    puts "Player #{payer[:id]} has paid player #{recipient[:id]} $#{cost}"
  else
    # Can add options for mortgaging and stuff later
    bankrupt(payer[:id])
  end

end