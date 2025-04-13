local function contains(table_, value)
    for _, v in pairs(table_) do
        if v == value then
            return true
        end
    end

    return false
end

function most_played()
    local max_plays = 0
    local options = {}

    for k, v in pairs(G.GAME.hands) do
        if v.played > max_plays then
            max_plays = v.played
			options = { k }
        elseif v.played == max_plays then
            table.insert(options, k)
        end
    end

    if #options == 1 then
        return options[1]
    elseif #options > 1 then
        return pseudorandom_element(options, pseudoseed('hand_tie'))
    end
end

function count_unique()
    local found_ranks = {}
    for _, card in pairs(G.playing_cards) do
        local rank = card:get_id()
        if rank <= 14 and rank >= 2 then
            found_ranks[rank] = true
        end
    end
    local count = 0
    for _ in pairs(found_ranks) do
        count = count + 1
    end
    return count
end

local function most_rank()
	local rank_string = {
		[2]  = '2',
		[3]  = '3',
		[4]  = '4',
		[5]  = '5',
		[6]  = '6',
		[7]  = '7',
		[8]  = '8',
		[9]  = '9',
		[10] = 'T',
		[11] = 'J',
		[12] = 'Q',
		[13] = 'K',
		[14] = 'A',
	}
	local rank_counts = {}
	for _, card in pairs(G.playing_cards) do
		local rank = card:get_id()
		if rank <= 14 and rank >= 2 then
			rank_counts[rank] = (rank_counts[rank] or 0) + 1
		end
	end
	
	local max_count = 0
	for _, count in pairs(rank_counts) do
		if count > max_count then
			max_count = count
		end
	end
	local options = {}
	for rank, count in pairs(rank_counts) do
		if count == max_count then
			table.insert(options, rank)
		end
	end
	
	local chosen
	
	if #options == 0 then
		return rank_string[2]
	elseif #options == 1 then
		chosen = options[1]
	else
		chosen = pseudorandom_element(options, pseudoseed('ranktie'))
	end
	
	return { string_id = rank_string[chosen], num_id = chosen }
end

SMODS.Atlas {
	key = "gardenvariety",
	path = "gardenvariety.png",
	px = 71,
	py = 95
}


SMODS.Joker {
	key = 'mintcondition',
	config = { extra = { x_mult = 1.05 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult } }
	end,
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 0, y = 0 },
	cost = 7,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card.ability.set ~= "Enhanced" and not context.other_card.edition and not context.other_card.seal and not context.other_card.debuff  then
				return {
					x_mult = card.ability.extra.x_mult,
					card = other_card
				}
			end
		elseif context.end_of_round and not context.repetition and not context.individual and G.GAME.blind.boss and not context.blueprint then
			card.ability.extra.x_mult = card.ability.extra.x_mult + 0.05
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.RED,
				card = card
			}
		end
	end
}



