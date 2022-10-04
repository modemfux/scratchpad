def win_percentage(opp_rating, player_rating):
# opp_rating - opponent's rating
    result = round(100 / (10 ** ((opp_rating - player_rating) / 400) + 1))
    return result

def new_rating(player_rating, k_value, win_value, exp_win_percentage):
# player_rating - starting rating
# k_value - multiplier for new rating's calculations, should be some default value like 8, 16, etc from tournament value
# win_value - match_result, default values is: win = 1, draw = 0.5, lose = 0. Should implement check for values.
# exp_win_percentage - expected win percentage from win_percentage function.
    result = player_rating + k_value * (win_value - (exp_win_percentage / 100))
    return result
