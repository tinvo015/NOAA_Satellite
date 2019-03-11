clear all;
close all;

[y, fs] = audioread('finaltest3.wav');
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

y1 = decimate(y_baseband, 4, 6);

% Creates sync A 
sync_A = zeros(1, 39);
sync_A(:) = 0;
for i = 5:4:30
    sync_A(i:(i+1)) = 1;
end

y1 = y1(2300:end);

c = conv(sync_A', y1(1:2080));
c = c(1:2080);
[max_v, max_i] = max(c);

% imax = mod(max_i, 2080);
% imax = 2080 - imax;

image = [];
% y1 = y1(max_i:end);

i = max_i;
j = 1;
while i < length(y1) - 2100
    i = i + 47;
    image(j,:) = y1(i:i + 908);
    j = j+1;
    i = i + (2080 - (47));
    
end

%image = uint8(image);
figure();
subplot(2, 2, 3);
plot(c);
title('cross correlation');
subplot(2, 2, 2);
plot(sync_A);
title('sync A pattern');
subplot(2, 2, 1);
plot(y1(1:2080));
title('one data frame length of recieved signal');
subplot(2, 2, 4);
imshow(image);

figure();
plot(y1);
    