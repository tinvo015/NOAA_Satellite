clear all;
close all;

% Resample and perform Hilbert Transform input signal
% To demodulate
[y, fs] = audioread('TinNathan_modfinaltest1.wav');
y = resample(y, 16640, 16000);
y0 = hilbert(y);
y0i = imag(y0);

y2 = y.^2 + y0i.^2;
y = sqrt(y2);


% Create filter w/ cut-off freq of 2.4kHz to remove higher frequencies
fc = 2400;
Fs_new = 16640;

F = fdesign.lowpass('N,F3db', 6, fc, Fs_new);
d = design(F);
y_baseband = filtfilt(d.Numerator, 1, y);

y1 = decimate(y_baseband, 4, 6);

% Creates sync A 
sync_A = zeros(1, 39);
sync_A(:) = 0;
for i = 5:4:30
    sync_A(i:(i+1)) = 1;
end

% Remove beginning points since it may be corrupted
y1 = y1(10000:end);

% Create a line vector to normalize the values of input signal
n = polyfit([1:2080]', y1(1:2080), 1);
x = [1:2080]';
lin = y1(2080) - n(1)*x;

% Use convolution to find the end of sync A frame
c = conv(sync_A', y1(1:2080) .* lin);
c = c(1:2080);
[max_v, max_i] = max(c);

% Loops through and put together data A and data B frames next to each
% other
temp = [];
image = [];
i = max_i;
j = 1;
while i < length(y1) - 2100
    i = i + 47;
    
    temp = y1(i:i + 908);
    i = i + 909 + 45 + 39 + 47;
    image(j,:) = [temp' y1(i:i + 908)'];
    i = i + 909 + 45 + 39;    
    j = j+1;
    
end

imwrite(image, 'TinNathan_finaltest1.jpg');
%imshow(image);   