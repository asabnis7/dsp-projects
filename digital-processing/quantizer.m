% HW3 - Recreate Quantization Figures

% Figure 4.57
% Define signal vector
n = 1:150;
xn = 0.99*cos(n/10);
xm = 1;

% 3-bit quantization
b3 = 2;
q3 = xm/(2^b3);
xq3 = round(xn/q3)*q3; % Quantize signal xn with 3 bits
% Make sure values greater than 0.75 are rounded down
xq3(xq3>(b3+1)*q3) = (b3+1)*q3; 

% 8-bit quantization
b8 = 7;
q8 = xm/(2^b8); 
xq8 = round(xn/q8)*q8; % Quantize signal xn with 8 bits

% Create Figure 4.57

% (a)
subplot(4,1,1), stem(n, xn, 'filled','MarkerSize',2);
% Edit axis, labels and ticks
axis([0 150 -1.2 1.2]),xlabel('(a)');
xticks([0 50 100 150]),xticklabels({'0','50','100','150 \itn'});

% (b)
subplot(4,1,2), stem(n, xq3, 'filled','MarkerSize',2);
% Draw lines on plot
line_n = [0 n(end)];
for i = -4:3
    line_q3 = [i*q3 i*q3];
    line(line_n, line_q3,'LineStyle', '--', 'Color', 'Black')
end
axis([0 150 -1.2 1.2]),xlabel('(b)');
xticks([0 50 100 150]),xticklabels({'0','50','100','150 \itn'});

% (c)
subplot(4,1,3), stem(n, xq3-xn, 'filled','MarkerSize',2);
line(line_n, [max(xq3-xn) max(xq3-xn)],'LineStyle', '--', 'Color', 'Black')
line(line_n, [-max(xq3-xn) -max(xq3-xn)],'LineStyle', '--', 'Color', 'Black')
axis([0 150 -0.3 0.3]),xlabel('(c)');
xticks([0 50 100 150]),xticklabels({'0','50','100','150 \itn'});

% (d)
subplot(4,1,4) ,stem(n, xq8-xn, 'filled','MarkerSize',2);
line(line_n, [-min(xq8-xn) -min(xq8-xn)],'LineStyle', '--', 'Color', 'Black')
line(line_n, [min(xq8-xn) min(xq8-xn)],'LineStyle', '--', 'Color', 'Black')
axis([0 150 -8e-3 8e-3]), xlabel('(d)');
xticks([0 50 100 150]),xticklabels({'0','50','100','150 \itn'});


% Figure 4.59
% Resample signal with 101000 samples
ne = 0:101000;
xne = 0.99*cos(ne/10);

% 8-bit quantization
b8 = 7;
q8 = xm/(2^b8);
xq8 = round(xne/q8)*q8; % Quantize with 8 bits

% 16-bit quantization
b16 = 15;
q16 = xm/(2^b16);
xq16 = round(xne/q16)*q16; % Quantize with 16 bits

% Find quantization noise between signal and quantized variant
e8 = xq8-xne;
e16 = xq16-xne;

% Create amplitude histograms with 101 bins
% 16 bit quantization noise
figure, subplot(2,1,1), hist(e16,101);
xlabel('\ite'), ylabel('Number');
title('Histograms for Quantization Noise Samples');
legend({'\itB+1 = 16'});
axis([-2e-5 2e-5 0 1500]);

% 8 bit quantization noise
subplot(2,1,2), hist(e8, 101);
xlabel('\ite'), ylabel('Number');
legend({'\itB+1 = 8'});
axis([-4e-3 4e-3 0 1500]);