SMODS.Joker {
	key = 'revolution',
	config = { extra = { money = 8, odds = 2, other_card = 1 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 0 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money, G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.destroy_cards
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			card.ability.extra.other_card = 1
		elseif context.destroying_card and not context.blueprint then
			if (context.scoring_hand[card.ability.extra.other_card]:get_id() == 12 
			or context.scoring_hand[card.ability.extra.other_card]:get_id() == 13) 
			and not context.scoring_hand[card.ability.extra.other_card].debuff  then
				if pseudorandom('coup') < G.GAME.probabilities.normal / card.ability.extra.odds then
						G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
						G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
						return {
							dollars = card.ability.extra.money,
							card = card,
						}
				end
			end
			card.ability.extra.other_card = card.ability.extra.other_card + 1
		end
	end
}

SMODS.Joker {
	key = 'excalibur',
	config = { extra = { perma_bonus = 20 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 2, y = 0 },
	soul_pos = { x = 0, y = 2 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.perma_bonus
			}
		}
	end,
	
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 11  and not context.other_card.debuff then
				context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.perma_bonus
				return {
					extra = { message = localize('k_upgrade_ex'), colour = G.C.CHIPS },
					colour = G.C.BLUE,
					card = card,
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'mismatchedsocks',
	config = { extra = { x_mult_gain = 0.2, x_mult = 1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
	end,
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 3, y = 0 },
	cost = 8,
	
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
				Xmult_mod = card.ability.extra.x_mult
			}
		elseif context.before and not next(context.poker_hands['Pair']) and not context.blueprint then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.RED,
				card = card
			}
		elseif context.before and next(context.poker_hands['Pair']) and card.ability.extra.x_mult > 1 and not context.blueprint then
			card.ability.extra.x_mult = 1
			return {
				message = localize('k_reset'),
				colour = G.C.attention,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'ghostpepper',
	config = { extra = { extra_mult = 15, extra_hand_size = 1, mult = 0, hand_size = 0 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 4, y = 0 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.extra_mult,
				card.ability.extra.extra_hand_size,
				card.ability.extra.mult,
				card.ability.extra.hand_size
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.cardarea == G.jokers and context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.extra_mult
			card.ability.extra.hand_size = card.ability.extra.hand_size + card.ability.extra.extra_hand_size
			G.hand:change_size(-1)
			return {
				message = localize("k_heatingup"),
				colour = G.C.RED,
				card = card
			}
		end
	end,
	
	remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end
}

SMODS.Joker {
	key = 'vinylstickers',
	effect = 'Glass Card',
	config = { extra = { r = 1 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 8, y = 4 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_glass 
        return
    end,
	
	calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card.config.center.key == "m_glass" then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.r,
                card = card
            }
        
        elseif context.repetition and context.cardarea == G.hand and context.other_card.config.center.key == "m_glass" then
            if (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.r,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
	key = 'oscillation',
	config = { extra = { chips = 0, chip_gain = 4, chip_loss = 3} },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 10, y = 4 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain, card.ability.extra.chip_loss } }
	end,
	
	calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		elseif context.individual and context.cardarea == G.play and not context.blueprint then
			local check_card = {
				[2] = "even",
				[3] = "odd",
				[4] = "even",
				[5] = "odd",
				[6] = "even",
				[7] = "odd",
				[8] = "even",
				[9] = "odd",
				[10] = "even",
				[14] = "odd"
			}
			local card_num = context.other_card:get_id()
			local value = check_card[card_num]
			if value == "even" then
				card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.BLUE,
					card = card
				}
			elseif value == "odd" then
				card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_loss
				if card.ability.extra.chips < 0 then
					card.ability.extra.chips = 0
				end
				return {
					message = 'Downgrade',
					colour = G.C.RED,
					card = card
				}
			end
		end
    end
}

SMODS.Joker {
	key = 'pulsar',
	config = { extra = { x_mult_gain = 0.4, x_mult = 1} },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 9, y = 4 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult_gain,
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
				colour = G.C.RED,
				card = card
			}
		elseif context.joker_main 
		and not self.debuff then
			if not card.ability.extra.x_mult ~= 1 then
				return {
					Xmult_mod = card.ability.extra.x_mult,
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
				}
			end
		elseif context.using_consumeable and not context.blueprint and context.consumeable.ability.set == 'Planet' then
			card.ability.extra.x_mult = 1
			return {
				message = localize('k_reset'),
				colour = G.C.attention
			}
		end
    end
}

SMODS.Joker {
	key = 'diyjoker',
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 7, y = 4 },
	cost = 8,
		
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
	end,
	
	calculate = function(self, card, context)
        if context.setting_blind 
		and not self.debuff 
		and not context.blueprint then
			for _, cons in pairs(G.consumeables.cards) do
				--[[if not cons:get_edition() then
					cons:set_edition('e_polychrome', true)
				end
				]]
				cons:set_edition('e_polychrome', true)
			end
			if #G.consumeables.cards > 0 then
				return {
					message = localize('k_poof'),
					colour = G.C.dark_edition,
					card = card
				}
			end
		end
    end
}

SMODS.Joker {
	key = 'housemoney',
	config = { extra = { money = 0, money_gain = 3, reset_time = false } },
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 9, y = 0 },
	cost = 3,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money,
				card.ability.extra.money_gain,
				card.ability.reset_time
			}
		}
	end,
	
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money
		if bonus > 0 then
			if card.ability.extra.reset_time then
				card.ability.extra.reset_time = false
				card.ability.extra.money = 0
			end
			return bonus
		end
	end,
	
	calculate = function(self, card, context)
        if context.before 
		and next(context.poker_hands['Full House'])
		and not context.blueprint
		and not self.debuff then
			card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.MONEY,
				card = card
			}
		end
		if context.end_of_round 
		and not context.repetition 
		and not context.individual 
		and G.GAME.blind.boss then
			card.ability.extra.reset_time = true
		end
    end
}

SMODS.Joker {
	key = 'goldrush',
	config = { extra = { money = 5, other_card = 1 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 10, y = 0 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return {
			vars = {
				card.ability.extra.money, card.ability.extra.destroy_cards
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			card.ability.extra.other_card = 1
		elseif context.destroying_card and not context.blueprint then
			if context.scoring_hand[card.ability.extra.other_card].config.center.key == "m_stone" and not context.scoring_hand[card.ability.extra.other_card].debuff then
				G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.money
				G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
				return {
					dollars = card.ability.extra.money,
					card = card,
				}
			end
			card.ability.extra.other_card = card.ability.extra.other_card + 1
		end
	end
}

SMODS.Joker {
	key = 'collector',
	config = { extra = { chips = 0, chip_gain = 15} },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 11, y = 0 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
	end,
	
	calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.chips > 0 then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		elseif context.open_booster and not context.blueprint then
			card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.BLUE,
				card = card
			}
		end
    end
}

SMODS.Joker {
	key = 'familyphoto',
	config = { extra = { x_mult_gain = 0.1, x_mult = 1 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 6, y = 4 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.x_mult_gain, card.ability.extra.x_mult } }
	end,
	
	calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.x_mult > 1 and not self.debuff then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		elseif context.before and not context.blueprint and next(context.poker_hands['Full House']) and not self.debuff then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
			return {
				message = localize('k_upgrade_ex')
			}
		end
    end
}

SMODS.Joker {
	key = 'popquiz',
	config = { extra = { mult = 0, mult_gain = 1} },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 1 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	calculate = function(self, card, context)
        if context.cardarea == G.hand and context.individual and not context.repetition and card.ability.extra.mult > 0 and not context.end_of_round then
			if context.other_card:get_id() == 14 and not context.other_card.debuff then
				return {
					mult = card.ability.extra.mult,
					card = context.other_card
				}
			end
		elseif context.individual 
		and context.cardarea == G.play 
		and not context.blueprint 
		and not self.debuff then
			if context.other_card:get_id() == 14 then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.RED,
					card = card
				}
			end
		end
    end
}

SMODS.Joker {
	key = 'horoscope',
	config = { extra = { odds = 3, odds2 = 6 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 2, y = 1 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.odds2
			}
		}
	end,
	
	
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
			if pseudorandom('spectral') < G.GAME.probabilities.normal / card.ability.extra.odds2 then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
								local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'spectral')
								card:add_to_deck()
								G.consumeables:emplace(card)
								G.GAME.consumeable_buffer = 0
							return true
						end)}))
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
                end
			end
			if pseudorandom('tarot') < G.GAME.probabilities.normal / card.ability.extra.odds then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
								local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'tarot')
								card:add_to_deck()
								G.consumeables:emplace(card)
								G.GAME.consumeable_buffer = 0
							return true
						end)}))
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_tarot'), colour = G.C.SECONDARY_SET.Tarot})
                end
			end
		end
	end
}

