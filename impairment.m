clear all;
close all;



snr = 10; %in dB

[y, fs] = audioread('finaltest1.wav');

y_power = rms(y)^2;

output = awgn(y,snr,y_power);

audiowrite('TinNathan_impairP10dB.wav', output, fs);

