function overlay_plot(view_low, view_high, time, fs, filtered_signal, shortlong_overlap, shortlong_overlap_index, long_smooth, short_smooth)
    
    signal_absolute = abs(filtered_signal);

    figure(1);
    subplot(3,1,1);
    plot(time, signal_absolute,'cyan');
    
    grid("on");
    title('Zebra Finch Song');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('Filtered Audio');
    xlim([view_low view_high]);
    
    subplot(3,1,2);
    plot(time, long_smooth, 'b', ...
        time, short_smooth, 'g');
    hold("on");
    for i=1:length(shortlong_overlap)
        plot(shortlong_overlap_index{i},shortlong_overlap{i},'r');
    end

    grid("on");
    title('Levels');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('smooth long','smooth short','overlap');
    xlim([view_low view_high]);

    %% Spectrograph
    window_size = 1024;  % Window size in samples
    overlap = 512;  % Overlap size in samples
    [S, f, t] = spectrogram(filtered_signal, hamming(window_size), overlap, window_size, fs);
    
    % Convert power spectral density to dB (log scale)
    SdB = 10 * log10(abs(S));
    
    subplot(3,1,3);
    imagesc(t, f, SdB);
    axis xy;
    colormap('turbo');
    
    %colorbar;
    % set(colorbar,'position',[.15 .1 .1 .3])
    title('Spectrogram');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([view_low view_high]);
    
    %% Displaying Detected Syllables
    figure(3);
    subplot(3,1,1);
    plot(time,filtered_signal,'b','LineWidth', 0.5);
    hold("on");
    for i=1:length(shortlong_overlap)
        ytemp = -0.02*ones(size(shortlong_overlap_index{i}));
        plot(shortlong_overlap_index{i},ytemp,'magenta','LineWidth', 2);
    end
    title('Detected Syllables');
    xlabel('Time (s)');
    xlim([view_low view_high]);
    ylabel('Amplitude');
    legend('Filtered Signal','Detected Syllable','Location','best');
    grid("on");
    
    subplot(3,1,2);
    imagesc(t, f, SdB);
    axis xy;
    colormap('turbo');
    hold("on");
    for i=1:length(shortlong_overlap)
        ytemp = 10000*ones(size(shortlong_overlap_index{i}));
        plot(shortlong_overlap_index{i},ytemp,'black','LineWidth', 2);
    end
    %colorbar;
    % set(colorbar,'position',[.15 .1 .1 .3])
    title('Spectrogram');
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    xlim([view_low view_high]);
    
    subplot(3,1,3);
    plot(time, long_smooth, 'b', ...
        time, short_smooth, 'g');
    hold("on");
    for i=1:length(shortlong_overlap)
        plot(shortlong_overlap_index{i},shortlong_overlap{i},'r');
    end
    grid("on");
    title('Levels');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('smooth long','smooth short','overlap','Location','best');
    xlim([view_low view_high]);

end