SMODS.Joker {
	key = 'lotteryticket',
	config = { extra = { money = 25, odds = 3, odds2 = 10 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 3, y = 1 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money, G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.odds2
			}
		}
	end,
	
	
	calculate = function(self, card, context)
		if context.ending_shop and not context.blueprint then
			if pseudorandom('lotto') < G.GAME.probabilities.normal / card.ability.extra.odds then
				ease_dollars(card.ability.extra.money)
				return {
					message = localize('k_lucky'),
					colour = G.C.attention
				}
			elseif pseudorandom('loss') < G.GAME.probabilities.normal / card.ability.extra.odds2 then
				local can_destroy = {}
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] ~= card and not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
						can_destroy[#can_destroy+1] = G.jokers.cards[i]
					end
                end
                local target_joker = #can_destroy > 0 and pseudorandom_element(can_destroy, pseudoseed('gambler')) or nil
                if target_joker and not (context.blueprint_card or card).getting_sliced then 
                    target_joker.getting_sliced = true
					
                    G.E_MANAGER:add_event(Event({func = function()
                        (context.blueprint_card or card):juice_up(0.8, 0.8)
                        target_joker:start_dissolve({G.C.RED}, nil, 1.6)
                    return true end }))
					
                end
                if not (context.blueprint_card or card).getting_sliced then
                    card_eval_status_text((context.blueprint_card or card), 'extra', nil, nil, nil, {message = 'Nope!', colour = G.C.RED})
                end
			end
		end
	end
}

