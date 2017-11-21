I = rgb2gray(imread('static/images/in'));

threshold = 0.5

k = [1 2 1; 0 0 0; -1 -2 -1];
H = conv2(double(I), k, 'same');
V = conv2(double(I), k','same');

E = sqrt(H.*H + V.*V);
O = uint8((E > threshold) * 255);
imwrite(O, 'static/images/out.png');

