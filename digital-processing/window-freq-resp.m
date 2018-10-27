% ECE 4271 - HW6 - Problem 1 - Window Freq Responses

load('HW6.mat');

% Part A
xx1 = xx(1:10); % Shorten sequences as required
xx2 = xx(1:50);
xx3 = xx(1:100);
 % Find freq response of sequence
[dtft1, w1] = freqz(xx1,1);
[dtft2, w2] = freqz(xx2,1);
[dtft3, w3] = freqz(xx3,1);
% Create symmetry
dtft1 = [flip(dtft1); dtft1];
w1 = [-flip(w1); w1]/pi;
dtft2 = [flip(dtft2); dtft2];
w2 = [-flip(w2); w2]/pi;
dtft3 = [flip(dtft3); dtft3];
w3 = [-flip(w3); w3]/pi;
% Create plots
figure, subplot(3,1,1), plot(w1, abs(dtft1));
title('Frequency Response with Sequence Length 10');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,2), plot(w2, abs(dtft2));
title('Frequency Response with Sequence Length 50');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,3), plot(w3, abs(dtft3));
title('Frequency Response with Sequence Length 100');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
% Find DFT of sequence
dft1 = fftshift(fft(xx1,length(xx1)));
dft2 = fftshift(fft(xx2,length(xx2)));
dft3 = fftshift(fft(xx3,length(xx3)));
% Create normalized frequency vector
wa = linspace(-pi,pi,length(dft1))/pi;
wb = linspace(-pi,pi,length(dft2))/pi;
wc = linspace(-pi,pi,length(dft3))/pi;
% Create plots
figure, subplot(3,1,1), stem(wa, abs(dft1));
title('DFT with Sequence Length 10');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,2), stem(wb, abs(dft2));
title('DFT with Sequence Length 50');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,3), stem(wc, abs(dft3));
title('DFT with Sequence Length 100');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');

% Part B
dft1 = fftshift(fft(xx1,4*length(xx1))); % Increase DFT length
dft2 = fftshift(fft(xx2,4*length(xx2)));
dft3 = fftshift(fft(xx3,4*length(xx3)));
% Create frequency vector
wa = linspace(-pi,pi,length(dft1))/pi;
wb = linspace(-pi,pi,length(dft2))/pi;
wc = linspace(-pi,pi,length(dft3))/pi;
% Plot DFTs
figure, subplot(3,1,1), stem(wa, abs(dft1));
title('DFT with Sequence Length 40');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,2), stem(wb, abs(dft2));
title('DFT with Sequence Length 200');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,3), stem(wc, abs(dft3));
title('DFT with Sequence Length 400');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');

% Part C
h10 = xx1'.*hanning(10); % Apply hanning windows
h50 = xx2'.*hanning(50);
h100 = xx3'.*hanning(100);
% Find windowed frequency response
[dtft1, w1] = freqz(h10,1);
[dtft2, w2] = freqz(h50,1);
[dtft3, w3] = freqz(h100,1);
% Create symmetry
dtft1 = [flip(dtft1); dtft1];
w1 = [-flip(w1); w1]/pi;
dtft2 = [flip(dtft2); dtft2];
w2 = [-flip(w2); w2]/pi;
dtft3 = [flip(dtft3); dtft3];
w3 = [-flip(w3); w3]/pi;
% Create subplots
figure, subplot(3,1,1), plot(w1, abs(dtft1));
title('Frequency Response (Windowed) with Sequence Length 10');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,2), plot(w2, abs(dtft2));
title('Frequency Response (Windowed) with Sequence Length 50');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,3), plot(w3, abs(dtft3));
title('Frequency Response (Windowed) with Sequence Length 100');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
% Find windowed DFTs
dft1 = fftshift(fft(h10,length(h10)));
dft2 = fftshift(fft(h50,length(h50)));
dft3 = fftshift(fft(h100,length(h100)));
% Create frequency vector
wa = linspace(-pi,pi,length(dft1))/pi;
wb = linspace(-pi,pi,length(dft2))/pi;
wc = linspace(-pi,pi,length(dft3))/pi;
% Create subplots
figure, subplot(3,1,1), stem(wa, abs(dft1));
title('DFT (Windowed) with Sequence Length 10');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,2), stem(wb, abs(dft2));
title('DFT (Windowed) with Sequence Length 50');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
subplot(3,1,3), stem(wc, abs(dft3));
title('DFT (Windowed) with Sequence Length 100');
xlabel('Normalized Frequency (\pi)'), ylabel('Amplitude');
