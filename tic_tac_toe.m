function tic_tac_toe()
%% Tic Tac Toe
% :
% __________________________
% ONE PLAYER
% : 
% Computer and Player take turns making moves on the board.  Winner is
% first player to get three in a row vertically, horizontally,
% or diagonally.
% :
% Potential Winning Moves Include:
%   X - O       X X X       X O -
%   X O -       O O X       O X O           X - Winning Player
%   X O -       O - -       O - X           O - Opposing Player
% __________________________
% TWO PLAYER
% :
% Player 1 and Player 2 take turns making moves on the board. Winner is
% first player to get three in a row vertically, horizontally,
% or diagonally.
%___________________________
% INFORMATION
% :
% Written By:   Carlton Duffett
% Contact:      cduffett@bu.edu
% :
% v.1.0 -- 25 March 2013

%% Object Handles

% figure_h              -- main window
% gbButtons_h()         -- game board pushbuttons (1 to 9)
% mnuButtons_h()        -- menu buttons (1 to 5)
% info_h                -- user information box below board 
% scoretxt_h            -- title of score information boxes
% titletxt_h()          -- titles of player 1/player 2 score boxes (1 to 2)
% highscoretxt_h        -- title of high score box
% scores_h()            -- score boxes (1 to 3)

%% Game Variables

% isgame - identifies state of current game
% :
% values:
% 0 - game over
% 1 - active game

% gametype - identifies current game mode
% :
% values:
% 1 - one-player
% 2 - two-player

% firstturn - alternates first move in a new game
% :
% 1 - player 1 turn
% 0 - player 2 turn/computer turn

% playerturn - alternates in-game player turn
% :
% values:
% 1 - player 1 turn
% 0 - player 2 turn/computer turn

% isxo - tracks usage of the game board
% :
% values:
% 0 - none (space has not been played)
% 1 - X
% 2 - O

% winner - identifies the winner of each game
% :
% values:
% 0 - no winner assigned
% 1 - player 1 is winner
% 2 - player 2 is winner
% 3 - tie

% potmove
% :
% stores index of computer's next move

%% Create Game Board

%___________________________
% clear variables and command window

clear
clc

%================================================
% create figure window
%================================================

figure_h = figure(...
    'Visible','off',...
    'Units','normalized',...
    'Position',[0.25 0.25 0.5 0.5],...
    'Name','Tic_Tac_Toe',...
    'MenuBar','none',...
    'Color',[0.8 0.8 0.8]...
    );

%___________________________
% clear figure window

clf

%================================================
% create game board
%================================================

%___________________________
% Button format:
% :                                                      Board:
% [pushbutton][pushbutton][pushbutton] -- row 1        [1][2][3]
% [pushbutton][pushbutton][pushbutton] -- row 2        [4][5][6]
% [pushbutton][pushbutton][pushbutton] -- row 3        [7][8][9]
%   "   "       "   "       "   "
%   col 1       col 2       col 3

%___________________________
% preallocate button handles

gbButtons_h = ones(1,9);

%___________________________
% create buttons

index = 1;

for ii = 1:3
    
    for jj = 1:3
        gbButtons_h(index) = uicontrol(figure_h,...
            'Parent',figure_h,...
            'Visible','off',...
            'Style','pushbutton',...
            'Units','normalized',...
            'Position',[(.15*jj + .33) (.9 - .22*ii) 0.15 0.22],...
            'String','',...
            'BackgroundColor',[0.9 0.9 0.9],...
            'FontSize',40 ...
            );
        index = index + 1;
    end
    
end

%================================================
% create menu buttons
%================================================

% Buttons created:
% 1 - One-Player
% 2 - Two-Player
% 3 - Options
% 4 - New Game
% 5 - Exit

%__________________________
% preallocate button handle matrix

mnuButtons_h = ones(1,3);

%__________________________
% preallocate button strings

mnuStrings = {'One-Player','Two-Player','New Game','Exit'};

%__________________________
% create buttons

for ii = 1:4
    
    switch ii
        
        % One-Player, Two-Player buttons
        case {1,2}
            mnuButtons_h(ii) = uicontrol(figure_h,...
                'Parent',figure_h,...
                'Visible','off',...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[.05 (.95 - .1*ii) 0.2 0.075],...
                'String',mnuStrings(ii),...
                'BackgroundColor',[0.9 0.9 0.9],...
                'FontSize',12 ...
                );
            
        % Options, New Game, Exit buttons
        case {3,4}
            mnuButtons_h(ii) = uicontrol(figure_h,...
                'Parent',figure_h,...
                'Visible','off',...
                'Style','pushbutton',...
                'Units','normalized',...
                'Position',[.05 (.45 - .1*ii) 0.2 0.075],...
                'String',mnuStrings(ii),...
                'BackgroundColor',[0.9 0.9 0.9],...
                'FontSize',11 ...
                );
    end
    
