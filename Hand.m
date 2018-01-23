classdef Hand < handle
    % Hand.m
    %   class for modeling the hand that one person has in the game of
    %   euchre.
    properties
        cards  % an array of 5 Card objects
        player_role  % Gives the relationship of the player to the bid.
        %   'bidder' if the person has called the bid.
        %   'bid_partner' if the person is partner to the person who has
        %       called the bid.
        %   'non_bid_partner' if neither partner has called the bid.
        player_position
        unknown_card_locations % Still needs to be done.
        %    This is a cell array, where the first entry is a vertical
        %    array of Cards, and the second entry is 24 x 4 array that
        %    gives probabilities of location. If the card has been played, then
        %    enter NaNs (or also if that card is held in the hand).
        %    The third entry is a 24 x 1 array that gives the probability
        %    of being buried.
        
    end
    
    methods
        % Explicit Constructor:
        function obj = Hand(card_list,player_position)
            if nargin == 2
                obj.player_position = player_position;
            else
                obj.player_position = [];
            end
            try
                assert(length(card_list) == 5);
                obj.cards = card_list;
            catch
                disp('Attempted to create invalid hand.');
            end
            obj.player_role = 'undefined';
            % Construct the full reference array of cards and
            % probabilities:
            ns = Card('nine','spades');
            ts = Card('ten','spades');
            js = Card('jack','spades');
            qs = Card('queen','spades');
            ks = Card('king','spades');
            as = Card('ace','spades');
            nc = Card('nine','clubs');
            tc = Card('ten','clubs');
            jc = Card('jack','clubs');
            qc = Card('queen','clubs');
            kc = Card('king','clubs');
            ac = Card('ace','clubs');
            nd = Card('nine','diamonds');
            td = Card('ten','diamonds');
            jd = Card('jack','diamonds');
            qd = Card('queen','diamonds');
            kd = Card('king','diamonds');
            ad = Card('ace','diamonds');
            nh = Card('nine','hearts');
            th = Card('ten','hearts');
            jh = Card('jack','hearts');
            qh = Card('queen','hearts');
            kh = Card('king','hearts');
            ah = Card('ace','hearts');
            obj.unknown_card_locations = cell(1,2);
            obj.unknown_card_locations{1} = [ns;ts;js;qs;ks;as;nc;tc;jc;qc;kc;ac;nd;td;jd;qd;kd;ad;nh;th;jh;qh;kh;ah];
            obj.unknown_card_locations{2} = nan(24,4);
        end
        
        function boolout = isInHand(obj,card)
            for i = 1:obj.getNumCards()
                if obj.cards(i) == card
                    boolout = 1;
                    return
                end
            end
        end
        
        function [right_bower,left_bower] = getBowers(obj,trump_suit)
            if strcmp(trump_suit,'spades')
                right_bower = Card('jack','spades');
                left_bower = Card('jack','clubs');
            elseif strcmp(trump_suit,'clubs')
                right_bower = Card('jack','clubs');
                left_bower = Card('jack','spades');
            elseif strcmp(trump_suit,'diamonds')
                right_bower = Card('jack','diamonds');
                left_bower = Card('jack','hearts');
            elseif strcmp(trump_suit,'hearts')
                right_bower = Card('jack','hearts');
                left_bower = Card('jack','diamonds');
            else
                error('Invalid trump suit');
            end
        end
        
        % Fill probabilities
        function initializeAllProbabilities(obj,card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down)
            % Start by getting the number of unknown cards
            c1 = (~picked_up); % In which case we know what has been turned down.
            c2 = tf_I_picked_up; % In which case we know what card we buried.
            if  c1 || c2
                num_unknown_buried_cards = 3;
            else
                num_unknown_buried_cards = 4;
            end
            
            
            
            % Which indices are not us?
            nonusidx = 1:4;
            nonusidx(nonusidx == obj.player_position) = [];
            
            for j = 1:24
                card = obj.unknown_card_locations{1}(j);
                eq_logical_array = zeros(1,4);
                for k = 1:5
                    eq_logical_array(k) = (card == obj.cards(k));
                end
                if sum(eq_logical_array) % Then this card is in our hand, otherwise not.
                    obj.unknown_card_locations{2}(j,:) = NaN(1,4); % b/c we have it; equiv of mark as known or played.
                else % Now we want to figure out the probability of any given card being in the hand.
                    num_my_cards = obj.getNumCards(); % Will always yield 5 because this is an intialization.
                    % Not strictly correct for the in-game probability,
                    % because we might be in the middle of a deal.
                    total_num_unknown_cards = num_my_cards*3 + num_unknown_buried_cards;
                    prob = num_my_cards / total_num_unknown_cards; % Equal-likelihood principle
                    obj.setProbability(card,prob,nonusidx);
                    obj.setProbability(card,0,obj.player_position);
                end
            end
            
            if picked_up
                if tf_I_picked_up
                    obj.setProbability(card_I_put_down,0,1:4);
                else
                    obj.setProbability(card_turned_up,1,dealer_pos);
                end
            else % Then the card was turned down, so we know where it is.
                obj.setProbability(card_turned_up,0,1:4);
            end
            %             for card = obj.cards
            %                 obj.markAsKnownOrPlayed(card);
            %             end
            
            
            %                 for j = 1:24
            %                     if card == obj.unknown_card_locations{1}(j)
            %                         obj.unknown_card_locations{2}(j,:) = NaN(1,4);
            %                     elseif card_turned_up == obj.unknown_card_locations{1}(j)
            %                         % Was the card picked up in the bidding? If not,
            %                         % then it is buried; if so, then it is in the
            %                         % dealer's hand. These exhaust the possibilities.
            %                         if picked_up
            %                             if tf_I_picked_up
            %                                 obj.markAsKnownOrPlayed(card_turned_up);
            %                             else
            %                                 obj.setProbability(card_turned_up,1,dealer_pos);
            %                             end
            %
            % %                             obj.unknown_card_locations{2}(j,dealer_pos) = 1;
            % %                             nondidx = [1 2 3 4];
            % %                             nondidx(nondidx == dealer_pos) = [];
            % %                             obj.unknown_card_locations{2}(j,nondidx) = 0;
            %                         elseif ~picked_up
            %                             obj.unknown_card_locations{2}(j,:) = 0;
            %                         else
            %                             error('Invalid information about being picked up');
            %                         end
            %                     else   % These are the cards that we start off with zero information on.
            %                         % For the initialization, there are always a fixed
            %                         % number of cards that we know about based on
            %                         % whether the deal was turned down or not, and
            %                         % based on whether we turned down the deal or not.
            %
            %                     end
            %                 end
        end
        
        % Set probabilities for a card:
        % Note that if we set a probability to 1, this will automatically
        % set all of the others to 0.
        function setProbability(obj,card,prob,hands_pos)
            for i = 1:24
                if obj.unknown_card_locations{1}(i) == card
                    obj.unknown_card_locations{2}(i,hands_pos) = prob;
                    
                    % Now test for the conditions under which we will set
                    % probabilities to zero:
                    if (prob == 1) && (length(hands_pos) == 1)
                        nondidx = [1 2 3 4];
                        nondidx(nondidx == hands_pos) = [];
                        obj.unknown_card_locations{2}(i,nondidx) = 0;
                    end
                    return
                end
            end
        end
        
        % Mark known card with NaNs
        function markAsKnownOrPlayed(obj,card)
            for i = 1:24
                if obj.unknown_card_locations{1}(i) == card
                    obj.unknown_card_locations{2}(i,:) = nan(1,4);
                    return
                end
            end
        end
        
        % Interrogate whether a card is known or played?
        function tf = isKnownOrPlayed(obj,card)
            for i = 1:24
                if obj.unknown_card_locations{1}(i) == card
                    c1 = ( sum(obj.unknown_card_locations{2}(i,:) == 0) == 4);
                    c2 = isnan(obj.unknown_card_locations{2}(i,1)) ; % All should go NaN at the same time.
                    if c1 || c2
                        tf = 1;
                    else
                        tf = 0;
                    end
                    return
                end
            end
        end
        
        % Assign player role after bidding logic has terminated.
        function setRole(obj,role)
            obj.player_role = role;
        end
        
        
        % Support fcn for leading.
        % The card ranking function needs to be general, comparing cards
        % across suits.
        %
        %   This includes trump.
        function [highest_cards,highest_positions] = getHighestCardwithTrump(obj,trump_suit)
            %Going linearly to see which is the highest card; Should be
            %efficient since we are dealing with 4 cards at most.
            cardlist = obj.cards;
            [highest_cards,highest_positions] = obj.factoredGetting(trump_suit,cardlist);
        end
        
        % Support fcn for leading.
        % The card ranking function needs to be general, comparing cards
        % across suits.
        %
        %   This does not include trump.
        function [highest_cards,highest_positions] = getHighestCardwithoutTrump(obj,trump_suit)
            %Going linearly to see which is the highest card; Should be
            %efficient since we are dealing with 4 cards at most.
            new_card_list = [];
            for i = 1:obj.getNumCards()
                this_card = obj.cards(i);
                istrump = this_card.isTrump(trump_suit);
                if ~istrump  % Then this should be added to the list.
                    new_card_list = [new_card_list,(this_card)];
                end
                %If not, don't add card.
            end
            %cardlist = obj.cards;
            [highest_cards,highest_positions] = obj.factoredGetting(trump_suit,new_card_list);
        end
        
        % Factored function for both trump and non-trump getting.
        function [highest_cards,highest_positions] = factoredGetting(obj, trump_suit, cardlist)
            current_highest_card = [];
            num_cards = length(cardlist);
            for i = 1:num_cards
                if isempty (current_highest_card)  % Then this is the first card played.
                    current_highest_card = cardlist(i);
                    current_highest_position = i; % Absolute position.
                else
                    % If other cards have been played, then we need to
                    % figure out whether our card is higher than the
                    % current highest.
                    thiscard = cardlist(i);
                    tf = thiscard.isHigherThan(current_highest_card(1),trump_suit);
                    if tf   % Then we are higher.
                        current_highest_card = cardlist(i);
                        current_highest_position = i; % Absolute position.
                    else    % Check to see if the cards are actually of equal value.
                        tf2 = current_highest_card(1).isHigherThan(thiscard,trump_suit);
                        % Use the first index because of communtativity.
                        if ~tf2  % Then we have equality.
                            current_highest_card = [current_highest_card,(thiscard)];
                            current_highest_position = [current_highest_position,(i)];
                        end
                    end     % Otherwise there is nothing to do; we just have a lower card.
                end
            end
            %             highest_cards = current_highest_card;
            %             highest_positions = current_highest_position;
            highest_positions = [];
            highest_cards = current_highest_card;
            for i = 1:length(highest_cards)
                for j = 1:obj.getNumCards()
                    if obj.cards(j) == highest_cards(i)
                        highest_positions = [highest_positions,(j)];
                    end
                end
            end
            
        end
        
        % Getter fcn
        function num_cards = getNumCards(obj)
            num_cards = length(obj.cards);
        end
        
        % Function to see if a card is in our hand
        function boolout = inHand(obj,card)
            boolout = 0;
            for i = 1:obj.getNumCards()
                if obj.cards(i) == card
                    boolout = 1;
                    return
                end
            end
        end
        
        % Function to count number of trump we have
        function [num_trump,trump_list] = getNumTrump(obj,trump_suit)
            num_trump = 0;
            trump_list = [];
            for i = 1:obj.getNumCards()
                if obj.cards(i).isTrump(trump_suit)
                    num_trump = num_trump + 1;
                    trump_list = [trump_list,obj.cards(i)];
                end
            end
        end
        
        % Function to count the number of a Value we have
        %   Here denom should be 'ace', 'king', etc.
        function [num_value,value_list] = getNumValue(obj,myvalue)
            value_list = [];
            num_value = 0;
            for i = 1:obj.getNumCards()
                if strcmp(obj.cards(i).value,myvalue)
                    num_value = num_value + 1;
                    value_list = [value_list, obj.cards(i)];
                end
            end
        end
        
        % Function to count the number of a suit we have.
        %   Here suit should be 'clubs', 'spades', etc.
        function [num_suit,suit_list] = getNumSuit(obj,mysuit,trump_suit)
            [~,lb] = obj.getBowers(trump_suit);
            
            num_suit = 0;
            suit_list = [];
            for i = 1:obj.getNumCards()
                if strcmp(obj.cards(i).suit,mysuit)
                    % Guard to make sure that we don't accidentally suck up
                    % the left bower somehow:
                    if obj.cards(i) == lb
                        % Then do nothing.
                    else
                        num_suit = num_suit + 1;
                        suit_list = [suit_list, obj.cards(i)];
                    end
                end
            end
        end
        
        % Get trick num based on the number of cards in our hand
        function trick_num = getTrickNum(obj)
            switch obj.getNumCards()
                case 1
                    trick_num = 5;
                case 2
                    trick_num = 4;
                case 3
                    trick_num = 3;
                case 4
                    trick_num = 2;
                case 5
                    trick_num = 1;
            end
        end
        
        % Function to return trump rankings, so we know how high of trump
        % we have. The array is returned in sorted order.
        function trump_rankings = getTrumpRankings(obj,trump_suit)
            trump_rankings = [];
            for card = obj.cards
                if card.isTrump(trump_suit)
                    trump_rankings(end+1) = card.getTrumpRank(trump_suit);
                end
            end
            trump_rankings = sort(trump_rankings);
        end
        
        % Find how many of each suit we have.
        function [spades_num,clubs_num,diamonds_num,hearts_num,spades_list,clubs_list,diamonds_list,hearts_list] = getSuitCounts(obj,trump_suit)
            [spades_num,spades_list] = obj.getNumSuit('spades',trump_suit);
            [clubs_num,clubs_list] = obj.getNumSuit('clubs',trump_suit);
            [diamonds_num,diamonds_list] = obj.getNumSuit('diamonds',trump_suit);
            [hearts_num,hearts_list] = obj.getNumSuit('hearts',trump_suit);
            %             suit_cell{1} = {'spades','clubs','diamonds','hearts'};
