classdef TrickTester
    % Testing class for Trick.m
    
    methods
        function runTests(obj)
            
            % Form hand 1
            ts = Card('ten','spades');
            jc = Card('jack','clubs');
            tc = Card('ten','clubs');
            qh = Card('queen','hearts');
            ks = Card('king','spades');
            cardlist = [ts,jc,tc,qh,ks];
            hand1 = Hand(cardlist,1);
            
            % Form hand 2
            ad = Card('ace','diamonds');
            qc = Card('queen','clubs');
            js = Card('jack','spades');
            as = Card('ace','spades');
            nd = Card('nine','diamonds');
            cardlist = [ad,qc,js,as,nd];
            hand2 = Hand(cardlist,2);
            
            % Form hand 3
            nh = Card('nine','hearts');
            ah = Card('ace','hearts');
            td = Card('ten','diamonds');
            nc = Card('nine','clubs');
            jh = Card('jack','hearts');
            cardlist = [nh,ah,td,nc,jh];
            hand3 = Hand(cardlist,3);
            
            % Form hand 4
            qd = Card('queen','diamonds');
            qs = Card('queen','spades');
            kh = Card('king','hearts');
            th = Card('ten','hearts');
            kc = Card('king','clubs');
            cardlist = [qd,qs,kh,th,kc];
            hand4 = Hand(cardlist,4);
            hand_cell = [hand1,hand2,hand3,hand4];
            
            % Test to make sure we can get the highest cards:
            trump_suit = 'clubs';
            [topcard,toppos] = hand1.getHighestCardwithoutTrump(trump_suit);
            assert( logical(topcard == ks) );
            assert( logical(toppos == 5) );
            [topcard,toppos] = hand1.getHighestCardwithTrump(trump_suit);
            assert( logical(topcard == jc) );
            assert( logical(toppos == 2) );
            [topcard,toppos] = hand2.getHighestCardwithoutTrump(trump_suit);
            assert( logical(topcard(1) == ad) );
            assert( logical(toppos(1) == 1) );
            assert( logical(topcard(2) == as) );
            assert( logical(toppos(2) == 4) );
            [topcard,toppos] = hand2.getHighestCardwithTrump(trump_suit);
            assert( logical(topcard == js) );
            assert( logical(toppos == 3) );
            [topcard,toppos] = hand3.getHighestCardwithoutTrump(trump_suit);
            assert( logical(topcard == ah) );
            assert( logical(toppos == 2) );
            [topcard,toppos] = hand3.getHighestCardwithTrump(trump_suit);
            assert( logical(topcard == nc) );
            assert( logical(toppos == 4) );
            [topcard,toppos] = hand4.getHighestCardwithoutTrump(trump_suit);
            assert( logical(topcard == kh) );
            assert( logical(toppos == 3) );
            [topcard,toppos] = hand4.getHighestCardwithTrump(trump_suit);
            assert( logical(topcard == kc) );
            assert( logical(toppos == 5) );
            
            % Now trump is clubs, called by player 2 after player 3 turned down,
            % say, the nine of spades
            ns = Card('nine','spades');
            card_turned_up = ns;
            picked_up = 0;
            dealer_pos = 3;
            tf_I_picked_up = 0; % Does hold for all hands.
            card_I_put_down = nan(1);
            
            hand2.setRole('bidder');
            hand3.setRole('non_bid_partner');
            hand4.setRole('bid_partner');
            hand1.setRole('non_bid_partner');
            
            hand1.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            hand2.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            hand3.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            hand4.initializeAllProbabilities(card_turned_up,picked_up,dealer_pos,tf_I_picked_up,card_I_put_down);
            
            
            % Say that player 3 was the dealer; then player 4 leads.
            lead = 4;
            trump_suit = 'clubs';
            trump_called = 2;
            firsttrick = Trick(lead,trump_suit,1);
            %Play out the first trick
%             hand_cell = firsttrick.play(hand_cell);
            firsttrick.play(hand_cell);
            firsttrick.print();
            newlead = firsttrick.getNextLead();
            secondtrick = Trick(newlead,trump_suit,2);
            secondtrick.play(hand_cell);
            secondtrick.print();
            newlead = secondtrick.getNextLead();
            thirdtrick = Trick(newlead,trump_suit,3);
            thirdtrick.play(hand_cell);
            thirdtrick.print();
            newlead = thirdtrick.getNextLead();
            fourthtrick = Trick(newlead,trump_suit,4);
            fourthtrick.play(hand_cell);
            fourthtrick.print();
            newlead = fourthtrick.getNextLead();
            fifthtrick = Trick(newlead,trump_suit,5);
            fifthtrick.play(hand_cell);
            fifthtrick.print();
%             firsttrick.addCardToTrick(card,position);
            % secondtrick = Trick(lead

        end
    end
    
end