end

%__________________________
% set callback functions

for ii = 1:9
    set(gbButtons_h(ii),...
            'Callback',@gamebuttonfn...
            );
end
set(mnuButtons_h(1),...
        'Callback',@oneplayerfn...
        );
set(mnuButtons_h(2),...
        'Callback',@twoplayerfn...
        );
set(mnuButtons_h(3),...
        'Callback',@newgamefn...
        );
set(mnuButtons_h(4),...
        'Callback',@exitfn...
        );

%================================================
% create text objects
%================================================

% Textboxes Created:
% 1 - User Information Box
% 2 - Score Title
% 3 - Player 1 Score
% 4 - Player 2/Computer Score
% 5 - High Score

%___________________________
% create user information text box

info_h = uicontrol(figure_h,...
            'Parent',figure_h,...
            'Visible','off',...
            'Style','text',...
            'Units','normalized',...
            'Position',[0.51 0.05 0.4 0.15],...
            'String','',...
            'BackgroundColor',[0.8 0.8 0.8],...
            'FontSize',15 ...
            );

%___________________________
% create score title text boxes

scoretxt_h = uicontrol(figure_h,...
                    'Parent',figure_h,...
                    'Visible','off',...
                    'Style','text',...
                    'Units','normalized',...
                    'Position',[0.18 0.65 0.1 0.05],...
                    'String','Scores:',...
                    'BackgroundColor',[0.8 0.8 0.8],...
                    'FontSize',12 ...
                    );


% preallocate text box strings and colors
textstrings = {'Player 1','Player 2'};

% preallocate handles
titletxt_h = zeros(1,2);

% create player score title text boxes
for ii = 1:2
    titletxt_h(ii) = uicontrol(figure_h,...
                    'Parent',figure_h,...
                    'Visible','off',...
                    'Style','text',...
                    'Units','normalized',...
                    'Position',[(0.12 + 0.14*(ii - 1)) 0.5 0.1 0.1],...
                    'String',textstrings(ii),...
                    'BackgroundColor',[0.8 0.8 0.8],...
                    'FontSize',12 ...
                    );
end

%___________________________
% create score text boxes

% preallocate text box handles

scores_h = zeros(1,2);

% create text boxes

for ii = 1:2

    scores_h(ii) = uicontrol(figure_h,...
                    'Parent',figure_h,...
                    'Visible','off',...
                    'Style','text',...
                    'Units','normalized',...
                    'Position',[(0.12 + 0.14*(ii - 1)) 0.35 0.1 0.15],...
                    'String','X',...
                    'BackgroundColor',[0.9 0.9 0.9],...
                    'FontSize',25 ...
                    );
end

%___________________________
% make all objects visible

set(figure_h,...
        'Visible','on'...
        );
set(gbButtons_h,...
        'Visible','on'...
        );
set(mnuButtons_h,...
        'Visible','on'...
        );
set(info_h,...
        'Visible','on'...
        );        
set(scoretxt_h,...
        'Visible','on'...
        );
set(titletxt_h,...
        'Visible','on'...
        );
set(scores_h,...
        'Visible','on'...
        );

%% Initialize Game

%___________________________
% initialize game variables

firstplayer = 1;
playerturn = 1;
isgame = 0;
gametype = 1;
winner = 0;
isxo = zeros(1,9);
p1score = 0;
p2score = 0;
    
%___________________________
% inform player

% set user information string

set(info_h,...
        'String','Click ''New Game'' to play'...
        );
    
%___________________________
% initialize scores

set(scores_h(1:2),...
        'String','0'...
        );