SMODS.Joker {
	key = 'energydrink',
	config = { extra = { uses = 3 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 4, y = 1 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_foil
		info_queue[#info_queue+1] = G.P_CENTERS.e_holo
		info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
		return {
			vars = {
				card.ability.extra.uses
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.first_hand_drawn and not context.blueprint then
            juice_card_until(card, function() return G.GAME.current_round.hands_played == 0 end, true)
		end

		if context.before and not context.blueprint 
		and G.GAME.current_round.hands_played == 0 
		and #context.full_hand == 1 
		and not context.full_hand[1].edition then
			card.ability.extra.uses = card.ability.extra.uses - 1
			
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
				local edition = poll_edition('aura', nil, true, true)
				local aura_card = context.full_hand[1]
				aura_card:set_edition(edition, true)
			return true end }))
			
			if card.ability.extra.uses <= 0 then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize('k_eaten_ex'),
					colour = G.C.attention
				}
			else
				return {
					message = localize('k_decriment'),
					colour = G.C.attention
				}
			end
        end
	end
}

SMODS.Joker {
	key = 'cyclops',
	config = { extra = { x_mult = 3 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 5, y = 1 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and #context.full_hand == 1 and not self.debuff then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'override',
	config = { extra = { odds = 5, r = '2' } },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 6, y = 1 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.r
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			card.ability.extra.r = most_rank()
		elseif context.individual and context.cardarea == G.play and not context.blueprint then
			local c = context.other_card
			local _rank = card.ability.extra.r.string_id
			if pseudorandom('rankchange') < G.GAME.probabilities.normal / card.ability.extra.odds then
				if context.other_card:get_id() ~= card.ability.extra.r.num_id then
					G.E_MANAGER:add_event(Event({func = function()
					local suit_prefix = string.sub(c.base.suit, 1, 1)..'_'
					c:set_base(G.P_CARDS[suit_prefix.._rank])
					return true end }))
					
					return {
						message = localize('k_changed'),
						colour = G.C.BLUE,
						card = context.other_card
					}
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'grayscalejoker',
	config = { extra = { x_mult = 1, x_mult_change = 0.75 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 11, y = 1 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult, card.ability.extra.x_mult_change
			}
		}
	end,
	
	calculate = function(self, card, context)
		local total = count_unique()
		local change = card.ability.extra.x_mult_change
		card.ability.extra.x_mult = 1 + ((13 - total) * change)
		if card.ability.extra.x_mult < 1 then
			card.ability.extra.x_mult = 1
		end
		
		if context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'twodollarbill',
	config = { extra = { x_mult = 2.2 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 8, y = 1 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and ((G.GAME.dollars or 0) % 2) == 0 then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'onedollarbill',
	config = { extra = { chips = 111 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 9, y = 1 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and ((G.GAME.dollars or 0) % 2) ~= 0 then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
	end
}

SMODS.Joker {
	key = 'grimjoker',
	config = { extra = { money = 11 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 5, y = 4 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money
			}
		}
	end,
	
	calculate = function(self, card, context)
		
		if context.first_hand_drawn then
			local eval = function() return G.GAME.current_round.hands_played == 0 end
			juice_card_until(card, eval, true)
		end
		
		if context.before and G.GAME.current_round.hands_played == 0 and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 then
			
			local to_destroy = {}
			local ace_hand = {}
            for _, v in ipairs(G.hand.cards) do
				ace_hand[#ace_hand+1] = v
			end
			
            table.sort(ace_hand, function (a, b) return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card end)
            pseudoshuffle(ace_hand, pseudoseed('acedestroy'))

            for i = 1, 2 do
				to_destroy[#to_destroy+1] = ace_hand[i]
			end

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    for i=#to_destroy, 1, -1 do
                        local card = to_destroy[i]
                        if card.ability.name == 'Glass Card' then 
                            card:shatter()
                        else
                            card:start_dissolve(nil, i == #to_destroy)
                        end
                    end
                    return true end }))
            delay(0.5)
            ease_dollars(card.ability.extra.money)
			--return {
				--message = 'Winner!',
				--colour = G.C.attention
			--}
        end
	end
}

SMODS.Joker {
	key = 'erraticjoker',
	config = { extra = { x_mult = 1.25, x_mult_min = 0.5, x_mult_max = 4 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 7, y = 1 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult, card.ability.extra.x_mult_min, card.ability.extra.x_mult_max
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		elseif context.after and not context.blueprint then
			local mini = card.ability.extra.x_mult_min
			local maxi = card.ability.extra.x_mult_max
			local diff = maxi - mini
			card.ability.extra.x_mult = maxi - (diff * pseudorandom('randmult'))
			return {
				message = localize('k_updated'),
				colour = G.C.RED,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'downer',
	config = { extra = { hand_size = 2, rounds = 0, rounds_req = 3 } },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 2 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.e_negative
		return {
			vars = {
				card.ability.extra.hand_size,
				card.ability.extra.rounds,
				card.ability.extra.rounds_req
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.selling_self and card.ability.extra.rounds >= card.ability.extra.rounds_req and not context.blueprint then
			local eval = function(card) return not G.RESET_JIGGLES end
            juice_card_until(card, eval, true)
			
			local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then pos = i; break end
            end
			
            if pos and G.jokers.cards[pos+1] then 
                G.jokers.cards[pos+1]:set_edition('e_negative', true)
			end
		elseif context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
			if card.ability.extra.rounds < card.ability.extra.rounds_req then
				card.ability.extra.rounds = card.ability.extra.rounds + 1
			end
            if card.ability.extra.rounds_req <= card.ability.extra.rounds then 
                local eval = function(card) return not card.REMOVED end
                juice_card_until(card, eval, true)
            end
            return {
				message = (card.ability.extra.rounds < card.ability.extra.rounds_req) and (card.ability.extra.rounds..'/'..card.ability.extra.rounds_req) or localize('k_active_ex'),
                colour = G.C.FILTER
            }
		end
	end,
	
	add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.hand_size)
    end,
	
	remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.hand_size)
    end
}

SMODS.Joker {
	key = 'bloodmoney',
	config = { extra = { money = 0 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 2, y = 2 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.setting_blind and not context.getting_sliced and not context.blueprint then
			local pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then pos = i; break end
            end
			
            if pos and G.jokers.cards[pos+1] and not G.jokers.cards[pos+1].ability.eternal and not card.getting_sliced and not G.jokers.cards[pos+1].getting_sliced then 
                local killed = G.jokers.cards[pos+1]
                killed.getting_sliced = true
                G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.joker_buffer = 0
                    card:juice_up(0.8, 0.8)
                    killed:start_dissolve({HEX("57ecab")}, nil, 1.6)
                    play_sound('slice1', 0.96+math.random()*0.08)
                return true end }))
				
				local add_value = math.floor(killed.sell_cost / 2)
				if add_value < 1 then add_value = 1 end
				card.ability.extra.money = card.ability.extra.money + add_value
            end
		end
	end,
	
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money
		if bonus > 0 then
			return bonus
		end
	end
}

SMODS.Joker {
	key = 'terra',
	config = { extra = { odds = 8 } },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 11, y = 2 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS.Purple
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			for k, v in pairs(context.scoring_hand) do
				if pseudorandom('earth') < G.GAME.probabilities.normal / card.ability.extra.odds and v:is_suit("Spades") and not v.seal then
			
					G.E_MANAGER:add_event(Event({func = function()
					play_sound('tarot1')
					return true end }))
        
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.2,func = function()
					context.scoring_hand[k]:set_seal('Purple', nil, true)
					return true end }))
				
				end
			end
			
		end
	end
}

SMODS.Joker {
	key = 'aqua',
	config = { extra = { odds = 8 } },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 0, y = 3 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS.Blue
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			for k, v in pairs(context.scoring_hand) do
				if pseudorandom('water') < G.GAME.probabilities.normal / card.ability.extra.odds and v:is_suit("Clubs") and not v.seal then
			
					G.E_MANAGER:add_event(Event({func = function()
					play_sound('tarot1')
					return true end }))
        
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
					context.scoring_hand[k]:set_seal('Blue', nil, true)
					return true end }))
				
				end
			end
			
		end
	end
}

SMODS.Joker {
	key = 'aer',
	config = { extra = { odds = 8 } },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 3 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS.Red
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			for k, v in pairs(context.scoring_hand) do
				if pseudorandom('earth') < G.GAME.probabilities.normal / card.ability.extra.odds and v:is_suit("Hearts") and not v.seal then
			
					G.E_MANAGER:add_event(Event({func = function()
					play_sound('tarot1')
					return true end }))
        
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
					context.scoring_hand[k]:set_seal('Red', nil, true)
					return true end }))
				
				end
			end
			
		end
	end
}

