classdef CardTester
    % Testing class for the Card class.
    
%     properties
%     end
    
    methods
        function runTests(obj)
            fprintf('Testing class Card...\n');
            fprintf('Testing card orderings...\n');
            obj.testOrderings();
            fprintf('Testing card identifications...\n');
            obj.testIdentifications();
            fprintf('All tests passed!\n');
        end
        
        function testOrderings(obj) 
            obj.testNonTrumpOrderings();
            obj.testTrumpOrderings();
            obj.testMixedOrderings();
            obj.testCardSorting();
        end
        
        function testIdentifications(obj)
            obj.testTrumpIdentification();
            obj.testBowerIdentification();
        end
        
        function testNonTrumpOrderings(obj)
            fprintf('Testing non-trump orderings...\t');
            %Case 1
            trumpsuit = 'clubs';
            card1 = Card('jack','spades');
            card2 = Card('ace','spades');
            card3 = Card('king','spades');
            card4 = Card('queen','spades');
            card5 = Card('ten','spades');
            card6 = Card('nine','spades');
            assert( logical(card4.isHigherThan(card6,trumpsuit)));
            assert( logical(card4.isHigherThan(card5,trumpsuit)));
            % taken out b/c jack of spades is the left. assert( logical(~card4.isHigherThan(card4,trumpsuit)));
            assert( logical(~card4.isHigherThan(card3,trumpsuit)));
            assert( logical(~card4.isHigherThan(card2,trumpsuit)));
            fprintf('1 ');
            %Change trump to hearts, then diamonds, and we expect the same results:
            trumpsuit = 'hearts';
            assert( logical(card1.isHigherThan(card6,trumpsuit)));
            assert( logical(card1.isHigherThan(card5,trumpsuit)));
            assert( logical(~card1.isHigherThan(card4,trumpsuit)));
            assert( logical(~card1.isHigherThan(card3,trumpsuit)));
            assert( logical(~card1.isHigherThan(card2,trumpsuit)));
            fprintf('2 ');
            trumpsuit = 'diamonds';
            assert( logical(card1.isHigherThan(card6,trumpsuit)));
            assert( logical(card1.isHigherThan(card5,trumpsuit)));
            assert( logical(~card1.isHigherThan(card4,trumpsuit)));
            assert( logical(~card1.isHigherThan(card3,trumpsuit)));
            assert( logical(~card1.isHigherThan(card2,trumpsuit)));
            fprintf('3 ');
            
            % Also test orderings between different non-trump suits.
            trumpsuit = 'spades';
            nd = Card('nine','diamonds');
            nc = Card('nine','clubs');
            qh = Card('queen','hearts');
            ks = Card('king','clubs');
            assert( ~logical(nd.isHigherThan(nc,trumpsuit)));
            assert( ~logical(nc.isHigherThan(nd,trumpsuit)));
            assert( logical(qh.isHigherThan(nd,trumpsuit)));
            assert( logical(qh.isHigherThan(nc,trumpsuit)));
            assert( ~logical(nd.isHigherThan(qh,trumpsuit)));
            assert( ~logical(nc.isHigherThan(qh,trumpsuit)));
            assert( logical(ks.isHigherThan(qh,trumpsuit)));
            assert( logical(ks.isHigherThan(nd,trumpsuit)));
            assert( ~logical(qh.isHigherThan(ks,trumpsuit)));
            fprintf('4 Passed!\n');
        end
        
        function testTrumpOrderings(obj)
            fprintf('Testing trump orderings...\t');
            trumpsuit = 'spades';
            card1 = Card('jack','spades');
            card2 = Card('ace','spades');
            card3 = Card('king','spades');
            card4 = Card('queen','spades');
            card5 = Card('ten','spades');
            card6 = Card('nine','spades');
            card7 = Card('jack','clubs');
            assert( logical(card1.isHigherThan(card7,trumpsuit)));
            assert( logical(card1.isHigherThan(card6,trumpsuit)));
            assert( logical(card1.isHigherThan(card5,trumpsuit)));
            assert( logical(card1.isHigherThan(card4,trumpsuit)));
            assert( logical(card1.isHigherThan(card3,trumpsuit)));
            assert( logical(card1.isHigherThan(card2,trumpsuit)));
            fprintf('1 ');
            %Note that the left bower is greater than every card except the
            %right bower.
            assert( ~logical(card7.isHigherThan(card1,trumpsuit)));
            assert( logical(card7.isHigherThan(card6,trumpsuit)));
            assert( logical(card7.isHigherThan(card5,trumpsuit)));
            assert( logical(card7.isHigherThan(card4,trumpsuit)));
            assert( logical(card7.isHigherThan(card3,trumpsuit)));
            assert( logical(card7.isHigherThan(card2,trumpsuit)));
            fprintf('2 ');
            assert( ~logical(card4.isHigherThan(card7,trumpsuit)));
            %Note that card 7 is the left bower.
            assert( logical(card4.isHigherThan(card6,trumpsuit)));
            assert( logical(card4.isHigherThan(card5,trumpsuit)));
            assert( ~logical(card4.isHigherThan(card3,trumpsuit)));
            assert( ~logical(card4.isHigherThan(card2,trumpsuit)));
            assert( ~logical(card4.isHigherThan(card1,trumpsuit)));
            fprintf('3 Passed!\n');
        end
        
        function testMixedOrderings(obj)
            fprintf('Testing mixed-trump orderings...\t');
            %Case 1
            trumpsuit = 'clubs';
            card1 = Card('jack','spades');
            card2 = Card('ace','spades');
            card3 = Card('king','spades');
            card4 = Card('queen','spades');
            card5 = Card('ten','spades');
            card6 = Card('nine','spades');
            right = Card('jack','clubs');
            ace_d = Card('ace','diamonds');
            king_h = Card('king','hearts');
            assert( logical(card1.isHigherThan(card6,trumpsuit)));
            assert( logical(card1.isHigherThan(card5,trumpsuit)));
            assert( logical(card1.isHigherThan(card4,trumpsuit)));
            assert( logical(card1.isHigherThan(card3,trumpsuit)));
            assert( logical(card1.isHigherThan(card2,trumpsuit)));
            assert( ~logical(card1.isHigherThan(right,trumpsuit)));
            assert( logical(card1.isHigherThan(ace_d,trumpsuit)));
            assert( logical(card1.isHigherThan(king_h,trumpsuit)));
            fprintf('1 ');
            trumpsuit = 'hearts';
            king_s = Card('king','spades');
            nine_h = Card('nine','hearts');
            left = Card('jack','diamonds');
            assert( ~logical(king_s.isHigherThan(nine_h,trumpsuit)));
            assert( logical(nine_h.isHigherThan(king_s,trumpsuit)));
            assert( ~logical(king_s.isHigherThan(left,trumpsuit)));
            assert( logical(left.isHigherThan(king_s,trumpsuit)));
            assert( logical(left.isHigherThan(nine_h,trumpsuit)));
            fprintf('2 Passed!\n');
        end
        
        function testTrumpIdentification(obj)
            fprintf('Testing trump identification...\t');
            trumpsuit = 'diamonds';
            ace_d = Card('ace','diamonds');
            queen_s = Card('queen','spades');
            ten_h = Card('ten','hearts');
            left = Card('jack','diamonds');
            right = Card('jack','hearts');
            assert( ~logical(queen_s.isTrump(trumpsuit)));
            assert( ~logical(ten_h.isTrump(trumpsuit)));
            assert( logical(ace_d.isTrump(trumpsuit)));
            assert( logical(left.isTrump(trumpsuit)));
            assert( logical(right.isTrump(trumpsuit)));
            fprintf('Passed!\n');
        end
        
        function testBowerIdentification(obj)
            fprintf('Testing bower identification...\t');
            trumpsuit = 'diamonds';
            ace_d = Card('ace','diamonds');
            queen_s = Card('queen','spades');
            ten_h = Card('ten','hearts');
            left = Card('jack','hearts');
            right = Card('jack','diamonds');