%% Computer Strategy Function
function [move] = computerfn()
    
    % evaluate game board
    
    % if computer can make a winning move
    
    potmove = [];
    
    % row check
    for nn = [1 4 7]

        % nn-th row
        if sum(isxo(nn:(nn + 2)) == 2) > 1 && ...
                ~all(isxo(nn:(nn + 2)) ~= 0)
            % find unoccupied space for computer to play
            opt = find(isxo(nn:(nn + 2)) == 0);
            if ~isempty(opt)
                switch opt
                    case 1
                        potmove = nn;
                    case 2
                        potmove = nn + 1;
                    case 3
                        potmove = nn + 2;
                end
            end
        end
    end

    % column check
    for mm = 1:3

        % mm-th column
        if sum(isxo(mm:3:(mm + 6)) == 2) > 1 && ...
                ~all(isxo(mm:(mm + 6)) ~= 0)
            % find unoccupied space for computer to play
            opt = find(isxo(mm:3:(mm + 6)) == 0);
            if ~isempty(opt)
                switch opt
                    case 1
                        potmove = mm;
                    case 2
                        potmove = mm + 3;
                    case 3
                        potmove = mm + 6;
                end
            end
        end

    end

    % diagonal check

    % top-left to botton-right
    if sum(isxo(1:4:9) == 2) > 1 && ~all(isxo(1:4:9) ~= 0)
        % find unoccupied space for computer to play
        opt = find(isxo(1:4:9) == 0);
        if ~isempty(opt)
            switch opt
                case 1
                    potmove = 1;
                case 2
                    potmove = 5;
                case 3
                    potmove = 9;
            end
        end
    end

    % bottom-left to top-right
    if sum(isxo(3:2:7) == 2) > 1 && ~all(isxo(3:2:7) ~= 0)
        % find unoccupied space for computer to play
        opt = find(isxo(3:2:7) == 0);
        if ~isempty(opt)
            switch opt
                case 1
                    potmove = 3;
                case 2
                    potmove = 5;
                case 3
                    potmove = 7;
            end
        end
    end
        
    if ~isempty(potmove)
        move = potmove; %#ok
    else 

        
    % if computer cannot make winning move,
    % make DEFENSIVE MOVE
    
        % row check
        for nn = [1 4 7]

            % nn-th row
            if sum(isxo(nn:(nn + 2)) == 1) > 1 && ...
                    ~all(isxo(nn:(nn + 2)) ~= 0)
                % find unoccupied space for computer to play
                opt = find(isxo(nn:(nn + 2)) == 0);
                if ~isempty(opt)
                    switch opt
                        case 1
                            potmove = nn;
                        case 2
                            potmove = nn + 1;
                        case 3
                            potmove = nn + 2;
                    end
                end
            end
        end

        % column check
        for mm = 1:3

            % mm-th column
            if sum(isxo(mm:3:(mm + 6)) == 1) > 1 && ...
                    ~all(isxo(mm:(mm + 6)) ~= 0)
                % find unoccupied space for computer to play
                opt = find(isxo(mm:3:(mm + 6)) == 0);
                if ~isempty(opt)
                    switch opt
                        case 1
                            potmove = mm;
                        case 2
                            potmove = mm + 3;
                        case 3
                            potmove = mm + 6;
                    end
                end
            end

        end

        % diagonal check

        % top-left to botton-right
        if sum(isxo(1:4:9) == 1) > 1 && ~all(isxo(1:4:9) ~= 0)
            % find unoccupied space for computer to play
            opt = find(isxo(1:4:9) == 0);
            if ~isempty(opt)
                switch opt
                    case 1
                        potmove = 1;
                    case 2
                        potmove = 5;
                    case 3
                        potmove = 9;
                end
            end
        end

        % bottom-left to top-right
        if sum(isxo(3:2:7) == 1) > 1 && ~all(isxo(3:2:7) ~= 0)
            % find unoccupied space for computer to play
            opt = find(isxo(3:2:7) == 0);
            if ~isempty(opt)
                switch opt
                    case 1
                        potmove = 3;
                    case 2
                        potmove = 5;
                    case 3
                        potmove = 7;
                end
            end
        end
    end
    % if more than one defensive move is possible,
    % precedence does not matter. Order of above
    % checks determines the move. (Row, then Col., then Diag.)
    
    if ~isempty(potmove)
        move = potmove;
    else
        % if no offensive or defense move is necessary (first move)
        % make random move
        ranmove = find(isxo == 0);
        move = ranmove(randi([1,length(ranmove)]));
    end
    
end

%% Game Won Function
function checkwinfn()
    
    % initialize variables
    gameover = 0;
    winner = 0;
    
    % check rows for win
    for nn = [1 4 7]
        if all(isxo(nn:(nn + 2)) == 1)
            winner = 1;
            gameover = 1;
        elseif all(isxo(nn:(nn + 2)) == 2)
            winner = 2;
            gameover = 1;
        end
    end
    
    % check columns for win
    for mm = 1:3
        if all(isxo(mm:3:(mm + 6)) == 1)
            winner = 1;
            gameover = 1;
        elseif all(isxo(mm:3:(mm + 6)) == 2)
            winner = 2;
            gameover = 1;
        end
    end
    
    % check diagonals for win
    if all(isxo(1:4:9) == 1)        % top-left to botton-right diag.
        winner = 1;
        gameover = 1;
    elseif all(isxo(1:4:9) == 2)
        winner = 2;
        gameover = 1;
    elseif all(isxo(3:2:7) == 1)    % bottom-left to top-right diag.
        winner = 1;
        gameover = 1;
    elseif all(isxo(3:2:7) == 2)
        winner = 1;
        gameover = 1;
    end
    
    % check if all board tiles are filled up
    if all(isxo(1,:)) && ~winner
        winner = 3;
        gameover = 1;
    end
    
    if gameover
        isgame = 0;
        
        % update scores
        switch winner
            case 1
                p1score = p1score + 1;
                set(scores_h(1),...
                    'String',num2str(p1score)...
                    );
            case 2
                p2score = p2score + 1;
                set(scores_h(2),...
                    'String',num2str(p2score)...
                    );
        end
        promptplayerfn()
    end
    
