classdef Round < handle
    % Round.m
    %   Class for modeling a round, with one bid and one outcome.
    
    properties
        bid_info
        trick_list
        hand_list
        card_turned_up
        dealer_pos
        buried_cards
    end
    
    methods(Static)
        function [all_cards,card_cell] = dealCard(card_cell,all_cards)
            num = length(all_cards);
            idx = randi(num);
            card_chosen = all_cards(idx);
            all_cards(idx) = [];
            card_cell = [card_cell,card_chosen];
        end
    end
    
    methods
        % Default constructor
        function obj = Round(dealer_pos)
            obj.bid_info = [];
            obj.trick_list = [];
            obj.hand_list = [];
            obj.card_turned_up = [];
            obj.buried_cards = [];
            obj.dealer_pos = dealer_pos;
        end
        
        % Deal out the hands; see what is turned up.
        function deal(obj)
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
            
            all_cards = [ns,ts,js,qs,ks,as,nc,tc,jc,qc,kc,ac,nd,td,jd,qd,kd,ad,nh,th,jh,qh,kh,ah];
            card_cell = [];
            for i = 1:5
                for j = 1:4
                    if i == 1
                        [all_cards,card_cell{j}] = Round.dealCard([Card('Default','Default')],all_cards);
                        card_cell{j}(1) = [];
                    else
                        [all_cards,card_cell{j}] = Round.dealCard(card_cell{j},all_cards);
                    end
                end
            end
            
            % What remains in all_cards should be the four that are buried.
            % But the first one is turned up.
            obj.buried_cards = all_cards(2:4);
            hand1 = Hand(card_cell{1},1);
            hand2 = Hand(card_cell{2},2);
            hand3 = Hand(card_cell{3},3);
            hand4 = Hand(card_cell{4},4);
            
            obj.card_turned_up = all_cards(1);
            obj.hand_list = [hand1,hand2,hand3,hand4];
            
        end
        
        % Bidding
        function bid(obj)
            % Have each hand submit bid decisions.
            
            % At the end of bidding, can initialize probabilities.
            hand1.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            hand2.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            hand3.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            hand4.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
        end
        
        % Play out the round
        function results = play(obj)
            for i = 1:5
                trick_list(i) = Trick(lead,trump_suit,1);
                firsttrick.play(hand_cell);
                
            end
        end
    end
    
end

