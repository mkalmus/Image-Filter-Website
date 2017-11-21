%Read an Image
Img = imread('static/images/in');
I = double(Img); 

%Standard Deviation, controls degree of blurring
sigma = 3;
%Window size
siz = floor(sigma * 3);
[x,y]=meshgrid(-siz:siz,-siz:siz);

%Used to find edge of image
X = size(x,1)-1;
Y = size(y,1)-1;

%Making the Gaussian Kernel
Exponent = -(x.^2+y.^2)/(2*sigma*sigma);
Kernel = exp(Exponent)/(2*pi*sigma*sigma);

%Initializing output
Output=zeros(size(I));

%Pad the vector with zeros 
I = padarray(I,[siz siz]);

%Convolving Image with Kernel, once for each dimension
for k = [1 2 3]
    for i = 1:size(I,1)-X
        for j =1:size(I,2)-Y
            Temp = I(i:i+X,j:j+X, k).*Kernel;
            Output(i,j,k)=sum(Temp(:));
        end
    end
end
%Image without Noise after Gaussian blur

imwrite(uint8(round(Output)), 'static/images/out.png');