end

%% Prompt Player Function
function promptplayerfn()
    
    %__________________________
    % change information string
    switch gametype
    
    % one-player game
    case 1
        switch playerturn
            
            % user's turn
            case 1
               set(info_h,...
                    'String', sprintf('Player 1''s move')...
                    );
            
            % computer's turn
            case 0
                
                set(info_h,...
                    'String', sprintf('Computer''s move')...
                    );
            
        end
    
    % two-player game
    case 2
        set(info_h,...
            'String', sprintf('Player %d''s move',(~playerturn + 1))...
            );
    end
     
    % no game
    if ~isgame
        switch winner
            case 1
                set(info_h,...
                    'String','Player 1 wins! Click ''New Game'' to play again!'...
                    );
                
            case 2
                if gametype == 1
                    set(info_h,...
                    'String','Computer wins! Click ''New Game'' to play again!'...
                    );
                elseif gametype == 2
                    set(info_h,...
                    'String','Player 2 wins! Click ''New Game'' to play again!'...
                    );
                end
                
            case 3
                    
                set(info_h,...
                    'String','It''s a Tie! Click ''New Game'' to play again!'...
                    );
        end
                
    end
            
end

%% Callback Functions

% Game Board callback function
function gamebuttonfn(source,~)
    
    % identify clicked button
    clickindex = find(gbButtons_h == source);
    
    % check that is active game and that button has not been clicked yet
    if isgame && ~isxo(clickindex)
        
        % check game mode
        switch gametype
            
            % one-player
            case 1
                    set(source,...
                        'String','X'...
                        );
                    isxo(clickindex) = 1;
                    
                    % evaluate player win to prevent computer from
                    % making impossible move
                    checkwinfn()
                    
                    % alternate player
                    playerturn = ~playerturn;
                    promptplayerfn()
                    
                    % if game is not won and computer turn
                    if isgame
                    
                        pause(1)    % pause for effect

                        move = computerfn();
                        isxo(move) = 2;
                        set(gbButtons_h(move),...
                            'String','O'...
                            );

                        % alternate player
                        playerturn = ~playerturn;
                        promptplayerfn()
                        
                        % check for win
                        checkwinfn()
                        
                    end
            % two-player
            case 2
                
                if playerturn == 1
                    set(source,...
                        'String','X'...
                        );
                    isxo(clickindex) = 1;
                else
                    set(source,...
                        'String','O'...
                        );
                    isxo(clickindex) = 2;
                end
                
                % alternate player
                playerturn = ~playerturn;
                promptplayerfn()
                
                % check for win
                checkwinfn()
                
        end
          
    end

end
    
% One-player callback function
function oneplayerfn(~,~)
    
    %__________________________
    % set game mode to one-player
    
    gametype = 1;
    
    %__________________________
    % reset scores
    
    p1score = 0;
    p2score = 0;
    
    %__________________________
    % update score strings
    
    set(scores_h(1),...
        'String',num2str(p1score)...
        );
    set(scores_h(2),...
        'String',num2str(p2score)...
        );
    
    %__________________________
    % start a new game
    
    newgamefn()

end

% Two-player callback function
function twoplayerfn(~,~)
    
    %__________________________
    % set game mode to two-player
    
    gametype = 2;
    
    %__________________________
    % reset scores
    
    p1score = 0;
    p2score = 0;
     
    %__________________________
    % update score strings
    
    set(scores_h(1),...
        'String',num2str(p1score)...
        );
    set(scores_h(2),...
        'String',num2str(p2score)...
        );
    
    %__________________________
    % start a new game
    
    newgamefn()

end

% New Game callback function 
function newgamefn(~,~)
    
    %___________________________
    % clear game board
    
    for kk = 1:9
    set(gbButtons_h(kk),...
        'String',''...
        );
    end
    
    %___________________________
    % reset game variables
    
    isxo(:,:) = 0;
    isgame = 1;
    
    %___________________________
    % alternate first player
    firstplayer = ~firstplayer;
    playerturn = firstplayer;
    
    %___________________________
    % prompt player
    
    promptplayerfn()
    
    %___________________________
    % one-player computer first move
    
    if gametype == 1 && ~playerturn
        
        pause(1)    % pause for effect
                    
        move = computerfn();
        isxo(move) = 2;
        set(gbButtons_h(move),...
            'String','O'...
            );
        
        % alternate player
        playerturn = ~playerturn;
        promptplayerfn()
        
    end

end

% Exit callback function
function exitfn(~,~)
    
   % delete figure window
   delete(figure_h)

end

end % end of GUI