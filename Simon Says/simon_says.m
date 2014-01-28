%% Simon Says
%
% Carlton Duffett
% 27 January 2014

%{
 A fun and interactive game of Simon Says! Simon will show you a pattern of
 colors. To win, repeat the colors exactly as Simon says. Don't make any
 mistakes!

 Can you beat all 100 levels?

 Questions, comments, concerns?
 Email Carlton Duffett at:
 carlton.duffett@gmail.com

 Any and all feedback is encouraged and appreciated. Enjoy!

 Too easy?
 Increase the value of max_level below to give yourself an even bigger
 challenge!
%}

function simon_says()
%% Initialize GUI

clear
clc

% default colors
background_color = [.1 .1 .1];
button_color = [.7 .7 .7];
red_color = [.7 0 0];
red_highlight = [1 0 0];
green_color = [0 .7 0];
green_highlight = [0 1 0];
blue_color = [0 0 .65];
blue_highlight = [0 .1 1];
yellow_color = [0.7 0.7 0];
yellow_highlight = [1 1 0];
white_color = [.9 .9 .9];

% to highlight these colors, when showing the pattern,
% add .3 to each value

% game constants
game_over = false;
max_out = false;
max_level = 100;
pause_length = 1;
color_pattern = zeros(1,max_level);
user_selection = [];

% encouraging messages for the user
encouragements = {'You got it!','Correct!','Good job!',...
                    'Keep going!','Smart move!','Nice work!',...
                    'Very good!','Almost there!','Way to go!'};
             
L_encouragements = length(encouragements);

% FIGURE WINDOW:
f_simon = figure(...
            'Visible','off',...
            'Units','normalized',...
            'Position',[.35 .3 .3 .55],...
            'MenuBar','none',...
            'ToolBar','none',...
            'Name','Simon Says',...
            'Color',background_color,...
            'CloseRequestFcn',@simon_closeFcn ...
            );
        
clf
movegui('center')

% GAME BOARD:
board_button = zeros(1,4); % (R G B Y)
base_colors = {red_color, green_color, blue_color, yellow_color};
highlight_colors = {red_highlight, green_highlight, blue_highlight, yellow_highlight};

% red button
board_button(1) = uicontrol(...
                        'Visible','off',...
                        'Units','normalized',...
                        'Style','pushbutton',...
                        'Position',[.15 .55 .35 .3],...
                        'Callback',@buttonSelectFcn,...
                        'String','',...
                        'BackgroundColor',base_colors{1}...
                        );
% green button                   
board_button(2) = uicontrol(...
                        'Visible','off',...
                        'Units','normalized',...
                        'Style','pushbutton',...
                        'Position',[.5 .55 .35 .3],...
                        'Callback',@buttonSelectFcn,...
                        'String','',...
                        'BackgroundColor',base_colors{2}...
                        );
                    
% blue button
board_button(3) = uicontrol(...
                        'Visible','off',...
                        'Units','normalized',...
                        'Style','pushbutton',...
                        'Position',[.15 .25 .35 .3],...
                        'Callback',@buttonSelectFcn,...
                        'String','',...
                        'BackgroundColor',base_colors{3}...
                        ); 

% yellow button
board_button(4) = uicontrol(...
                        'Visible','off',...
                        'Units','normalized',...
                        'Style','pushbutton',...
                        'Position',[.5 .25 .35 .3],...
                        'Callback',@buttonSelectFcn,...
                        'String','',...
                        'BackgroundColor',base_colors{4}...
                        );
                    
% GAME BUTTONS:
quit_button = uicontrol(...
                'Visible','off',...
                'Units','normalized',...
                'Style','pushbutton',...
                'Position',[.55 .08 .25 .12],...
                'Callback',@simon_closeFcn,...
                'String','Quit',...
                'FontWeight','bold',...
                'FontSize',14,...
                'BackgroundColor',button_color...
                );

new_button = uicontrol(...
                'Visible','off',...
                'Units','normalized',...
                'Style','pushbutton',...
                'Position',[.2 .08 .25 .12],...
                'Callback',@new_buttonFcn,...
                'String','New Game',...
                'FontWeight','bold',...
                'FontSize',14,...
                'BackgroundColor',button_color...
                );
            
