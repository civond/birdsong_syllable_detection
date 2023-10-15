clear all;
close all;

%% Parameters

% Highpass filter cutoff frequencies
transition_low = 200; % Hz
transition_high = 250; % Hz
filter_order = 200;

% Moving average
time_long = 360; % 400 ms
time_short = 60; % 60 ms
extension = 20; % ms

% Graph view
view_low = 2;
view_high = 5;

%% Data
[signal, fs] = audioread("finch_data\bird109_95540_on_Oct_01_10_25.wav");
dt = 1/fs;
time = 0:dt:(length(signal)*dt)-dt;

%% Preprocessing
normalized_low = transition_low/(fs/2);
normalized_high = transition_high/(fs/2);

[b,a] = butter(8, transition_high/(fs/2),'high');

%filter_coeffs = firls(filter_order, [0 normalized_low normalized_high 1], [0 0 1 1]); %  this is a highpass linphase filter
% filtered_signal = filtfilt(filter_coeffs,1,signal);

filtered_signal = filtfilt(b,a,signal);

%% Syllable Detection using Weighted Moving Average
signal_absolute = abs(filtered_signal);
[slo, slo_index, ls, ss] = detect(filtered_signal, fs, time, time_long, time_short);
overlay_plot(view_low, view_high, time, fs, filtered_signal, slo, slo_index, ls, ss);
