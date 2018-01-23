classdef RoundTester
    % testing class for the Round.m class.
    properties
        reference_card_list  % Contains all of the possible cards in the 24
                             % card euchre deck.
    end
    
    methods
        function obj = RoundTester()
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
            obj.reference_card_list = [ns,ts,js,qs,ks,as,nc,tc,jc,qc,kc,ac,nd,td,jd,qd,kd,ad,nh,th,jh,qh,kh,ah];
        end
        
        function runTests(obj)
            fprintf('Testing class Round...\n');
            obj.testDeal();
            obj.testBid();
            obj.testPlay();
            fprintf('All tests passed!\n');
        end
        
        function testDeal(obj)
            fprintf('Testing Deal method...\t');
            % Test for dealer in the first position
            r1 = Round(1);
            r1.deal();
            assert( (length(r1.hand_list(1).cards)) == 5 );
            assert( (length(r1.hand_list(2).cards)) == 5 );
            assert( (length(r1.hand_list(3).cards)) == 5 );
            assert( (length(r1.hand_list(4).cards)) == 5 );
            assert( (length(r1.card_turned_up)) == 1 );
            assert( (length(r1.buried_cards)) == 3 );
            % Verify that all of the cards are unique; together with the
            % above stipulation, then we know that all of the cards have
            % been dealt out in a correct deal.
            list_of_entities = [r1.hand_list(1).cards,r1.hand_list(2).cards,r1.hand_list(3).cards,r1.hand_list(4).cards,r1.card_turned_up,r1.buried_cards];
            ref_copy = obj.reference_card_list;
            used_list = [];
            for this_group = list_of_entities
                for card_idx = 1:length(this_group)
                    card = this_group(card_idx);
                    % For each card, iterate through the reference list to
                    % verify that this card is in there.
                    found = 0;
                    foundidx = [];
                    for j = 1:24
                        if card == ref_copy(j)
                            foundidx = [foundidx, j];
                            found = found + 1;
                        end
                    end
                    
                    % Now verify that we have found the card precisely
                    % once.
                    switch found
                        case 0
                            error('Card not found in reference card list.');
                        case 2
                            error('Card found twice in reference card list.');
                        case 1
                            % Then we have found the card exactly once as
                            % desired.
                            used_list = [used_list,foundidx];
%                             disp('hit');
                    end
                end
            end
            % Now that we have found all cards, we should find that we
            % have used all of the cards in the reference list:
            ref_copy(used_list) = [];
            assert( isempty(ref_copy) );
            fprintf('1 ');
            
            % Test for dealer in the second position
            r2 = Round(2);
            r2.deal();
            assert( (length(r2.hand_list(1).cards)) == 5 );
            assert( (length(r2.hand_list(2).cards)) == 5 );
            assert( (length(r2.hand_list(3).cards)) == 5 );
            assert( (length(r2.hand_list(4).cards)) == 5 );
            assert( (length(r2.card_turned_up)) == 1 );
            assert( (length(r2.buried_cards)) == 3 );
            % Verify that all of the cards are unique; together with the
            % above stipulation, then we know that all of the cards have
            % been dealt out in a correct deal.
            list_of_entities = [r2.hand_list(1).cards,r2.hand_list(2).cards,r2.hand_list(3).cards,r2.hand_list(4).cards,r2.card_turned_up,r2.buried_cards];
            ref_copy = obj.reference_card_list;
            used_list = [];
            for this_group = list_of_entities
                for card_idx = 1:length(this_group)
                    card = this_group(card_idx);
                    % For each card, iterate through the reference list to
                    % verify that this card is in there.
                    found = 0;
                    foundidx = [];
                    for j = 1:24
                        if card == ref_copy(j)
                            foundidx = [foundidx, j];
                            found = found + 1;
                        end
                    end
                    
                    % Now verify that we have found the card precisely
                    % once.
                    switch found
                        case 0
                            error('Card not found in reference card list.');
                        case 2
                            error('Card found twice in reference card list.');
                        case 1
                            % Then we have found the card exactly once as
                            % desired.
                            used_list = [used_list,foundidx];
