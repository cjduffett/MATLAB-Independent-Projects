%% Slider Puzzle

% Carlton Duffett
% 22 November 2013
% carlton.duffett@gmail.com

%% main GUI

function slider_puzzle()
%% Initialize GUI

clear
clc

% default colors
background_color = [.85 .85 .95];
slider_color = [.9 .9 .9];
empty_color = [.7 .7 .7];

% figure window
f_slider = figure(...
            'Visible','off',...
            'Units','normalized',...
            'Position',[.35 .3 .3 .55],...
            'MenuBar','none',...
            'ToolBar','none',...
            'Name','Slider',...
            'Color',background_color,...
            'CloseRequestFcn',@slider_closeFcn ...
            );
        
clf
movegui('center')
        
% game board objects (4 x 4 grid)
slider_buttons = zeros(1,16);
count = 1;

for i = 1:4
    
    for j = 1:4
        
        slider_buttons(count) = uicontrol(...
                                    'Visible','off',...
                                    'Units','normalized',...
                                    'Parent',f_slider,...
                                    'Style','pushbutton',...
                                    'Position',[(-.1 + .2*j) (.95 - .17*i) .2 .17],...
                                    'BackgroundColor',slider_color,...
                                    'ForegroundColor','k',...
                                    'FontSize',16,...
                                    'FontWeight','bold',...
                                    'String',num2str(count),...
                                    'Callback',@slider_buttonFcn ...
                                    );
        count = count + 1;
        
    end
    
end

% set slider 16 to grey, string to '' <--- (empty space)
set(slider_buttons(16),'BackgroundColor', empty_color,...
                        'String','')

% option buttons:

% reset button
slider_reset = uicontrol(...
                    'Visible','off',...
                    'Units','normalized',...
                    'Parent',f_slider,...
                    'Style','pushbutton',...
                    'Position',[.2 .1 .2 .1],...
                    'BackgroundColor',slider_color,...
                    'ForegroundColor','k',...
                    'FontSize',12,...
                    'FontWeight','bold',...
                    'String','Reset',...
                    'Callback',@slider_resetFcn ...
                    );
                
% quit button
slider_quit = uicontrol(...
                    'Visible','off',...
                    'Units','normalized',...
                    'Parent',f_slider,...
                    'Style','pushbutton',...
                    'Position',[.6 .1 .2 .1],...
                    'BackgroundColor',slider_color,...
                    'ForegroundColor','k',...
                    'FontSize',12,...
                    'FontWeight','bold',...
                    'String','Quit',...
                    'Callback',@slider_closeFcn ...
                    );


% make all visible
set([f_slider slider_buttons slider_reset slider_quit],'Visible','on')


%% Callback Functions

    % close the program
    function slider_closeFcn(~,~)

        delete(f_slider)
    end


    % move button that was clicked, evaluate game state
    function slider_buttonFcn(source,~)
       
        % check to see if game was won:
        if check_for_win()
            
            % popup message
            end_button = questdlg(...
                'Congratulations! You Win! Play again?',...
                'Play again?',...
                'Yes','No','Yes'); % options 'Yes','No'
                                   % default is 'Yes'
            
            % evaluate user choice
            switch end_button
                
                case 'Yes'    
                    slider_resetFcn()
                    
                case 'No'   
                    slider_quitFcn()
                    
                otherwise             
                    slider_quitFcn()       
            end            
        
        % if game was not won:
        else
            % "move" the button that was clicked, if possible
            try_empty_location(source)
        end
        
    end

    
    % reset board, start a new game
    function slider_resetFcn(~,~)
        
        % call new_game function to shuffle tiles and blank space
        new_game()       
    end


%% Game Functions


    % start a new game
    function new_game()
        
        % reset buttons
        set(slider_buttons,'BackgroundColor',slider_color)
        
        % generate new starting positions
        positions = randperm(16,16);
        
        % reassign numbers to these positions
        count = 1;
        for k = positions 
            
            set(slider_buttons(count),'String',num2str(k))
            
            % set tile 16 to the empty space
            if k == 16
                set(slider_buttons(count),'String','',...
                                        'BackgroundColor', empty_color)
            end
            
            count = count + 1;
        end
    end


    % check for win
    function [win] = check_for_win()
        
        try_win = true;
        
        % if all buttons are in order
        for k = 1:15
            this_string = get(slider_buttons(k),'String');
            if ~strcmp(this_string,num2str(k))
                try_win = false;
                break
            end          
        end
        
        if try_win
            win = true;
        else
            win = false;
        end
    end


    % try to "move" clicked button to adjacent empty space
    function try_empty_location(source)
        
        % get indeces of surrounding locations in slider_buttons
        this_loc = find(slider_buttons == source);
        
        loc_above = this_loc - 4;
        loc_below = this_loc + 4;
        loc_left = this_loc - 1;
        loc_right = this_loc + 1;
 
        slider_indeces = [loc_left loc_above loc_right loc_below];
        
        % logically index object handles (>0 and <= 16)
        handles_to_check = slider_buttons(...
            slider_indeces(slider_indeces > 0 & slider_indeces <= 16));
        
        % string value to swap
        source_string = get(source,'String');
        
        % evaluate each surrounding slider button
        for i = 1:length(handles_to_check)
            
            % get string value
            number = get(handles_to_check(i),'String');
            
            % empty space found
            if strcmp(number,'')
                % move button to empty space
                set(handles_to_check(i),'String',source_string,...
                                    'BackgroundColor',slider_color)
                                
                % set source color to empty
                set(source,'String','','BackgroundColor',empty_color)
                break
            end
        end % for
    end

end