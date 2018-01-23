classdef Trick < handle
    % Trick.m
    %   Class for modeling a trick in euchre.
    
    properties
        lead  % Which player position is leading
        trump_suit
        cards_played_list  % Not in order of being played, but rather in absolute order.
        % Use a method that employs lead if we want relative traversal to
        % the lead.
        trick_number
    end
    
    methods
        % Explicit constructor: we need the lead only
        function obj = Trick(lead,trump_suit,trick_number)
            obj.lead = lead;
            obj.trump_suit = trump_suit;
            default_card = Card('Default','Default');
            obj.cards_played_list = [default_card,default_card,default_card,default_card];
            obj.trick_number = trick_number;
%             % Initialize to NaNs
%             for i = 1:4
%                 obj.cards_played_list(i) = NaN(1);
%             end
        end    
        
        % Add card to the trick
        function addCardToTrick(obj,card,position)
            obj.cards_played_list(position) = card;            
        end
        
        % Get person currently winning the trick, and determine if the
        % trick is completed
        function [top_card,player_with_top_card,is_finished] = getTrickInfo(obj)
            num_cards_played = 0;
            %Going linearly to see which is the highest card; Should be
            %efficient since we are dealing with 4 cards at most.
            current_highest_card = Card('Default','Default');
            current_highest_position = NaN(1);
            for i = 1:4
                if ~isDefault(obj.cards_played_list(i))
                    num_cards_played = num_cards_played + 1;
                    if isDefault(current_highest_card)  % Then this is the first card played.
                        current_highest_card = obj.cards_played_list(i);
                        current_highest_position = i; % Absolute position.
                    else 
                        % If other cards have been played, then we need to
                        % figure out whether our card is higher than the
                        % current highest.
                        thiscard = obj.cards_played_list(i);
                        tf = thiscard.isHigherThan(current_highest_card,obj.trump_suit);
                        if tf   % Then we are higher.
                            current_highest_card = obj.cards_played_list(i);
                            current_highest_position = i; % Absolute position.
                        end     % Otherwise there is nothing to do; we just have a lower card.
                    end
                end
            end
            
            player_with_top_card = current_highest_position;
            top_card = current_highest_card;
            if num_cards_played == 4
                is_finished = 1;
            else 
                is_finished = 0;
            end
        end
        
        % Ascertain if someone has trumped the trick already.
        function boolout = hasTrumpBeenPlayed(obj)
            boolout = 0;
            for card = obj.cards_played_list
                if ~(card == 0) % Check to make sure this card position has been played.
                    if card.isTrump(obj.trump_suit)
                        boolout = 1;
                        return
                    end
                end
            end
        end
        
        % Get pertinent information about which card was led
        function [lead_suit,lead_card] = getLeadInfo(obj)
            lead_card = obj.cards_played_list(obj.lead);
            lead_suit = lead_card.suit;
        end
        
        % Play out the trick (card from each of the four hands)
        function revised_hand_cell = play(obj,hand_cell)
            %Build the new hand cell and return, since the handle class
            %thing isn't working out:
            %revised_hand_cell = zeros(4,1);
            %Play out each of the four hands, starting with the lead
            handidxs = zeros(1,4);
            for i = -1:2  % to get the modding to work out with indexing from 1.
                handidxs(i+2) = mod(obj.lead+(i),4)+1;
            end
            idx = handidxs(1);
            %[revised_hand_cell(idx),~] = hand_cell(idx).playLeadCard(obj);
            hand_cell(idx).playLeadCard(obj);  % Handle class; shouldn't need the time-consuming reassignment.
            for idx = handidxs(2:4)
                %idx = mod(obj.lead+i,4);
                %if idx == 1
                    
                %else
                    %[revised_hand_cell(idx),~] = hand_cell(idx).playNonLeadCard(obj);
                    hand_cell(idx).playNonLeadCard(obj);
                %end
            end
        end
        
        % Display trick on the command line in some convenient fashion.
        function print(obj)
            try % Because this table stuff won't work on old versions of Matlab.
                fprintf('Displaying trick %d of 5:\n\n',obj.trick_number);
                [top_card,player_with_top_card,is_finished] = obj.getTrickInfo();
                
                Player_1 = {obj.cards_played_list(1).value;obj.cards_played_list(1).suit};
                Player_2 = {obj.cards_played_list(2).value;obj.cards_played_list(2).suit};
                Player_3 = {obj.cards_played_list(3).value;obj.cards_played_list(3).suit};
                Player_4 = {obj.cards_played_list(4).value;obj.cards_played_list(4).suit};
                mytable = table(Player_1,Player_2,Player_3,Player_4);
                disp(mytable);
                fprintf('Player %d led.\n',obj.lead);
                fprintf('Player %d took the trick with the %s of %s.\n\n',player_with_top_card,top_card.value,top_card.suit);
            catch 
                warning('Matlab version does not support tables; update to support the print method for the Trick class.');
            end
        end
        
        % Get next lead
        function next_lead_position = getNextLead(obj)
            [~,player_with_top_card,is_finished] = getTrickInfo(obj);
            if ~is_finished
                error('Trick must be finished to determine who gets the lead for the next trick.');
            else
                next_lead_position = player_with_top_card;
            end
        end
    end
    
end

