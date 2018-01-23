classdef HandTester
    % Unit-testing class for the Hand.m class
    
    methods
        function runTests(obj)
            fprintf('Testing class Hand.\n');
            obj.testHandBuild();
            fprintf('All Tests Passed!\n');
        end
        
        % Make sure we can build a valid hand
        function testHandBuild(obj)
            fprintf('Testing hand build...\t');
            ad = Card('ace','diamonds');
            qc = Card('queen','clubs');
            js = Card('jack','spades');
            as = Card('ace','spades');
            nd = Card('nine','diamonds');
            cardlist = [ad,qc,js,as,nd];
            try
                myhand = Hand(cardlist);
            catch
                error('Problem when constructing hand.');
            end
            % Quick tests to validate that cards have entered hand
            % correctly.
            assert(logical(strcmpmyhand.cards(1).suit),'diamonds');
            assert(logical(strcmpmyhand.cards(1).value),'ace');
            fprintf('1 Passed!');
        end
        
    end
    
end