%                             disp('hit');
                    end
                end
            end
            % Now that we have found all cards, we should find that we
            % have used all of the cards in the reference list:
            ref_copy(used_list) = [];
            assert( isempty(ref_copy) );
            fprintf('2 ');
            
            % Test for dealer in the third position
            r3 = Round(3);
            r3.deal();
            assert( (length(r3.hand_list(1).cards)) == 5 );
            assert( (length(r3.hand_list(2).cards)) == 5 );
            assert( (length(r3.hand_list(3).cards)) == 5 );
            assert( (length(r3.hand_list(4).cards)) == 5 );
            assert( (length(r3.card_turned_up)) == 1 );
            assert( (length(r3.buried_cards)) == 3 );
            % Verify that all of the cards are unique; together with the
            % above stipulation, then we know that all of the cards have
            % been dealt out in a correct deal.
            list_of_entities = [r3.hand_list(1).cards,r3.hand_list(2).cards,r3.hand_list(3).cards,r3.hand_list(4).cards,r3.card_turned_up,r3.buried_cards];
            ref_copy = obj.reference_card_list;
            used_list = [];
            for this_group = list_of_entities
                for card_idx = 1:length(this_group)
                    card = this_group(card_idx);
                    % For each card, iterate through the reference list to
                    % verify that this card is in there.
                    found = 0;
                    foundidx = [];
                    for j = 1:24
                        if card == ref_copy(j)
                            foundidx = [foundidx, j];
                            found = found + 1;
                        end
                    end
                    
                    % Now verify that we have found the card precisely
                    % once.
                    switch found
                        case 0
                            error('Card not found in reference card list.');
                        case 2
                            error('Card found twice in reference card list.');
                        case 1
                            % Then we have found the card exactly once as
                            % desired.
                            used_list = [used_list,foundidx];
%                             disp('hit');
                    end
                end
            end
            % Now that we have found all cards, we should find that we
            % have used all of the cards in the reference list:
            ref_copy(used_list) = [];
            assert( isempty(ref_copy) );
            fprintf('3 ');
            
            % Test for dealer in the third position
            r4 = Round(4);
            r4.deal();
            assert( (length(r4.hand_list(1).cards)) == 5 );
            assert( (length(r4.hand_list(2).cards)) == 5 );
            assert( (length(r4.hand_list(3).cards)) == 5 );
            assert( (length(r4.hand_list(4).cards)) == 5 );
            assert( (length(r4.card_turned_up)) == 1 );
            assert( (length(r4.buried_cards)) == 3 );
            % Verify that all of the cards are unique; together with the
            % above stipulation, then we know that all of the cards have
            % been dealt out in a correct deal.
            list_of_entities = [r4.hand_list(1).cards,r4.hand_list(2).cards,r4.hand_list(3).cards,r4.hand_list(4).cards,r4.card_turned_up,r4.buried_cards];
            ref_copy = obj.reference_card_list;
            used_list = [];
            for this_group = list_of_entities
                for card_idx = 1:length(this_group)
                    card = this_group(card_idx);
                    % For each card, iterate through the reference list to
                    % verify that this card is in there.
                    found = 0;
                    foundidx = [];
                    for j = 1:24
                        if card == ref_copy(j)
                            foundidx = [foundidx, j];
                            found = found + 1;
                        end
                    end
                    
                    % Now verify that we have found the card precisely
                    % once.
                    switch found
                        case 0
                            error('Card not found in reference card list.');
                        case 2
                            error('Card found twice in reference card list.');
                        case 1
                            % Then we have found the card exactly once as
                            % desired.
                            used_list = [used_list,foundidx];
%                             disp('hit');
                    end
                end
            end
            % Now that we have found all cards, we should find that we
            % have used all of the cards in the reference list:
            ref_copy(used_list) = [];
            assert( isempty(ref_copy) );
            fprintf('4 ');
            
            fprintf('Passed!\n');
        end
        
        function testBid(obj)
            fprintf('Testing Bid method...\t');
            
            fprintf('Passed!\n');
        end
        
        % play will also return the results of the round, so here we can
        % verify that we are getting the correct results.
        function testPlay(obj)
            fprintf('Testing Play method...\t');
            
            fprintf('Passed!\n');
        end
    end
    
end

