clear all;
close all;

[y, fs] = audioread('finaltest2.wav');
y = resample(y, 16640, 16000);
y0 = hilbert(y);
y0i = imag(y0);

y2 = y.^2 + y0i.^2;
y = sqrt(y2);

fc = 2400;
Fs_new = 16640;

F = fdesign.lowpass('N,F3db', 6, fc, Fs_new);
d = design(F);
y_baseband = filtfilt(d.Numerator, 1, y);

y1 = decimate(y_baseband, 4);

% Creates sync A 
sync_A = zeros(1, 39);
sync_A(:) = 0;
for i = 5:4:30
    sync_A(i:(i+1)) = 1;
end

y1 = y1(10000:end);

c = xcorr(sync_A',y1);
c = c(39:end);
[max_v, max_i] = max(c(1:3000));

image = [];
y1 = y1(max_i:end);

i = 1;
j = 1;
while i < length(y1) - 2100
    i = i + 39 + 47;
    image(j,:) = y1(i:i + 908);
    j = j+1;
    i = i + (2080 - (39+47));
    
end

%image = uint8(image);
imshow(image);
    