% INFORMATION TEXTBOX:
info_text = uicontrol(...
                'Visible','off',...
                'Units','normalized',...
                'Style','text',...
                'Position',[.2 .85 .6 .1],...
                'String','Simon Says... start a new game?',...
                'FontWeight','bold',...
                'FontSize',16,...
                'BackgroundColor',background_color,...
                'ForegroundColor',white_color...
                );
                
            
% make all visible
set([f_simon board_button quit_button new_button info_text], 'Visible', 'on')



%% Callback Functions

    function simon_closeFcn(~,~)
        
        delete(f_simon);
        
    end

    function new_buttonFcn(~,~)
       
        newGame()
        
    end

    function buttonSelectFcn(source,~)
        
        % get color corresponding to button clicked
        user_selection = find(board_button == source);
        
        % resume code execution
        uiresume(gcbf)
        
    end

%% Game Functions

    function newGame()
        
        % reset game variables
        game_over = false;
        max_out = false;
        level = 3; % 1st level has a pattern of 3 elements
        
        % start of game messages
        message('Let''s play!')
        pause(pause_length)
        
        % MAIN PROGRAM LOOP
        % -----------------------------------------------------------------
        while (~game_over)
            
            % temporarily disable board_buttons
            buttonDisable()
            
            % prompt user
            message(sprintf('Level: %d',level - 2))
            pause(pause_length)
        
            % countdown
            countDown()
            
            % show pattern
            message('Simon says...')
            pause(pause_length)
            showPattern(level)
            
            % prompt user to repeat pattern
            message('Your turn!')
            
            % re-enable board_buttons
            buttonEnable()
            
            % check for win after each click
            for k = 1:level
               
                % wait for user selection
                uiwait(gcf)
                
                % evaluate user's selection
                result = evalWin(k);
                
                if ~result
                    % user made the wrong selection
                    game_over = true;
                    
                    % exit main program loop
                    break
                end
                
            end
            
            if (game_over)
                % exit main program loop
                break
            else
                
                % congratulate user
                message('You got the pattern!')
                pause(pause_length)
                
                % increment level
                level = level + 1;
                
                % check that user has not maxed-out the game
                if (level > max_level)
                    max_out = true;
                    
                    % end the game
                    break
                end
            end
            
        end
        % -----------------------------------------------------------------
        % END MAIN PROGRAM LOOP
        
        % end of game routine
        gameOver()
    
    end

    function [bool] = evalWin(event_no)
        
        % compare user's color selection to expected selection
        if (user_selection ~= color_pattern(event_no))

            % user made an invalid selection
            bool = false;
        else
            
            % print a message of encouragement
            encourage()
            bool = true;
        end
        
    end

    function gameOver()
        
        % disable user buttons
        buttonDisable()
        
        if (max_out)
            
            % user maxed-out the game
            message('Congratulations!')
            pause(pause_length)
            message('You beat Simon!')
        else
            
            % gameOver message
            message('Sorry... that''s not right!')
            pause(pause_length)
            message('Game over!')
            pause(pause_length)
            message('Simon says... Play again?')          
        end
        
    end

    function showPattern(pattern_length)
        
        % randomize the color pattern and show it to the user
        color_pattern(1:pattern_length) = randi([1,4],1,pattern_length);
        
        for j = 1:pattern_length
            
            % get current button handle
            han = board_button(color_pattern(j));
            
            % highlight button
            set(han,'BackgroundColor',highlight_colors{color_pattern(j)})
            pause(pause_length - .25)
            
            % reset button color
            set(han,'BackgroundColor',base_colors{color_pattern(j)})
            pause(pause_length - .25)
            
        end
        
    end

    function buttonDisable()
       
        % temporarily disable board_buttons from user selection
        for j = 1:4
            set(board_button(j),'Enable', 'off')
        end
        
    end

    function buttonEnable()
        
        % temporarily disable board_buttons from user selection
        for j = 1:4
            set(board_button(j),'Enable', 'on')
        end
        
    end

%% Information Message Functions


    function message(msg_string)
       
        % update message in the information textbox
        set(info_text,'string',msg_string)
        
    end

    function encourage()
        
        % randomize encouragement
        selection = randi([1,L_encouragements]);
        
        % encourage the user when they get a right answer!        
        message(encouragements{selection});
        
    end

    function countDown()
        
        message('Ready?')
        pause(pause_length)
        message('3')
        pause(pause_length)
        message('2')
        pause(pause_length)
        message('1')
        pause(pause_length)
        
    end

end