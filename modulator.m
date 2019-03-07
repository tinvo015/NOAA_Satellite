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
A_final = []; 
A = double(A);

%PAM_A_10 = pammod(A_10, nbit);

% Creates sync A and B for APT
sync_A = zeros(1, 39);
sync_A(:) = 11;
for i = 5:4:30
    sync_A(i:(i+1)) = 244;
end

sync_B = zeros(1, 39);
sync_B(:) = 11;
for i = 5:5:38
    sync_B(i:(i+2)) = 244;
end

% Telemetry and Space Data are 0s
sd = zeros(1, 47);
td = zeros(1, 45);

for i = 1:im_w
    A_add = A(i, :);
    % Form APT and modulate
    APT = [sync_A, sd, A_add, td, sync_B, sd, A_add, td];
    APT = repmat(APT, [4, 1]);
    APT = APT(:)';
    
    A_final = [A_final APT];
    
end
A_final = A_final/255;

t = [1:length(A_final)];

fs = 2.4/16.64;

y = A_final .* cos(2*pi*fs*t);
y = resample(y, 16000, 16640);
audiowrite('s1.wav', y, 16000);
