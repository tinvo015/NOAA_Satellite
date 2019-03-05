clear all;
close all;

fs = 16000; %sampling freq for wav file
nbit = 16;
T_sync = 1/4160; %period of 1 word
fc = 2400; %carrier freq

A = imread('modfinaltest1.jpg');
im_w = size(A,1);
A = rgb2gray(A);
%imshow(A);



%w = 909;
%h = 1818;

% Converts to 1-d vector
A_2 = dec2bin(A);
A_10 = bin2dec(A_2);

%PAM_A_10 = pammod(A_10, nbit);

% Creates sync A and B for APT
sync_A = zeros(1, 39*im_w);
sync_A(:) = 11;
for i = 4:4:30
    sync_A(i*im_w:(i+2)*im_w) = 244;
end

sync_B = zeros(1, 39*im_w);
sync_B(:) = 11;
for i = 4:5:38
    sync_B(i*im_w:(i+3)*im_w) = 244;
end

% Telemetry and Space Data are 0s
sd = zeros(1, 47*im_w);
td = zeros(1, 45*im_w);

% Form APT and modulate
APT = [sync_A, sd, A_10', td, sync_B, sd, A_10', td];
y = modulate(APT, fc, fs);
%y = lowpass(y, 1000, fs);
audiowrite('s1.wav', y, fs);
