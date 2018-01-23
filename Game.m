classdef Game < handle
    % Game.m
    %   Class for modeling a game of euchre.
    
    properties
        score_1_3  % Score for the team of players from positions 1 and 3.
        score_2_4  % Score for the team of players from positions 2 and 4.
        bid_info_history  % A list of bid_info structs, telling who took the bid and on what information did they take it.
        result_history  % A list of result_info structs, telling which team got the points, how many, and what type of result.
        keep_history  % Boolean toggle for the history; can turn it on and off.
        player_info  % Dictates the rules that each player should follow.
        winning_team
    end
    
    methods
        % In the constructor, we will eventually be able to dictate the set
        % of rules that each player should follow
        function obj = Game()
             
        end
        
        % Play the game out without any human contact.
        function winning_team = playAutomatically(obj)
            
        end
        
        % Play the game with human input for a certain player. Here we will
        % have to enter all of the cards for that hand, etc.
        function winning_team = playManually(obj,our_position)
            
        end
    end
    
end

