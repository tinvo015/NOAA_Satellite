clear all;
close all;

fs = 16000; %sampling freq for wav file

A = imread('modfinaltest1.jpg');
im_w = size(A,1);
A = rgb2gray(A);

% Converts to 1-d vector
A_final = []; 
A = double(A);


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

% Form APT
for i = 1:im_w
    A_add = A(i, :);
    APT = [sync_A, sd, A_add, td, sync_B, sd, A_add, td];
    APT = repmat(APT, [4, 1]);
    APT = APT(:)';
    
    A_final = [A_final APT];
    
end
A_final = A_final/255; % Rescale value so it's between -1 to 1 for audiowrite

t = [1:length(A_final)];
fc = 2.4/16.64;

y = A_final .* cos(2*pi*fc*t); % modulate
y = resample(y, fs, 16640); % resample to 16000
audiowrite('modfinaltest1.wav', y, fs);