%             [num_spades,suit_list] = obj.getNumSuit('spades',trump_suit);
%             suit_cell{2} = {}; % numbers
%             suit_cell{3} = {}; % lists
        end
        
        
        
        
        
        
        % Method to decide what we will play if we do not have a lead
        function [obj,card_chosen] = playLeadCard(obj,trick)
            card_chosen = [];
            % Now apply a list of rules.
            % (A) Do we have the lead?
            card_chosen = obj.chooseLead(trick);
            
            % Take the chosen card, and delete it from our hand, returning
            % the hand.
            for i = 1:obj.getNumCards()
                if obj.cards(i) == card_chosen
                    obj.cards(i) = [];
                    trick.cards_played_list(obj.player_position) = card_chosen;
                    return
                end
            end
            %             return % and obj will be return
        end
        
        % Method to decide what we will play for a card.
        function [obj,card_chosen] = playNonLeadCard(obj,trick)
            card_chosen = [];
            
            % (B) If not lead, do we have suit to follow?
            if isempty(card_chosen)
                card_chosen = obj.followSuit(trick);
            end
            
            % (C) If not, should we trump or throw an off-card?
            if isempty(card_chosen)
                card_chosen = obj.decideOnTrump(trick);
            end
            
            % Take the chosen card, and delete it from our hand, returning
            % the hand.
            for i = 1:obj.getNumCards()
                if obj.cards(i) == card_chosen
                    obj.cards(i) = [];
                    trick.cards_played_list(obj.player_position) = card_chosen;
                    return
                end
            end
            return % and obj will be return
        end
        
        % Decide on choosing a lead
        % As with all of the rules, if we don't have the lead or somehow
        %   the rule can't make a decision, then we return a NaN.
        % Precondition: player role has been assigned and we also know that
        % we have the lead.
        function card_chosen = chooseLead(obj,trick)
            trump_suit = trick.trump_suit;
            [rb,lb] = obj.getBowers(trump_suit);
            if strcmp(obj.player_role,'bidder')
                % There are three big criteria to consider: do we have
                % aces, do we have the right bower (to suck trump), and do
                % we have lower trump to support our left bower?
                
                % Case xx: If we have five trump, lead with the highest one
                % in case others are buried.
                if obj.getNumTrump(trump_suit) == 5
                    [card_chosen,~] = obj.getHighestCardwithTrump(trump_suit);
                    return
                end
                
                % Situation 1: we have the right bower:
                if obj.inHand(rb)
                    
                    % Case 1: if we have both bowers, clearly lead with the
                    % right bower.
                    
                    if obj.inHand(lb)
                        card_chosen = rb;
                        return
                    end
                    
                    % Case 2: if we have the right and at least one other trump
                    % card, then lead with the right if (a) we have an ace, or
                    % (b) it is not the first trick of the game (which we can
                    % easily guage by how many cards we have).
                    if (obj.getNumTrump > 1) && ((obj.getTrickNum ~= 1) || (obj.getNumValue('ace') > 0))
                        card_chosen = rb;
                        return
                    end
                    
                    % Case 3: if we don't have lower trump, lead with our
                    % highest non-suit card. (REFINEMENT: condition this on
                    % probability of going through)
                    if (obj.getNumTrump(trump_suit) == 1) % i.e., the upper bower is all we have
                        [highest_cards,~] = obj.getHighestCardwithoutTrump(trump_suit);
                        if length(highest_cards) > 1  % We can definitely refine this.
                            card_chosen = highest_cards(1);
                        else
                            card_chosen = highest_cards;
                        end
                        return
                    end
                else
                    % Situation 2: we don't have the right bower
                    
                    % Case x (REFINEMENT): if we have four high trump including the left, then we
                    % will likely want to play to see if the right is buried,
                    % in which case we can take all tricks.
                    trump_rankings = obj.getTrumpRankings(trump_suit);
                    if (obj.getNumTrump(trump_suit) > 3) && (trump_rankings(1) == 2) && (trump_rankings(2) == 3)
                        % That is, have both left and the ace.
                        [highest_cards,~] = obj.getHighestCardwithTrump(trump_suit);
                        if length(highest_cards) > 1  % We can definitely refine this.
                            card_chosen = highest_cards(1);
                        else
                            card_chosen = highest_cards;
                        end
                        return
                    else
                        % Case 1: Normal approach is to lead with our highest
                        % off-suit card. (REFINEMENT: condition this on probability
                        % of going through. -- use this as a tiebreak,
                        % nonetheless).
                        %   The hacky approach to estimating probability of going
                        %   through is to sum the probabilities of a card being in
                        %   each hand, and taking the maximum of the minimum values
                        %   as the card to lead.
                        [highest_cards,~] = obj.getHighestCardwithoutTrump(trump_suit);
                        if length(highest_cards) > 1  % We can definitely refine this.
                            card_chosen = highest_cards(1);
                        else
                            card_chosen = highest_cards;
                        end
                    end
                    
                end
            elseif strcmp(obj.player_role,'bid_partner')
                % If we have the right, lead it immediately to let our
                % partner know where it is.
                if obj.inHand(rb)
                    card_chosen = rb;
                    return
                else
                % If not, then we should lead our highest non-trump card.
                % REFINEMENT: discrimnate on which is the better ace to
                % play.
                % REFINEMENT: consider minor issues such as short-suiting
                % ourselves (which is really, really minor here).
                    [highest_cards,~] = obj.getHighestCardwithoutTrump(trump_suit);
                    if length(highest_cards) > 1  % We can definitely refine this.
                            card_chosen = highest_cards(1);
                        else
                            card_chosen = highest_cards;
                        end
                    return
                end
            elseif strcmp(obj.player_role,'non_bid_partner')
                % Under the basic rule set, this is exactly the same as the
                % partner except that we will not lead a right bower. Under
                % refinement, we might change the logic about which card to
                % lead; better to lead good aces/suits rather than ones we
                % have a lot of in the hope that our partner will trump.
                [highest_cards,~] = obj.getHighestCardwithoutTrump(trump_suit);
                    if length(highest_cards) > 1  % We can definitely refine this.
                            card_chosen = highest_cards(1);
                        else
                            card_chosen = highest_cards;
                        end
                    return
            else
                error('Player role not defined.');
            end
        end
        
        % Apply suit-following rules.
        function card_chosen = followSuit(obj,trick)
            % The first question must always be: who is currently taking
            % the trick?
            trump_suit = trick.trump_suit;
            [top_card,player_with_top_card,~] = trick.getTrickInfo();
            [lead_suit,lead_card] = trick.getLeadInfo();
            
            % Do we have suit? Otherwise, empty return, because this won't
            % help us at all.
            %Figure out what I have in this suit:
            [num_suit,suit_list] = obj.getNumSuit(lead_suit,trump_suit);
            if num_suit == 1
                % Then obviously we play the single card in the suit that
                % we have and return.
                card_chosen = suit_list;
                return
            elseif num_suit > 1
                % Now we have more than one card in the suit.
                trumped = hasTrumpBeenPlayed(trick);
                % In the first place, if trump has been played and we must
                % follow suit, then we should always throw our lowest card in
                % the suit.
                sorted_suit_list = Card.getGreatestOfList(suit_list,trick.trump_suit);
                if trumped
                    % Nothing we do will influence the outcome of the
                    % trick.
                    card_chosen = sorted_suit_list(end);
                
                else
                    % The first condition to check is whether we can play a
                    % higher card than that which is currently highest. If
                    % not, then also throw the lowest card.
                    if ~( sorted_suit_list(1).isHigherThan(top_card,trump_suit) )
                        % Here we can't do anything meaningful again.
                        card_chosen = sorted_suit_list(end);
                        
                    else  % Now do some thinking about what the best play is, because
                        % we can go above what is currently being played.
                        if mod(obj.player_position,2) == mod(player_with_top_card,2)
                            % This will always be true if we are taking the trick, and
                            % always false if our team is not taking the trick.
                            
                            % Case 1: Our partner is taking the trick. If we can play a
                            % higher card than our partner, then what position are we?
                            % If we are the last position, then do so if we have an ace and
                            % not otherwise.
                            if obj.player_position == mod((trick.lead + 3),4) 
                                % This signifies that we are the last
                                % player on the trick.
                                [num_aces,aces_list] = obj.getNumValue(myvalue);
                                c1 = (num_aces > 1); % More than one ace is automatic go.
                                c2 = ~( aces_list(1).isTrump(trump_suit) );
                                if c1 || c2 
                                    % Then we take the trick from our
                                    % partner by playing our highest card,
                                    % so we can lead with our ace.
                                    card_chosen = sorted_suit_list(1);
                                else
                                    card_chosen = sorted_suit_list(end);
                                end
                            else
                            % If we are not the last play on the trick, then we should
                            % play the highest card we have in the suit,
                            % because we don't know what will come
                            % afterwards.
                                card_chosen = sorted_suit_list(1);
                            end
                        else
                            % Case 2: The other team is taking the trick.
                            % Now always play the top card, so that after
                            % our play our team will be winning (we already
                            % know thta our top card is better).
                            card_chosen = sorted_suit_list(1);
                        end
                    end
                end
                
            else  % Then we have no cards within the suit, and can do the empty return.
                card_chosen = [];
                return
            end
        end
        
        % Apply trump-based logic; do we want to trump or throw off?
        %   This is the last logic block, so it must always return a
        %   decision.
        function card_chosen = decideOnTrump(obj,trick)
            % Well, do we have trump?
            trump_suit = trick.trump_suit;
            [top_card,player_with_top_card,~] = trick.getTrickInfo();
            [num_trump,trump_list] = getNumTrump(obj,trump_suit);
            sorted_trump_list = Card.getGreatestOfList(trump_list,trick.trump_suit);
            sorted_cards_list = Card.getSmallestOfList(obj.cards,trick.trump_suit);
            if num_trump == 0
                % We have to throw off. For simplicity, let's just throw
                % our lowest card.
                % REFINEMENT: throw cards off based on the probabilities of
                % other cards in the other player's hands. This is one area
                % where the computer can potentially gain a substantial
                % advantage by counting cards.
                card_chosen = sorted_cards_list(1);
            else
                % If we have trump, we have a choice.
                % Case 1: our partner is winning the trick with an ace. Then,
                % throw off with lowest card or with the aim of
                % short-suiting.
                % REFINEMENT: condition this on the probability of the
                % final person trumping to take the trick.
                weare_winning = (mod(obj.player_position,2) == mod(player_with_top_card,2));
                if weare_winning
                    % What is known about the ace?
                    [lead_suit,~] = trick.getLeadInfo();
                    this_ace = Card('ace',lead_suit);
                    ace_not_possible = obj.isKnownOrPlayed(this_ace);
                    if strcmp(top_card.value,'ace') || ace_not_possible
                        % Now decide if we can effectively short-suit
                        % ourselves when we throw off.
                        
                        [spades_num,clubs_num,diamonds_num,hearts_num,spades_list,clubs_list,diamonds_list,hearts_list] = obj.getSuitCounts(trump_suit);
                        % Count the number of suits we have with only one
                        % card:
                        list = [spades_num,clubs_num,diamonds_num,hearts_num];
                        % Remove the trump suit:
                        if strcmp('spades',trump_suit)
                            list(1) = [];
                        elseif strcmp('clubs',trump_suit)
                            list(2) = [];
                        elseif strcmp('diamonds',trump_suit)
                            list(3) = [];
                        elseif strcmp('hearts',trump_suit)
                            list(4) = [];
                        end
                        count = sum(list == 1);
                        if count == 0  % Then we can't short suit ourself no matter what we do, so just throw the lowest card
                            card_chosen = sorted_cards_list(1);
                        elseif (count == 1) && (num_trump > 0)
                            % Then we want to find the suit and short-suit
                            % ourself unless we have a king or higher in
                            % that suit.
                            if (spades_num == 1) && (spades_list(1).normalsuitrank < 2)
                                card_chosen = spades_list(1);
                            elseif (clubs_num == 1) && (clubs_list(1).normalsuitrank < 2)
                                card_chosen = clubs_list(1);
                            elseif (diamonds_num == 1) && (diamonds_list(1).normalsuitrank < 2)
                                card_chosen = diamonds_list(1);
                            elseif (hearts_num == 1) && (hearts_list(1).normalsuitrank < 2)
                                card_chosen = hearts_list(1);
                            else
                                card_chosen = sorted_cards_list(1);
                            end
                        elseif (count == 1) && (num_trump > 0)
                            % We have one or more suits in which we can short-suit ourself.
                            % Now, ascertain the suit with the lowest suit
                            % to short-suit ourselves.
                            short_suits = [];
                            if (spades_num == 1)
                                short_suits = [short_suits, spades_list(1)];
                            end
                            if (clubs_num == 1)
                                short_suits = [short_suits, clubs_list(1)];
                            end
                            if (diamonds_num == 1)
                                short_suits = [short_suits, diamonds_list(1)];
                            end
                            if (hearts_num == 1)
                                short_suits = [short_suits, hearts_list(1)];
                            end
                            short_sorted_list = Card.getSmallestOfList(short_suits,trump_suit);
                            card_chosen = short_sorted_list(1);
                        else  % We have no trump, so we don't really want to short-suit ourself.
                            % Go from the bottom up on lowest cards until
                            % we find one that is not in a suit by
                            % itself.
                            finished = 0;
                            i = 1;
                            while ~finished
                                candidate_suit = sorted_cards_list(i).suit;
                                [can_num,~] = obj.getNumSuit(candidate_suit,trump_suit);
                                if can_num == 1
                                    i = i + 1;
                                else  % We have more than one card in this suit.
                                    card_chosen = sorted_cards_list(i);
                                    finished = 1;
                                end
                            end
                            return
                        end
                        
                    else
                        % Case 2: our partner is winning the trick with a card lower
                        % than an ace, and the ace's location is still unknown.
                        % Then trump, because the chances are high that the
                        % opposition has the ace.
                        % REFINEMENT: there are so many rules you could refine this
                        % with that simulations are probably the best way to go.
                        
                        % Of course, don't trump if our partner has
                        % trumped.
                        if ~top_card.isTrump(trump_suit)
                            % Well, then we should play our lowest trump
                            card_chosen = sorted_trump_list(end);
                        else  % Then play our lowest card.
                            % REFINEMENT: if all we have left is trump,
                            % then there may be situations in which we want
                            % to take the trick with a very high trump to
                            % prevent the next person from doing so.
                            card_chosen = sorted_cards_list(1);
                        end    
                    end
                else
                % Case 3: the opposition is winning the trick. Then trump
                % without hesitation if we can win by doing so. If we have
                % trump but it is lower than their cards, throw off again
                % with lowest card.
                    if ~top_card.isTrump(trump_suit)
                        card_chosen = sorted_trump_list(end);
                    else  % So the opposing team is winning with trump.
                        % Can we beat them?
                        if sorted_trump_list(1).isHigherThan(top_card,trump_suit)
                            % Trump to take the trick. What is the lowest
                            % trump card we can use to do so?
                            %inequality_array = zeros(1,num_trump);
                            for i = 1:num_trump
                                %inequality_array(i) = sorted_trump_list(i).isHigherThan(top_card,trump_suit);
                                if ~ (sorted_trump_list(i).isHigherThan(top_card,trump_suit))
                                    % Then trump with the previous card,
                                    % which should be higher
                                    card_chosen = sorted_trump_list(i-1);
                                    return                                   
                                elseif i == num_trump
                                    % Then we have reached the end of the
                                    % possibilities, and should use that
                                    % card.
                                    card_chosen = sorted_trump_list(1);
                                    return
                                end
                            end
                        else
                            % Throw off
                            card_chosen = sorted_cards_list(end);
                        end
                    end  % logic based on if top card is trump
                end  % logic based on if we are winning.
            end  % logic based on how many trump we have
        end  % end function
        
    end
    
end

