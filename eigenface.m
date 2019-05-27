% image loading
n = length(dir('test4/*.png')); %the number of images
hei = 63;
wid = 50;
x = zeros(n, hei*wid); %height*width
for k=1:n,
    fname = sprintf('test4/%d.png',k); %file loading
    img = double(rgb2gray(imread(fname)));
    x(k,:) = (img(:))';
end;
display("image loading")

% pca calculation
c = cov(x);
[v, d] = eig(c);
display("pca")

% average face calculation
face = zeros(hei,wid);
face(:) = mean(x);
imwrite(uint8(face), 'test4/eigenface/avg.png');
display("average face")

% eigenfaces (first k faces)
for k=1:7,
    fname = sprintf('test4/eigenface/eig%d.png',k);
    face(:) = v(:,hei*wid-k+1);
    imwrite(uint8(face/max(face(:))*255), fname);
end;
display("get eigenfaces")

% reconstruction using only k eigenfaces
cnt = [7, 5, 3, 2];
for k=cnt,
    % K-L transform
    v_k = v(:,hei*wid-k+1:hei*wid);
    y_k = x*v_k;
    % reconstruction
    x_recons = v_k*y_k';
    for i=1:n,
        fname = sprintf('test4/eigenface/%dres%d.png',i,k);
        face(:) = x_recons(:,i);
        imwrite(uint8(face), fname);
    end;
end;
