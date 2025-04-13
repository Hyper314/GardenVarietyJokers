return {
    descriptions = {
        Joker = {
            -- this name tag comes from j for joker, the 'atlas' tag, and the 'prefix' for the card.
            j_garden_mintcondition = {
                name = 'Mint Condition',
                text = {
                    "Cards with no {C:attention}Seals{},",
                    "{C:enhanced}Enhancements{}, or {C:dark_edition}Editions{}",
                    "give {X:mult,C:white}X#1#{} Mult when scored",
                    "Increases by {X:mult,C:white}X0.05{} when",
                    "{C:attention}Boss Blind{} is defeated"
                }
            },
            j_garden_revolution = {
                name = 'Revolution',
                text = {
                    "Scored {C:attention}Kings{} and {C:attention}Queens{}",
                    "have a {C:green}#2# in #3#{} chance to be",
                    "destroyed and give {C:money}$#1#{}"
                }
            },
            j_garden_excalibur = {
                name = 'Excalibur',
                text = {
                    "Scored {C:attention}Jacks{} permanently",
                    "gain {C:chips}+#1#{} Chips"
                }
            },
            j_garden_mismatchedsocks = {
                name = 'Mismatched Socks',
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult per",
                    "{C:attention}consecutive{} hand played that does",
                    "not contain a {C:attention}Pair{}",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult{}"
                }
            },
            j_garden_ghostpepper = {
                name = 'Ghost Pepper',
                text = {
                    "{C:mult}+#1#{} Mult and {C:attention}-#2#{} hand size",
                    "after each round played",
                    "{C:inactive}(Currently {C:mult}+#3#{} {C:inactive}Mult, {C:attention}-#4#{} {C:inactive}hand size){}"
                }
            },
            j_garden_vinylstickers = {
                name = 'Vinyl Stickers',
                text = {
                    "Retrigger all {C:attention}Glass{} cards"
                }
            },
            j_garden_oscillation = {
                name = 'Oscillation',
                text = {
                    "This Joker gains {C:chips}+#2#{} Chips per",
                    "scored {C:attention}even{} rank, but loses",
                    "{C:chips}-#3#{} Chips per scored {C:attention}odd{} rank",
                    "{C:inactive}(Currently{} {C:chips}+#1#{} {C:inactive}Chips){}"
                }
            },
            j_garden_pulsar = {
                name = 'Pulsar',
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult when",
                    "{C:attention}Blind{} is selected",
                    "Resets when a {C:planet}Planet{} card is used",
                    "{C:inactive}(Currently{} {X:mult,C:white}X#2#{} {C:inactive}Mult){}"
                }
            },
            j_garden_diyjoker = {
                name = 'DIY Joker',
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "all held consumables",
                    "become {C:dark_edition}Polychrome{}"
                }
            },
            j_garden_housemoney = {
                name = 'House Money',
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "Payout increases by {C:money}$#2#{}",
                    "if hand contains a {C:attention}Full House{}",
                    "Payout resets each ante"
                }
            },
            j_garden_goldrush = {
                name = 'Gold Rush',
                text = {
                    "Scored {C:attention}Stone{} cards are",
                    "destroyed and give {C:money}$#1#{}"
                }
            },
            j_garden_collector = {
                name = 'Collector',
                text = {
                    "This Joker gains {C:chips}+#2#{} Chips when",
                    "any {C:attention}Booster Pack{} is opened",
                    "{C:inactive}(Currently{} {C:chips}+#1#{} {C:inactive}Chips){}"
                }
            },
            j_garden_familyphoto = {
                name = 'Family Photo',
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult if played",
                    "hand contains a {C:attention}Full House{}",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{} {C:inactive}Mult)"
                }
            },
            j_garden_popquiz = {
                name = 'Pop Quiz',
                text = {
                    "Each {C:attention}Ace{} held in hand gives",
                    "{C:mult}+#1#{} Mult, increases by",
                    "{C:mult}+#2#{} Mult when an {C:attention}Ace{} is scored",
                }
            },
            j_garden_horoscope = {
                name = 'Horoscope',
                text = {
                    "When a {C:planet}Planet{} card is used:",
                    "{C:green}#1# in #2#{} chance to create a random {C:tarot}Tarot{} card",
                    "{C:green}#1# in #3#{} chance to create a random {C:spectral}Spectral{} card",
                    "{C:inactive}(Must have room){}"
                }
            },
            j_garden_lotteryticket = {
                name = 'Lottery Ticket',
                text = {
                    "At end of {C:attention}shop{},",
                    "{C:green}#2# in #3#{} chance to earn {C:money}$#1#{}",
                    "{C:green}#2# in #4#{} chance to {C:attention{}destroy{}",
                    "a random {C:attention}Joker{}"
                }
            },
            j_garden_energydrink = {
                name = 'Energy Drink',
                text = {
                    "If {C:attention}first hand{} of round has only {C:attention}1{}",
                    "card, add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{}",
                    "or {C:dark_edition}Polychrome{} to card",
                    "{C:inactive}(Uses remaining: {C:attention}#1#{C:inactive}){}"
                }
            },
            j_garden_cyclops = {
                name = 'Cyclops',
                text = {
                    "{X:mult,C:white}X#1#{} Mult if hand",
                    "contains only {C:attention}1{} card"
                }
            },
            j_garden_override = {
                name = 'Override',
                text = {
                    "{C:green}#1# in #2#{} chance to convert",
                    "any scored card into the most",
                    "abundant {C:attention}rank{} in {C:attention}full deck",
                    "{C:inactive}(Randomly chosen in case of tie){}"
                }
            },
            j_garden_grayscalejoker = {
                name = 'Grayscale Joker',
                text = {
                    "This Joker gives {X:mult,C:white}X#2#{} Mult",
                    "for each {C:attention}rank{} that does not",
                    "exist in {C:attention}full deck{}",
                    "{C:inactive}(Currently{} {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
                }
            },
            j_garden_twodollarbill = {
                name = 'Two Dollar Bill',
                text = {
                    "{X:mult,C:white}X#1#{} Mult if current {C:money}money{}",
                    "is an {C:attention}even{} number"
                }
            },
            j_garden_onedollarbill = {
                name = 'One Dollar Bill',
                text = {
                    "{C:chips}+#1#{} Chips if current {C:money}money{}",
                    "is an {C:attention}odd{} number"
                }
            },
            j_garden_grimjoker = {
                name = 'Grim Joker',
                text = {
                    "If {C:attention}first hand{} of round is a",
                    "single {C:attention}Ace{}, destroy two random",
                    "cards in hand and earn {C:money}$#1#{}"
                }
            },
            j_garden_erraticjoker = {
                name = 'Erratic Joker',
                text = {
                    "Gives between {X:mult,C:white}X#2#{}",
                    "and {X:mult,C:white}X#3#{} Mult",
                    "{C:inactive}(Next hand:{} {X:mult,C:white}X#1#{}{C:inactive} Mult){}"
                }
            },
            j_garden_downer = {
                name = 'Downer',
                text = {
                    "{C:attention}-#1#{} hand size",
                    "After {C:attention}#3#{} rounds, sell",
                    "this card to add {C:dark_edition}Negative{}",
                    "to the Joker to the {C:attention}right{}",
                    "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#3#)",
                }
            },
            j_garden_bloodmoney = {
                name = 'Blood Money',
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "When {C:attention}Blind{} is selected,",
                    "destroy Joker to the right",
                    "and add {C:attention}half{} its {C:attention}sell value",
                    "to payout"
                }
            },
            j_garden_terra = {
                name = 'Terra',
                text = {
                    "{C:green}#1# in #2#{} chance to add a",
                    "{C:purple}Purple Seal{} to played {C:spades}Spades{}",
                    "after scoring"
                }
            },
            j_garden_aqua = {
                name = 'Aqua',
                text = {
                    "{C:green}#1# in #2#{} chance to add a",
                    "{C:blue}Blue Seal{} to played {C:clubs}Clubs{}",
                    "after scoring"
                }
            },
            j_garden_aer = {
                name = 'Aer',
                text = {
                    "{C:green}#1# in #2#{} chance to add a",
                    "{C:red}Red Seal{} to played {C:hearts}Hearts{}",
                    "after scoring"
                }
            },
            j_garden_ignis = {
                name = 'Ignis',
                text = {
                    "{C:green}#1# in #2#{} chance to add a",
                    "{C:money}Gold Seal{} to played {C:diamonds}Diamonds{}",
                    "after scoring"
                }
            },
            j_garden_jumbojoker = {
                name = 'Jumbo Joker',
                text = {
                    "This Joker gains",
                    "{C:mult}+#2#{} Mult when each",
                    "played {C:attention}10{} is scored",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },
            j_garden_wrapper = {
                name = 'Wrapper',
                text = {
                    "{C:green}#2# in #3#{} chance to gain",
                    "{C:red}+#1#{} discard for the current round",
                    "after each {C:attention}played hand"
                }
            },
            j_garden_pollution = {
                name = 'Pollution',
                text = {
                    "Retrigger the {C:attention}last{} scored card",
                    "once for each remaining {C:red}discard"
                }
            },
            j_garden_cmykjoker = {
                name = 'CMYK Joker',
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult if played",
                    "hand contains only {V:1}#3#{}, suit",
                    "changes every round",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                }
            },
            j_garden_phantomjoker = {
                name = 'Phantom Joker',
                text = {
                    "{C:green}#1# in #2#{} chance to create",
                    "a {C:spectral}Spectral{} card when any",
                    "{C:attention}Booster Pack{} is opened",
                    "{C:inactive}(Must have room)"
                }
            },
            j_garden_obsidionjoker = {
                name = 'Obsidian Joker',
                text = {
                    "This Joker gains {X:mult,C:white}X#2#{} Mult each",
                    "time a {C:attention}Stone{} card is discarded",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{} {C:inactive}Mult)"
                }
            },
            j_garden_whiteboard = {
                name = 'Whiteboard',
                text = {
                    "{C:hearts}Hearts{} and {C:diamonds}Diamonds{} give",
                    "{X:mult,C:white}X#1#{} Mult when held in hand"
                }
            },
            j_garden_shootingstar = {
                name = 'Shooting Star',
                text = {
                    "Each scored {C:attention}7{} has a {C:green}#1# in #2#{}",
                    "chance to create a {C:spectral}Black Hole{}",
                    "{C:inactive}(Must have room)"
                }
            }, 
            j_garden_plusfour = {
                name = 'Plus Four',
                text = {
                    "This Joker gains {X:mult,C:white}X#1#{} Mult each",
                    "time a {C:attention}consumable{} card is used",
                    "Resets at the end of each round",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
                }
            },
            j_garden_piggybank = {
                name = 'Piggy Bank',
                text = {
                    "Earn {C:money}$#1#{} for every {C:attention}#2#{} {C:diamonds}Diamonds{}",
                    "in your {C:attention}full deck{} at end of round",
                    "{C:inactive}(Currently {C:money}$#3#{C:inactive})"
                }
            },
            j_garden_candyhearts = {
                name = 'Candy Hearts',
                text = {
                    "Gives {C:mult}+#1#{} Mult for each",
                    "{C:hearts}Heart{} in your {C:attention}full deck{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
                }
            },
            j_garden_darkness = {
                name = 'Darkness',
                text = {
                    "If scoring hand contains at",
                    "least {C:attention}3{} {C:spades}Spades{}, create a",
                    "random {C:dark_edition}Negative{} {C:planet}Planet{} card",
                    "{C:inactive}(Must have room)"
                }
            },
            j_garden_bananasplit = {
                name = 'Banana Split',
                text = {
                    "All cards give {X:mult,C:white}X#1#{} Mult",
                    "{C:green}#2# in #3#{} chance this",
                    "card is destroyed",
                    "at end of round"
                }
            },
            j_garden_plantain = {
                name = 'Plantain',
                text = {
                    "{C:diamonds}Diamonds{} and {C:clubs}Clubs{} give {C:mult}+#1#{} Mult",
                    "when scored, {C:green}#2# in #3#{} chance this",
                    "card is destroyed at end of round"
                }
            },
            j_garden_redbanana = {
                name = 'Red Banana',
                text = {
                    "{C:hearts}Hearts{} and {C:spades}Spades{} give {C:mult}+#1#{} Mult",
                    "when scored, {C:green}#2# in #3#{} chance this",
                    "card is destroyed at end of round"
                }
            },
            j_garden_goldenbanana = {
                name = 'Golden Banana',
                text = {
                    "Earn {C:money}$#1#{} at",
                    "end of round"
                }
            },
            j_garden_mandarin = {
                name = 'Mandarin',
                text = {
                    "{C:chips}+#1#{} Chips",
                    "{C:green}#2# in #3#{} chance this",
                    "card is destroyed",
                    "at end of round"
                }
            },
            j_garden_pomelo = {
                name = 'Pomelo',
                text = {
                    "Gives between {C:chips}+#2#{}",
                    "and {C:chips}+#3#{} Chips",
                    "{C:inactive}(Next hand:{} {C:chips}+#1#{}{C:inactive} Chips){}"
                }
            },
            j_garden_poetryribbon = {
                name = 'Poetry Ribbon',
                text = {
                    "{X:mult,C:white}X#1#{} Mult if scoring",
                    "hand contains at least",
                    "{C:attention}2{} cards with the same",
                    "{C:attention}rank{} and {C:attention}suit{}"
                }
            },
            j_garden_crane = {
                name = 'Crane',
                text = {
                    "Scored cards give {X:mult,C:white}X#1#{} Mult",
                    "if scoring hand contains at",
                    "least {C:attention}2{} other cards with",
                    "their {C:attention}rank{} and {C:attention}suit{}"
                }
            },
            j_garden_octahedron = {
                name = 'Octahedron',
                text = {
                    "This Joker gains {C:mult}+#2#{} Mult for",
                    "each {C:attention}8{} discarded in the",
                    "{C:attention}final discard{} of round",
                    "{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}"
                }
            },
            j_garden_orbit = {
                name = 'Orbit',
                text = {
                    "Gives {C:mult}+#2#{} Mult for every",
                    "{C:attention}level{} on your most played",
                    "{C:attention}poker hand{}",
                    "{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}"
                }
            },
            j_garden_beatupjoker = {
                name = 'Beat-Up Joker',
                text = {
                    "All other Jokers lose {C:money}$#3#{} of",
                    "{C:attention}sell value{} at end of round",
                    "This Joker gains {X:mult,C:white}X#2#{} Mult",
                    "per lost dollar",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
                }
            },
            j_garden_iridescentquartz = {
                name = 'Iridescent Quartz',
                text = {
                    "Played {C:attention}Wild{} cards give",
                    "{C:money}$#1#{}, {C:chips}+#2#{} Chips, {C:mult}+#3#{} Mult,",
                    "or {X:mult,C:white}X#4#{} Mult when scored"
                }
            },
            j_garden_colorcard = {
                name = 'Color Card',
                text = {
                    "Scored {C:attention}Wild{} cards have a",
                    "{C:green}#1# in #2#{} chance to convert the",
                    "rest of the scoring hand",
                    "into their {C:attention}base suit"
                }
            },
            j_garden_recyclablejoker = {
                name = 'Recyclable Joker',
                text = {
                    "Earn {C:money}$#1#{} at end of round",
                    "Payout increases by {C:money}$#2#{}",
                    "every {C:attention}#3# {C:inactive}[#4#]{} cards discarded"
                }
            },
            j_garden_arcadecard = {
                name = 'Arcade Card',
                text = {
                    "This Joker gains {C:chips}+#2#{} Chip",
                    "for every {C:money}dollar{} you have",
                    "at {C:attention}end of shop",
                    "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips){}"
                }
            },
            j_garden_dagonet = {
                name = 'Dagonet',
                text = {
                    "This Joker gains {X:mult,C:white}X#2#{} Mult",
                    "for every {C:money}$#3#{} you have",
                    "at {C:attention}end of shop",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult){}"
                }
            },
            j_garden_stanczyk = {
                name = 'Stańczyk',
                text = {
                    "Using any {C:planet}Planet{} card also levels",
                    "up your most played {C:attention}poker hand{}",
                    "{C:green}#1# in #2#{} chance to level up again"
                }
            },
            j_garden_roland = {
                name = 'Roland',
                text = {
                    "Retrigger all {C:attention}numbered{}",
                    "cards twice"
                }
            },
        }
    },
    misc = {
        dictionary = {
            k_heatingup = "Heating up!",
            k_downgrade = "Downgrade!",
            k_poof = "Poof!",
            k_lucky = "Lucky!",
            k_decriment = "-1",
            k_changed = "Changed!",
            k_updated = "Updated!",
        }
    }
}


