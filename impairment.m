clear all;
close all;

snr = 10; %in dB

[y, fs] = audioread('finaltest1.wav');
y_power = rms(y)^2; % calculate power of input signal

output = awgn(y,snr,y_power); %adds AWGN based on signal power and desired SNR

audiowrite('TinNathan_impairP10dB.wav', output, fs);