SMODS.Joker {
	key = 'ignis',
	config = { extra = { odds = 8 } },
	rarity = 3,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 2, y = 3 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_SEALS.Gold
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			for k, v in pairs(context.scoring_hand) do
				if pseudorandom('earth') < G.GAME.probabilities.normal / card.ability.extra.odds and v:is_suit("Diamonds") and not v.seal then
			
					G.E_MANAGER:add_event(Event({func = function()
					play_sound('tarot1')
					return true end }))
        
					G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
					context.scoring_hand[k]:set_seal('Gold', nil, true)
					return true end }))
				
				end
			end
			
		end
	end
}

SMODS.Joker {
	key = 'jumbojoker',
	config = { extra = { mult = 0, mult_gain = 2 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 3, y = 2 },
	soul_pos = { x = 4, y = 2 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.mult_gain
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and not context.blueprint then
			if context.other_card:get_id() == 10 then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.attention,
					card = card
                }
			end
		elseif context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'wrapper',
	config = { extra = { discard = 1, odds = 4 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 4, y = 3 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.discard,
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and not context.individual and not context.repetition then
			if pseudorandom('discard') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({func = function()
                    ease_discard(card.ability.extra.discard, nil, true)
                    card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_discards', vars = {card.ability.extra.discard}}})
                return true end }))
			end
		end
	end
}

SMODS.Joker {
	key = 'pollution',
	config = { extra = { } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 3, y = 3 },
	cost = 7,
	
	calculate = function(self, card, context)
		if context.repetition and context.cardarea == G.play and context.other_card == context.scoring_hand[#context.scoring_hand] then
			return {
                message = localize('k_again_ex'),
                repetitions = G.GAME.current_round.discards_left,
                card = card
            }
		end
	end
}

SMODS.Joker {
	key = 'cmykjoker',
	config = { extra = { mult_gain = 3, mult = 0 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 5, y = 3 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_gain,
				card.ability.extra.mult,
				localize(G.GAME.current_round.ink_card.suit, 'suits_plural'),
				colours = { G.C.SUITS[G.GAME.current_round.ink_card.suit] }
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			local yes_mult = true
			for k, v in pairs(context.full_hand) do
				if not v:is_suit(G.GAME.current_round.ink_card.suit) then
					yes_mult = false
				end
			end
			if yes_mult then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.attention,
					card = card
                }
			end
		elseif context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'phantomjoker',
	config = { extra = { odds = 4 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 6, y = 3 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.open_booster and pseudorandom('phantom') < G.GAME.probabilities.normal / card.ability.extra.odds then
			if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    delay = 0.0,
                    func = (function()
                    local card = create_card('Spectral',G.consumeables, nil, nil, nil, nil, nil, 'phantom')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                    G.GAME.consumeable_buffer = 0
                    return true
                end)}))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral})
            end
		end
	end
}

--[[SMODS.Joker {
	key = 'medusa',
	loc_txt = {
		name = 'Medusa',
		text = {
			"All discarded {C:attention}face{} cards",
			"become {C:attention}Stone{} cards"
		}
	},
	config = { extra = { } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 7, y = 3 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
	end,
	
	calculate = function(self, card, context)
		if context.discard then
			local stones = {}
            for k, v in ipairs(context.full_hand) do
                if v:is_face() then
					--local seal = pseudorandom_element({'Red', 'Blue', 'Purple', 'Gold'}, pseudoseed('medusa'))
                    stones[#stones+1] = v
                    v:set_ability(G.P_CENTERS.m_stone, nil, true)
					--v:set_seal(seal, true)
					
                    G.E_MANAGER:add_event(Event({
                    func = function()
                    v:juice_up()
                    return true
                    end
                    })) 
                end
            end
            if #stones > 0 then 
                return {
                    message = 'Stone!',
                    colour = G.C.attention,
                    card = card
                }
            end
		end
	end
}
--]]

SMODS.Joker {
	key = 'obsidianjoker',
	config = { extra = { x_mult = 1, x_mult_gain = 0.05 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 11, y = 4 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.m_stone
		return {
			vars = {
				card.ability.extra.x_mult,
				card.ability.extra.x_mult_gain
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.discard and not context.blueprint then
			if context.other_card.config.center.key == "m_stone" then
				card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.RED,
					card = card
				}
			end
		elseif context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'whiteboard',
	config = { extra = { x_mult = 1.25 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 8, y = 3 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
				return {
					Xmult_mod = card.ability.extra.x_mult,
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
					card = context.other_card
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'shootingstar',
	config = { extra = { odds = 7 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 9, y = 3 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_CENTERS.c_black_hole
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:get_id() == 7 and pseudorandom('sevens') < G.GAME.probabilities.normal / card.ability.extra.odds then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
								local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, 'c_black_hole', 'planet')
								card:add_to_deck()
								G.consumeables:emplace(card)
								G.GAME.consumeable_buffer = 0
							return true
						end)}))
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = '+1 Black Hole', colour = G.C.SECONDARY_SET.Spectral})
                end
			end
		end
	end
}

SMODS.Joker {
	key = 'plusfour',
	config = { extra = { x_mult_gain = 0.4, x_mult = 1 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 10, y = 3 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult_gain,
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } },
				Xmult_mod = card.ability.extra.x_mult
			}
		elseif context.using_consumeable and not context.blueprint then
			card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
			return {
				message = localize('k_upgrade_ex'),
				colour = G.C.RED,
				card = card
			}
		elseif context.end_of_round and card.ability.extra.x_mult > 1 and not context.blueprint then
			card.ability.extra.x_mult = 1
			return {
				message = localize('k_reset'),
				colour = G.C.attention,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'piggybank',
	config = { extra = { money = 1, per_diamond = 3, current_money = 0 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 11, y = 3 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money,
				card.ability.extra.per_diamond,
				card.ability.extra.current_money
			}
		}
	end,
	
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.current_money
		if bonus > 0 then
			return bonus
		end
	end,
	
	calculate = function(self, card, context)
		
		local count = 0
		for _, v in pairs(G.playing_cards) do
			if v:is_suit("Diamonds") then
				count = count + 1
			end
		end
		
		card.ability.extra.current_money = math.floor(count / 3)
		
	end
}

SMODS.Joker {
	key = 'candyhearts',
	config = { extra = { mult_gain = 1, mult = 0 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 0, y = 4 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult_gain,
				card.ability.extra.mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		
		local count = 0
		for _, v in pairs(G.playing_cards) do
			if v:is_suit("Hearts") then
				count = count + 1
			end
		end
		
		card.ability.extra.mult = count * card.ability.extra.mult_gain
		
		if context.joker_main and card.ability.extra.mult > 0 then
			return {
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } },
				mult_mod = card.ability.extra.mult
			}
		end
	end
}

SMODS.Joker {
	key = 'darkness',
	config = { extra = { } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 4 },
	cost = 8,
	
	calculate = function(self, card, context)
		if context.before then
			local spade_count = 0
			for k, v in pairs(context.scoring_hand) do
				if v:is_suit('Spades') then
					spade_count = spade_count + 1
				end
			end
			
			if spade_count >= 3 then
				if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
					G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
					G.E_MANAGER:add_event(Event({
						trigger = 'before',
						delay = 0.0,
						func = (function()
								local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, nil, 'planet')
								card:add_to_deck()
								card:set_edition('e_negative', true)
								G.consumeables:emplace(card)
								G.GAME.consumeable_buffer = 0
							return true
						end)}))
					card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet})
                end
			end
		end
	end
}

SMODS.Joker {
	key = 'bananasplit',
	yes_pool_flag = 'gros_michel_extinct',
	config = { extra = { x_mult = 1.25, odds = 8 } },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 0, y = 5 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult,
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			return {
				x_mult = card.ability.extra.x_mult,
				card = other_card
			}
		end
		if context.end_of_round and not context.repetition and not context.game_over and not context.blueprint and not context.individual then
			if pseudorandom('bananasplit') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				return {
					message = localize('k_eaten_ex')
				}
			else
				return {
					message = localize('k_safe_ex')
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'plantain',
	yes_pool_flag = 'gros_michel_extinct',
	no_pool_flag = 'redplant_extinct',
	config = { extra = { mult = 6, odds = 6 } },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 5 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit("Clubs") or context.other_card:is_suit("Diamonds") then
				return {
					mult = card.ability.extra.mult,
					card = other_card
				}
			end
		end
		if context.end_of_round and not context.repetition and not context.game_over and not context.blueprint and not context.individual then
			if pseudorandom('plantain') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				G.GAME.pool_flags.redplant_extinct = true
				return {
					message = localize('k_extinct_ex')
				}
			else
				return {
					message = localize('k_safe_ex')
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'redbanana',
	yes_pool_flag = 'gros_michel_extinct',
	no_pool_flag = 'redplant_extinct',
	config = { extra = { mult = 6, odds = 6 } },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 2, y = 5 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			if context.other_card:is_suit("Spades") or context.other_card:is_suit("Hearts") then
				return {
					mult = card.ability.extra.mult,
					card = other_card
				}
			end
		end
		if context.end_of_round and not context.repetition and not context.game_over and not context.blueprint and not context.individual then
			if pseudorandom('redbanana') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				G.GAME.pool_flags.redplant_extinct = true
				return {
					message = localize('k_extinct_ex')
				}
			else
				return {
					message = localize('k_safe_ex')
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'goldenbanana',
	yes_pool_flag = 'redplant_extinct',
	config = { extra = { money = 25 } },
	rarity = 1,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 3, y = 5 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money
			}
		}
	end,
	
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money
		if bonus > 0 then
			return bonus
		end
	end
}

SMODS.Joker {
	key = 'mandarin',
	no_pool_flag = 'mandarin_extinct',
	config = { extra = { chips = 120, odds = 6 } },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 4, y = 5 },
	cost = 5,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips,
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
		if context.end_of_round and not context.repetition and not context.game_over and not context.blueprint and not context.individual then
			if pseudorandom('mandarin') < G.GAME.probabilities.normal / card.ability.extra.odds then
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
					end
				}))
				G.GAME.pool_flags.mandarin_extinct = true
				return {
					message = localize('k_eaten_ex')
				}
			else
				return {
					message = localize('k_safe_ex')
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'pomelo',
	yes_pool_flag = 'mandarin_extinct',
	config = { extra = { chips = 100, chips_min = 35, chips_max = 350 } },
	rarity = 1,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 5, y = 5 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips, card.ability.extra.chips_min, card.ability.extra.chips_max
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		elseif context.after and not context.blueprint then
			local mini = card.ability.extra.chips_min
			local maxi = card.ability.extra.chips_max
			local diff = maxi - mini
			card.ability.extra.chips = maxi - (diff * pseudorandom('randchips'))
			return {
				message = localize('k_updated'),
				colour = G.C.BLUE,
				card = card
			}
		end
	end
}

