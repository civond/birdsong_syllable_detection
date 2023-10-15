function [shortlong_overlap, shortlong_overlap_index, long_smooth, short_smooth] = detect(filtered_signal, fs, time, time_long, time_short)
    signal_absolute = abs(filtered_signal);
    long_samples = (fs/1000) *time_long;
    coeff_long = ones(1, long_samples)/long_samples;
    long_weights = [1:1:(long_samples)/2, (long_samples)/2:-1:1]/long_samples; % weights
    long_smooth = conv(signal_absolute, coeff_long.*long_weights, 'same');
    
    short_samples = (fs/1000) *time_short;
    coeff_short = ones(1, short_samples)/short_samples;
    short_weights = [1:1:(short_samples)/2, (short_samples)/2:-1:1]/short_samples; % weights
    short_smooth = conv(signal_absolute, coeff_short.*short_weights,'same');
    
    temp = zeros(1,length(signal_absolute));
    temp_index = zeros(1,length(signal_absolute));
    
    for n=1:length(long_smooth)
        m=n;
        if short_smooth(n) - long_smooth(n) > 0.0005
            temp(n) = short_smooth(n);
            temp_index(n) = time(n);
        end
    end
    
    shortlong_overlap = {};
    shortlong_overlap_index = {};
    
    cell_val = [];
    cell_ind = [];
    minimum_length = 1000;
    
    for i = 1:length(temp)
        if temp(i) ~= 0
            cell_val = [cell_val, temp(i)];
            cell_ind = [cell_ind, temp_index(i)];
        elseif ~isempty(cell_val)
              
            shortlong_overlap{end+1} = cell_val;
            cell_val = [];
            shortlong_overlap_index{end+1} = cell_ind;
            cell_ind = [];
               
        end
    end
    
    minimum_length = 1000; % minimum number of samples to be considerered a syllable
    index_rem = [];
    for n = 1:length(shortlong_overlap)
        if length(shortlong_overlap{n}) < minimum_length
            index_rem = [index_rem, n];
        end
    end
    shortlong_overlap(index_rem) = [];
    shortlong_overlap_index(index_rem) = [];
end