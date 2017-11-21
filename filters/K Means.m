I = double(imread('static/images/in'));

k = 4;
means = zeros(k, 3);

dim = size(I,1);

means = zeros(k, 3);
rand_x = ceil(dim*rand(k, 1));
rand_y = ceil(dim*rand(k, 1));
for i = 1:k
    means(i,:) = I(rand_x(i), rand_y(i), :);
end

nearest_mean = zeros(dim);

max_iterations = 100;
for itr = 1:max_iterations
    
    new_means = zeros(size(means));
    num_assigned = zeros(k, 1);
    
    for i = 1:dim
        for j = 1:dim
            r = I(i,j,1); g = I(i,j,2); b = I(i,j,3);
            diff = ones(k,1)*[r, g, b] - means;
            distance = sum(diff.^2, 2);
            [val ind] = min(distance);
            nearest_mean(i,j) = ind;
            
            new_means(ind, 1) = new_means(ind, 1) + r;
            new_means(ind, 2) = new_means(ind, 2) + g;
            new_means(ind, 3) = new_means(ind, 3) + b;
            num_assigned(ind) = num_assigned(ind) + 1;
        end
    end
    
    for i = 1:k
        if (num_assigned(i) > 0)
            new_means(i,:) = new_means(i,:) ./ num_assigned(i);
        end
    end
    
    d = sum(sqrt(sum((new_means - means).^2, 2)))
    if d < 0.001
        break
    end
    
    means = new_means;
end

means = round(means);

O = double(imread('static/images/in'));
O_dim = size(O, 1);

for i = 1:O_dim
    for j = 1:O_dim
        r = O(i,j,1); g = O(i,j,2); b = O(i,j,3);
        diff = ones(k,1)*[r, g, b] - means;
        distance = sum(diff.^2, 2);
        [val ind] = min(distance);
        O(i,j,:) = means(ind,:);
    end 
end

imwrite(uint8(round(O)), 'static/images/out.png');