SMODS.Joker {
	key = 'poetryribbon',
	config = { extra = { x_mult = 2.5 } },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 6, y = 5 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.joker_main then
			local yes_mult = false
			for k, v in pairs(context.scoring_hand) do
				local suit = v.base.suit
				local rank = v:get_id()
				for _, w in pairs(context.scoring_hand) do
					if v ~= w and (suit == w.base.suit or w.config.center.key == "m_wild") and rank == w:get_id() then
						yes_mult = true
					end
				end
			end
			if yes_mult then
				return {
					Xmult_mod = card.ability.extra.x_mult,
					message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'crane',
	config = { extra = { x_mult = 1.5 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 7, y = 5 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play then
			local yes_mult = 0
			local suit = context.other_card.base.suit
			local rank = context.other_card:get_id()
			for _, w in pairs(context.scoring_hand) do
				if context.other_card ~= w and (suit == w.base.suit or w.config.center.key == "m_wild") and rank == w:get_id() then
					yes_mult = yes_mult + 1
				end
			end
			if yes_mult >= 2 then
				return {
					x_mult = card.ability.extra.x_mult,
					card = other_card
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'octahedron',
	config = { extra = { mult = 0, mult_gain = 3} },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 8, y = 5 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		elseif context.discard and not context.blueprint and G.GAME.current_round.discards_left == 1 then
			if context.other_card:get_id() == 8 then
				card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.RED,
					card = card
				}
			end
		end
    end
}

SMODS.Joker {
	key = 'orbit',
	config = { extra = { mult = 0, mult_gain = 2} },
	rarity = 2,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 9, y = 5 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.mult, card.ability.extra.mult_gain } }
	end,
	
	calculate = function(self, card, context)
		card.ability.extra.mult = G.GAME.hands[most_played()].level * card.ability.extra.mult_gain
		if card.ability.extra.mult == nil then card.ability.extra.mult = 0 end
        if context.joker_main and card.ability.extra.mult > 0 then
			return {
				mult_mod = card.ability.extra.mult,
				message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
			}
		end
    end
}

SMODS.Joker {
	key = 'beatupjoker',
	config = { extra = { x_mult = 1, x_mult_gain = 0.25, money = 1 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 2, y = 6 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult,
				card.ability.extra.x_mult_gain,
				card.ability.extra.money
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.end_of_round and not context.blueprint and not context.individual and not context.repetition then
			local yes_steal = false
			for k, v in ipairs(G.jokers.cards) do
                if v.set_cost and v.sell_cost > 0 and v ~= card then 
                    v.ability.extra_value = (v.ability.extra_value or 0) - card.ability.extra.money
                    v:set_cost()
					card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_mult_gain
					yes_steal = true
                end
            end
			if yes_steal then
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.RED,
					card = card
				}
			end
		elseif context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'iridescentquartz',
	config = { extra = { money = 4, chips = 200, mult = 28, x_mult = 3 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 10, y = 5 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild 
		return {
			vars = {
				card.ability.extra.money,
				card.ability.extra.chips,
				card.ability.extra.mult,
				card.ability.extra.x_mult
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.individual and context.cardarea == G.play and context.other_card.config.center.key == "m_wild" then
			local pick = pseudorandom('wildcard')
			if pick < 0.25 then
				ease_dollars(card.ability.extra.money)
			elseif pick < 0.5 then
				return { chips = card.ability.extra.chips }
			elseif pick < 0.75 then
				return { mult = card.ability.extra.mult }
			else
				return { x_mult = card.ability.extra.x_mult }
			end
		end
	end
}

SMODS.Joker {
	key = 'colorcard',
	config = { extra = { odds = 2 } },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = 'gardenvariety',
	pos = { x = 11, y = 5 },
	cost = 6,
	
	loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild 
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		local rank_string = {
			[2]  = '2',
			[3]  = '3',
			[4]  = '4',
			[5]  = '5',
			[6]  = '6',
			[7]  = '7',
			[8]  = '8',
			[9]  = '9',
			[10] = 'T',
			[11] = 'J',
			[12] = 'Q',
			[13] = 'K',
			[14] = 'A',
		}
		if context.before and not context.blueprint then
			for m, w in pairs(context.scoring_hand) do
				if w.config.center.key == "m_wild" then
					if pseudorandom("wildcard") < G.GAME.probabilities.normal / card.ability.extra.odds then
						for k, v in pairs(context.scoring_hand) do
							if w.base.suit ~= v.base.suit then
								local v_rank = rank_string[v:get_id()]
								local w_suit = string.sub(w.base.suit, 1, 1)..'_'
								v:set_base(G.P_CARDS[w_suit..v_rank])
							end
						end
					end
				end
			end
		end
	end
}

SMODS.Joker {
	key = 'recyclablejoker',
	config = { extra = { money = 0, money_gain = 1, discard_req = 15, remaining = 15} },
	rarity = 2,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 0, y = 6 },
	cost = 7,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.money,
				card.ability.extra.money_gain,
				card.ability.extra.discard_req,
				card.ability.extra.remaining
			}
		}
	end,
	
	calc_dollar_bonus = function(self, card)
		local bonus = card.ability.extra.money
		if bonus > 0 then
			return bonus
		end
	end,
	
	calculate = function(self, card, context)
		if context.discard and not context.blueprint then
			if card.ability.extra.remaining > 1 then
				card.ability.extra.remaining = card.ability.extra.remaining - 1
			else
				card.ability.extra.remaining = card.ability.extra.discard_req
				card.ability.extra.money = card.ability.extra.money + card.ability.extra.money_gain
				return {
					message = localize('k_upgrade_ex'),
					colour = G.C.attention,
					card = card
				}
			end
		end
	end
}

SMODS.Joker {
	key = 'arcadecard',
	config = { extra = { chips = 0, chip_gain = 1 } },
	rarity = 3,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 1, y = 6 },
	cost = 8,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.chips,
				card.ability.extra.chip_gain
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.ending_shop and not context.blueprint and not context.individual and not context.repetition then
			if (G.GAME.dollars or 0) > 0 then
				card.ability.extra.chips = card.ability.extra.chips + (G.GAME.dollars * card.ability.extra.chip_gain)
				return {
                    message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
                }
			end
		elseif context.joker_main and card.ability.extra.chips > 0 then
			return {
				chip_mod = card.ability.extra.chips,
				message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
			}
		end
	end
}

SMODS.Joker {
	key = 'dagonet',
	config = { extra = { x_mult = 1, x_mult_gain = 0.1, dollar_lim = 7 } },
	rarity = 4,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 5, y = 2 },
	soul_pos = { x = 6, y = 2 },
	cost = 20,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.x_mult,
				card.ability.extra.x_mult_gain,
				card.ability.extra.dollar_lim
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.ending_shop and not context.blueprint and not context.individual and not context.repetition then
			if (G.GAME.dollars or 0) > card.ability.extra.dollar_lim then
				card.ability.extra.x_mult = card.ability.extra.x_mult + (card.ability.extra.x_mult_gain * math.floor(G.GAME.dollars / 5))
				return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
                }
			end
		elseif context.joker_main and card.ability.extra.x_mult > 1 then
			return {
				Xmult_mod = card.ability.extra.x_mult,
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.x_mult } }
			}
		end
	end
}