%             for myobj = [ace_d,queen_s,ten_h,left,right]
%                 myobj = myobj.updateFunctional(trumpsuit);
%             end
            ace_d = ace_d.updateFunctional(trumpsuit);
            queen_s = queen_s.updateFunctional(trumpsuit);
            ten_h = ten_h.updateFunctional(trumpsuit);
            left = left.updateFunctional(trumpsuit);
            right = right.updateFunctional(trumpsuit);
            
            assert( strcmp(queen_s.functional,'none'));
            assert( strcmp(ace_d.functional,'none'));
            assert( strcmp(ten_h.functional,'none'));
            assert( strcmp(left.functional,'left_bower'));
            assert( strcmp(right.functional,'right_bower'));
            fprintf('Passed!\n');
        end
        
        function testCardSorting(obj)
            fprintf('Testing Card Sorting ...\t');
            
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
            
            clubs_list = [kc,qc,ac,nc,jc,tc];
            trump_suit = 'diamonds';
            sorted_list = Card.getSmallestOfList(clubs_list,trump_suit);
            assert( logical(sorted_list(6) == ac) );
            assert( logical(sorted_list(5) == kc) );
            assert( logical(sorted_list(4) == qc) );
            assert( logical(sorted_list(3) == jc) );
            assert( logical(sorted_list(2) == tc) );
            assert( logical(sorted_list(1) == nc) );
            fprintf('1 ');
            
            sorted_list2 = Card.getGreatestOfList(clubs_list,trump_suit);
            assert( logical(sorted_list2(1) == ac) );
            assert( logical(sorted_list2(2) == kc) );
            assert( logical(sorted_list2(3) == qc) );
            assert( logical(sorted_list2(4) == jc) );
            assert( logical(sorted_list2(5) == tc) );
            assert( logical(sorted_list2(6) == nc) );
            fprintf('2 ');
            
            mixed_list = [ah,js,qc,nd,td];
            trump_suit = 'clubs';   % This is the sort of thing that you would find in a hand.
            sorted_list = Card.getSmallestOfList(mixed_list,trump_suit);
            assert( logical(sorted_list(5) == js) );
            assert( logical(sorted_list(4) == qc) );
            assert( logical(sorted_list(3) == ah) );
            assert( logical(sorted_list(2) == td) );
            assert( logical(sorted_list(1) == nd) );
            fprintf('3 ');
            
            sorted_list2 = Card.getGreatestOfList(mixed_list,trump_suit);
            assert( logical(sorted_list2(1) == js) );
            assert( logical(sorted_list2(2) == qc) );
            assert( logical(sorted_list2(3) == ah) );
            assert( logical(sorted_list2(4) == td) );
            assert( logical(sorted_list2(5) == nd) );
            fprintf('4 ');
            
            fprintf('Passed!\n');
        end
    end
    
end

