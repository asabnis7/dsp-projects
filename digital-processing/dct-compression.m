% ECE 4270 - HW6 - Problem 2 - DCT image compression
% -------------------------------------------------------------------------
% Part A
% Read in color image
img = imread('puppies.jpg');
figure, imshow(img), title('Original Image');
img = double(img);

% Perform DCT along rows and columns
DCT_img = dct(dct(img,[],1),[],2);

% Split image into RGB components for separate analysis
R = DCT_img(:,:,1);
G = DCT_img(:,:,2);
B = DCT_img(:,:,3);
% Convert into row vectors
R_x = R(:);
G_x = G(:);
B_x = B(:);

% Find coefficients required for minimum energy threshold per colorspace
[~,ind1] = sort(abs(R_x),'descend'); % Red
co1 = 1;
while norm(R_x(ind1(1:co1)))/norm(R_x) < 0.99
co1 = co1 + 1;
end
[~,ind2] = sort(abs(G_x),'descend'); % Green
co2 = 1;
while norm(G_x(ind2(1:co2)))/norm(G_x) < 0.99
co2 = co2 + 1;
end
[~,ind3] = sort(abs(B_x),'descend'); % Blue
co3 = 1;
while norm(B_x(ind3(1:co3)))/norm(B_x) < 0.99
co3 = co3 + 1;
end

% Remove unnecessary coefficients
R(abs(R) < R_x(co1)) = 0;
G(abs(G) < G_x(co2)) = 0;
B(abs(B) < B_x(co3)) = 0;

percent1 = ((co1+co2+co3)/(numel(R)*3))*100;
RGB1 = cat(3,R,G,B);

% Repeat with 99.9% energy conservation
% Split image into RGB components for separate analysis
R = DCT_img(:,:,1);
G = DCT_img(:,:,2);
B = DCT_img(:,:,3);
% Convert into row vectors
R_x = R(:);
G_x = G(:);
B_x = B(:);

% Find coefficients required for minimum energy threshold per colorspace
[~,ind1] = sort(abs(R_x),'descend'); % Red
co1 = 1;
while norm(R_x(ind1(1:co1)))/norm(R_x) < 0.999
co1 = co1 + 1;
end
[~,ind2] = sort(abs(G_x),'descend'); % Green
co2 = 1;
while norm(G_x(ind2(1:co2)))/norm(G_x) < 0.999
co2 = co2 + 1;
end
[~,ind3] = sort(abs(B_x),'descend'); % Blue
co3 = 1;
while norm(B_x(ind3(1:co3)))/norm(B_x) < 0.999
co3 = co3 + 1;
end

% Remove unnecessary coefficients
R(abs(R) < R_x(co1)) = 0;
G(abs(G) < G_x(co2)) = 0;
B(abs(B) < B_x(co3)) = 0;

percent2 = ((co1+co2+co3)/(numel(R)*3))*100;
RGB2 = cat(3,R,G,B);

% Perform inverse DCT on both images 
img_99 = idct(idct(RGB1,[],2),[],1);
img_999 = idct(idct(RGB2,[],2),[],1);
 
% Display both images
figure, imshow(uint8(img_99)), title('Image with 99% of DCT Coefficient Energy Conserved');
figure, imshow(uint8(img_999)), title('Image with 99.9% of DCT Coefficient Energy Conserved');

% -------------------------------------------------------------------------
% Part B
% Find FFT of image
FFT_img = fft(fft(img,[],1),[],2);

% Split image into RGB components for separate analysis
R = FFT_img(:,:,1);
G = FFT_img(:,:,2);
B = FFT_img(:,:,3);
% Convert into row vectors
R_x = R(:);
G_x = G(:);
B_x = B(:);

% Find coefficients required for minimum energy threshold per colorspace
[~,ind1] = sort(abs(R_x),'descend'); % Red
co1 = 1;
while norm(R_x(ind1(1:co1)))/norm(R_x) < 0.99
co1 = co1 + 1;
end
[~,ind2] = sort(abs(G_x),'descend'); % Green
co2 = 1;
while norm(G_x(ind2(1:co2)))/norm(G_x) < 0.99
co2 = co2 + 1;
end
[~,ind3] = sort(abs(B_x),'descend'); % Blue
co3 = 1;
while norm(B_x(ind3(1:co3)))/norm(B_x) < 0.99
co3 = co3 + 1;
end

% Remove unnecessary coefficients
R(abs(R) < R_x(co1)) = 0;
G(abs(G) < G_x(co2)) = 0;
B(abs(B) < B_x(co3)) = 0;

percent3 = ((co1+co2+co3)/(numel(R)*3))*100;
RGB3 = cat(3,R,G,B);

% Repeat with 99.9% energy conservation
% Split image into RGB components for separate analysis
R = FFT_img(:,:,1);
G = FFT_img(:,:,2);
B = FFT_img(:,:,3);
% Convert into row vectors
R_x = R(:);
G_x = G(:);
B_x = B(:);

% Find coefficients required for minimum energy threshold per colorspace
[~,ind1] = sort(abs(R_x),'descend'); % Red
co1 = 1;
while norm(R_x(ind1(1:co1)))/norm(R_x) < 0.999
co1 = co1 + 1;
end
[~,ind2] = sort(abs(G_x),'descend'); % Green
co2 = 1;
while norm(G_x(ind2(1:co2)))/norm(G_x) < 0.999
co2 = co2 + 1;
end
[~,ind3] = sort(abs(B_x),'descend'); % Blue
co3 = 1;
while norm(B_x(ind3(1:co3)))/norm(B_x) < 0.999
co3 = co3 + 1;
end

% Remove unnecessary coefficients
R(abs(R) < R_x(co1)) = 0;
G(abs(G) < G_x(co2)) = 0;
B(abs(B) < B_x(co3)) = 0;

percent4 = ((co1+co2+co3)/(numel(R)*3))*100;
RGB4 = cat(3,R,G,B);

% Perform inverse FFT on both images 
img_fft99 = ifft(ifft(RGB3,[],2),[],1);
img_fft999 = ifft(ifft(RGB4,[],2),[],1);
 
% Display both images
figure, imshow(uint8(img_fft99)), title('Image with 99% of FFT Coefficient Energy Conserved');
figure, imshow(uint8(img_fft999)), title('Image with 99.9% of FFT Coefficient Energy Conserved');
