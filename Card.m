classdef Card  % Doesn't work < handle % Handle class so we can update the class instance variables.
    % Card class for modeling a euchre card
    %   Detailed explanation goes here
    
    properties
        suit
        normalsuitrank
        functional % Use this to store information on left and right bower
        value
        CARD_RANKING = {'ace','king','queen','jack','ten','nine'};
        suits = {'spades','clubs','hearts','diamonds'};
    end
    
    methods(Static)
        function color = getColor(suit)
            if (strcmp(suit,'spades')) || (strcmp(suit,'clubs'))
                color = 'black';
            elseif (strcmp(suit,'hearts')) || (strcmp(suit,'diamonds'))
                color = 'red';
            else
                error('Invalid suit');
            end
        end
        
        % Return smallest of a list of cards (cards are sorted from
        % smallest to greatest.
        function sorted_list = getSmallestOfList(card_list,trump_suit)
            sorted = 0;
            len = length(card_list);
            %temp_list = zeros(len-1,1);
            while ~sorted
                ordered_array = zeros(len-1,1);
                for i = 1:(len-1) 
                    tf = card_list(i).isHigherThan(card_list(i+1),trump_suit);
                    if tf  % then we need to switch.
                        ordered_array(i) = 0;
                        temp_list = card_list;
                        temp_list(i) = card_list(i+1);
                        temp_list(i+1) = card_list(i);
                        card_list = temp_list;
                    else
                        ordered_array(i) = 1; % Because we want it to be lower than.
                    end
                end
                
                if sum(ordered_array) == length(ordered_array) % All ones; everything in proper position.
                    sorted = 1;
                end
                
            end
            sorted_list = card_list;
        end
        
        % Return greatest of a list of cards (cards are sorted from
        % greatest to lowest.
        function sorted_list = getGreatestOfList(card_list,trump_suit)
            sorted = 0;
            len = length(card_list);
            %temp_list = zeros(len-1,1);
            while ~sorted
                ordered_array = zeros(len-1,1);
                for i = 1:(len-1) 
                    tf = card_list(i).isHigherThan(card_list(i+1),trump_suit);
                    if tf  % then we need to switch.
                        ordered_array(i) = 1; % Because we want it to be greater than for this function.
                    else
                        ordered_array(i) = 0; 
                        temp_list = card_list;
                        temp_list(i) = card_list(i+1);
                        temp_list(i+1) = card_list(i);
                        card_list = temp_list;
                    end
                end
                
                if sum(ordered_array) == length(ordered_array) % All ones; everything in proper position.
                    sorted = 1;
                end
                
            end
            sorted_list = card_list;
        end
    end
    
    methods
        % Default constructor
%         function obj = Card() 
%            card.suit = 'spades';
%            card.functional = 'none';
%            card.value = 'nine';
%            card.normalsuitrank = obj.getNormalRank();
%         end
        
        % Explicit constructor
        function obj = Card(value,suit)
            obj.suit = suit;
            obj.value = value;
            obj.functional = 'none';
            obj.normalsuitrank = obj.getNormalRank();
        end
        
        % Find if this is a red or black card
        function color = getCardColor(obj)
            color = obj.getColor(obj.suit);
        end
        
        % update functional based on trump
        function obj = updateFunctional(obj,trump_suit)
            if ~strcmp(obj.value,'jack')
                obj.functional = 'none';
            else    % then we have a jack
                if strcmp(obj.suit,trump_suit)
                    obj.functional = 'right_bower';
                else
                    if strcmp(obj.getCardColor(),Card.getColor(trump_suit)) % i.e, we are of the same color
                        obj.functional = 'left_bower';
                    else
                        obj.functional = 'none';
                    end
                end
            end
        end
        
        % get my rank within a normal suit
        function suitrank = getNormalRank(obj)
            suitrank = 0;
            for i = 1:6
                if strcmp(obj.CARD_RANKING{i},obj.value)
                    suitrank = i;
                    return
                end
            end
        end
        
        % rank within trump suit (assumes that this is trump)
        % [NO] Precondition is that the functionals have been assigned.
        function rankout = getTrumpRank(obj,trump_suit)
            rankout = 0;
            obj = obj.updateFunctional(trump_suit);
            if strcmp(obj.functional,'right_bower')
                rankout = 1;
            elseif strcmp(obj.functional,'left_bower')
                rankout = 2;
            else
                for i = [1 2 3 5 6]
                    if strcmp(obj.CARD_RANKING{i},obj.value) 
                        if i < 4
                            rankout = i + 2;
                            return
                        else
                            rankout = i + 1;
                            return
                        end
                    end
                end
            end
        end
        
        % inequality rank within normal suit (comparison to other card)
        function boolout = isHigherWithinSuit(obj,othercard)
            myrank = obj.getNormalRank();
            otherrank = othercard.getNormalRank();
            if myrank < otherrank
                boolout = 1;
            else
                boolout = 0;
            end
        end
        
        % inequality rank within trump (comparison to other card)
        function boolout = isHigherWithinTrump(obj,othercard,trump_suit)
            myrank = obj.getTrumpRank(trump_suit);
            otherrank = othercard.getTrumpRank(trump_suit);
            if myrank < otherrank
                boolout = 1;
            else
                boolout = 0;
            end
        end
        
        % Determine if trump
        function boolout = isTrump(obj,trump_suit)
            if strcmp(trump_suit,obj.suit)
                boolout = 1;
            else % Do have to check and see what the functional is.
                obj = obj.updateFunctional(trump_suit);
                if strcmp(obj.functional,'left_bower') || strcmp(obj.functional,'right_bower')
                    boolout = 1;
                else
                    boolout = 0;
                end
            end
        end
            
        % Card inequality (not overloading because the inequality only
        % makes sense within the context of a trump suit)
        function boolout = isHigherThan(obj,obj2,trump_suit)
            trump1bool = obj.isTrump(trump_suit);
            trump2bool = obj2.isTrump(trump_suit);
            if (trump1bool) && ~(trump2bool)
                boolout = 1;
                return
            elseif ~(trump1bool) && (trump2bool)
                boolout = 0;
                return
            elseif (trump1bool) && (trump2bool)
                % Now we have to do the comparison in trump.
                boolout = obj.isHigherWithinTrump(obj2,trump_suit);
            elseif ~(trump1bool) && ~(trump2bool)
                % Now we have to do the comparison in a normal suit.
                % This ranking is independent of which suit we are in,
                %   which is important for the hand AI.
                boolout = obj.isHigherWithinSuit(obj2);
            end
        end
        
        % Overloaded equality operator.
        % Note that functionals are not a part of the equality check, so we
        % can see if we have the left bower without updating the
        % functionals.
        function tf = eq(a,b)
            if (b == 0)
                tf = 0;
                return
            end
            tf = 1; % Assume true until we find that we fail a criteria.
            c = zeros(3,1);
            c(1) = strcmp(a.suit,b.suit);
            c(2) = (a.normalsuitrank == b.normalsuitrank);
            %c(3) = strcmp(a.functional,b.functional);
            c(3) = strcmp(a.value,b.value);
            if sum(c) < 3
                tf = 0;
            end
        end
        
        % Default interrogation function to see whether or not this card
        % has been played.
        function tf = isDefault(obj)
            c1 = strcmp(obj.value,'Default');
            c2 = strcmp(obj.suit,'Default');
            if c1 || c2 
                tf = 1;
            else
                tf = 0;
            end
        end
    end
end