SMODS.Joker {
	key = 'stanczyk',
	config = { extra = { odds = 3 } },
	rarity = 4,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 7, y = 2 },
	soul_pos = { x = 8, y = 2 },
	cost = 20,
	
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				G.GAME.probabilities.normal,
				card.ability.extra.odds
			}
		}
	end,
	
	calculate = function(self, card, context)
		if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
						
			local hand = most_played()
			local again = 1
			
			if hand and pseudorandom('stanczyk') < G.GAME.probabilities.normal / card.ability.extra.odds then
				again = 2
			end
			
			for i = 1, again do
				update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
				{ handname = localize(hand, 'poker_hands'), chips = G.GAME.hands[hand].chips, mult = G.GAME.hands[hand].mult, level = G.GAME.hands[hand].level })
				level_up_hand(context.blueprint_card or card, hand)
				update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 }, { mult = 0, chips = 0, handname = '', level = '' })
			end
		end
	end
}

SMODS.Joker {
	key = 'roland',
	loc_txt = {
		name = 'Roland',
		text = {
			"Retrigger all {C:attention}numbered{}",
			"cards twice"
		}
	},
	config = { extra = { r = 2 } },
	rarity = 4,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = false,
	atlas = 'gardenvariety',
	pos = { x = 9, y = 2 },
	soul_pos = { x = 10, y = 2 },
	cost = 20,
	
	calculate = function(self, card, context)
		local valid = {[2]  = true,[3]  = true, [4]  = true,[5]  = true,[6]  = true,[7]  = true,[8]  = true,[9]  = true,[10] = true,[14] = true}
		
		if context.repetition and context.cardarea == G.play and valid[context.other_card:get_id()] then
            return {
                message = localize('k_again_ex'),
                repetitions = card.ability.extra.r,
                card = card
            }
        
        elseif context.repetition and context.cardarea == G.hand and valid[context.other_card:get_id()] then
            if (next(context.card_effects[1]) or #context.card_effects > 1) then
                return {
                    message = localize('k_again_ex'),
                    repetitions = card.ability.extra.r,
                    card = card
                }
            end
        end
	end
}


local igo = Game.init_game_object
function Game:init_game_object()
	local ret = igo(self)
	ret.current_round.ink_card = { suit = 'Spades' }
	return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
	G.GAME.current_round.ink_card = { suit = 'Spades' }
	local valid_cards = {}
	
	for _, v in ipairs(G.playing_cards) do
		if not SMODS.has_no_suit(v) then
			valid_cards[#valid_cards + 1] = v
		end
	end
	
	if #valid_cards ~= 0 then
		local new_suit = pseudorandom_element(valid_cards, pseudoseed('inkcart' .. G.GAME.round_resets.ante))
		G.GAME.current_round.ink_card.suit = new_suit.base.suit
	end
end
