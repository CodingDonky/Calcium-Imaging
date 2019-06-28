function [ ] = test( )
root_fp = '/Users/newberry/Desktop/Pilo Analysis/';
test_fp = [root_fp,'Old Mice/Pilo 10_13_17_cage3371180_mouse3/Data-Shannon-20181213/'];
imported_data = load( [ test_fp, '20171117_PiloMouse3_002 intensity data.mat'] );
% Loads the intensity data, and the firing cells' intensity data converted
% into binary.
intensityData = imported_data.intensityData; % [totalCells×frames]
binaryFiring = imported_data.binaryFiring; % [totalActiveCells×frames]
[totalActiveCells, num_frames] = size(binaryFiring);
totalCells = imported_data.totalCells;
% Less important data
firedNeurons = imported_data.firedNeurons; % list `totalActiveCells` long
threshold = imported_data.threshold;percentActiveCells = totalActiveCells/totalCells;
percentActiveCells = totalActiveCells/totalCells;

    function[ firing_frames ] = get_start_firing_frames_single_cell( binaryFiring_single_cell )
        firing_frames = [];
        event_number = 1; % The event number is the index of firing_times
        for frame=2:num_frames
            val_at_curr_frame = binaryFiring_single_cell(frame);
            val_at_prev_frame = binaryFiring_single_cell(frame-1);
            % If the current frame is a start frame 
            if val_at_curr_frame==1 && val_at_prev_frame==0
                start_frame = frame;
                firing_frames = [firing_frames, start_frame];
                event_number = event_number+1;
            end
        end
    end
    function[ num_events_in_window_per_frame, firing_synchrony_record] = ...
            get_synchronous_firing_bins_v3( synchrony_window_frames )
        % Return a NON-normalized cell array of synchronous firing
        % synchrony_array{2}=number of times two cells fire on the same frame
        
        firing_times = {};
        % firing_synchrony_record contains a correspondance of firing time to number of synchronous cells
        % Example: `firing_synchrony_record{3}==[1,2]` if the third active
        % cell fires twice, once alone, and once synchronized with one other cell
        firing_synchrony_record = {};
        for cell_i=1:totalActiveCells
            binaryFiring_single_cell = binaryFiring(cell_i,:);
            % firing_times encoded as: 
            %  start_time_1 = firing_times(1)
            firing_start_times = get_start_firing_frames_single_cell( binaryFiring_single_cell );
            firing_times{cell_i} = firing_start_times;
            firing_synchrony_record{cell_i} = zeros(length(firing_start_times),1);
        end
        
        num_events_in_window_per_frame = zeros(num_frames,1);
        for frame=2:num_frames
            % First need to find number of synchronous events in the window
            num_events_in_window = 0;
            for cell_i=1:synchrony_window_frames:totalActiveCells
                firing_times_single_cell = firing_times{ cell_i };
                
                for firing_time_single_cell_i=1:length(firing_times_single_cell)
                    % Find number of frames seperating `frame` and the current firing time
                    firing_time_single_cell = firing_times_single_cell(firing_time_single_cell_i);
                    frame_seperation = abs( firing_time_single_cell-frame );
                    % If the firing time is close enough to the frame, it
                    %     counts as firing in this window
                    if frame_seperation <= synchrony_window_frames
                        num_events_in_window = num_events_in_window + 1;
                    end
                end
            end
            num_events_in_window_per_frame(frame) = num_events_in_window;
            
            % Now, record the number of synchronous events in the window in
            % `firing_synchrony_record`
            for cell_i=1:totalActiveCells
                
                for firing_time_single_cell_i=1:length(firing_times_single_cell)
                    % Find number of frames seperating `frame` and the current firing time
                    firing_time_single_cell = firing_times_single_cell(firing_time_single_cell_i);
                    frame_seperation = abs( firing_time_single_cell-frame );
                    % If the firing time is close enough to the frame, it
                    %     counts as firing in this window
                    if frame_seperation <= synchrony_window_frames
                        disp('\n')
                        disp(cell_i)
                        disp(firing_time_single_cell_i)
                        disp(length( firing_synchrony_record{cell_i}))
                        current_stored_val = firing_synchrony_record{cell_i}(firing_time_single_cell_i);
                        % Store the largest number of synchronous cells found in the sliding window. 
                        % If the cell firing alone in one window, and firing with 2 other cells in another window, then
                        % record as firing with 2 other cells.
                        firing_synchrony_record{cell_i}(firing_time_single_cell_i) ...
                            = max( current_stored_val, num_events_in_window);
                    end
                end
            end
        end
    end



[firing_synchrony_rec, synchrony_list] = get_synchronous_firing_bins_v3( 6 );

firing_synchrony_rec

synchrony_list

end

